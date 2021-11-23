function [t, sig]=OSC(Fmax, Fo, Tw, stype)

if nargin~=4  error('�Է� ���� 4���̴�!'), end
if (Fo>=Fmax)  error('���ļ� ���谡 �������ϴ�!'),  end
if nargout~=2  error('��� ���� 2���̴�!'), end

Fs=2*Fmax;  Ts=1/Fs;     % ǥ��ȭ ���ļ�, ǥ�� �ֱ�
To=1/Fo;                 % ��ȣ�� �⺻ �ֱ�
N=round(Tw/Ts);          % ��ȣ ����(ǥ�� ��)
t=[0: N-1]'*Ts;          % �ð� ����
tm=t-fix(Fo*t)*To;       % �ð� ������ modulo(To) ����
sig=zeros(N, 1);         % ��ȣ ������ �ʱ�ȭ


% ��ȣ �߻� ##########################################
if stype=='s'     % ������
    sig=sin(2*pi*Fo*tm);
elseif stype=='r' % ������
    sig=(tm<To/2)-(tm>=To/2);
elseif stype=='t' % �ﰢ��
    sig=(tm<To/2)*2*Fo.*tm+(tm>=To/2).*(2-2*Fo*tm);
    sig=(sig-0.5)*2;
elseif stype=='sw'% ���� ��ȣ
    sig=Fo*tm;
elseif stype=='g' % ���� �޽���
    T1=To/2;  T2=To/5;
    for n=1:N
        if tm(n)<T1  sig(n)=0.5*(1-cos(pi*tm(n)/T1));
        elseif (tm(n)>=T1)&(tm(n)<(T1+T2))  sig=cos(0.5*pi*(tm(n)-T1)/T2);
        elseif tm(n)>=(T1+T2)  sig(n)=0;
        end
    end
else error('���� ��ȣ�̴�!')
end
