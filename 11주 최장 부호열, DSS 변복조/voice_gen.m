function [t,voice]=voice_gen(Fmax,Tp,Tw,vtype)
if Fmax<5000  error('Fmax�� 5kHz �̻��̾�� �Ѵ�!'), end
if nargin~=4  error('�Է� ���� 4���̴�!'), end
if nargout~=2  error('��� ���� 2���̴�!'), end

% ������ ����
if vtype=='a'
    formant=[650 1076 2463 3558 4631];  bw=[94 91 107 199 90];
elseif vtype=='e'
    formant=[415 1979 2810 3450 4387];  bw=[54 101 318 200 173];
elseif vtype=='i'
    formant=[223 2317 2974 3968 4424];  bw=[53 59 388 174 871];
elseif vtype=='u'
    formant=[232 597 2395 3850];  bw=[61 57 66 43];
else error('���� �������̴�!')
end

% ���� ǥ��ȭ(downsampling)
Ndown=round(Fmax/5000);
Fdown=Fmax/Ndown;

% �ڿ� ���ļ��� ���� ���� ȸ��
Nformant=length(formant);  % �ڿ� ���ļ� ����
A=zeros(Nformant, 3);  B=zeros(Nformant, 3);
for k=1: Nformant
    [b, a]=single_tune(Fdown, formant(k), bw(k));
    B(k, :)=0.8^(k-1)*b;  A(k, :)=a;
end

% ������ ���� �Լ�
b1=B(1, :);  a1=A(1, :);
for k=2: Nformant
    [b1, a1]=parallel(b1, a1, B(k, :), A(k, :));
end

% ���� �޽��� �߻�
Fp=1/Tp;
[t, glottis]=OSC(Fdown,Fp,Tw,'g');

% ������ �߻�
lipsig=filter(b1, a1, glottis);
b2=[1 -1];  a2=[1 0];
voice=filter(b2, a2, lipsig);

% �ø� ǥ��ȭ
voice=interp(voice, Ndown);    

%��ȣ ����ȭ�� �ð� ����
voice=voice/max(voice);             % ������ �ִ� 1�� ����ȭ
dt=t(2)-t(1);                        % �ð� ����
t=[0: length(voice)-1]'*dt/Ndown;    % �ð� ����
