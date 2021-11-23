function [t,voice]=voice_gen(Fmax,Tp,Tw,vtype)
if Fmax<5000  error('Fmax는 5kHz 이상이어야 한다!'), end
if nargin~=4  error('입력 수는 4개이다!'), end
if nargout~=2  error('출력 수는 2개이다!'), end

% 유성음 유형
if vtype=='a'
    formant=[650 1076 2463 3558 4631];  bw=[94 91 107 199 90];
elseif vtype=='e'
    formant=[415 1979 2810 3450 4387];  bw=[54 101 318 200 173];
elseif vtype=='i'
    formant=[223 2317 2974 3968 4424];  bw=[53 59 388 174 871];
elseif vtype=='u'
    formant=[232 597 2395 3850];  bw=[61 57 66 43];
else error('없는 유성음이다!')
end

% 내림 표본화(downsampling)
Ndown=round(Fmax/5000);
Fdown=Fmax/Ndown;

% 자연 주파수에 대한 공진 회로
Nformant=length(formant);  % 자연 주파수 갯수
A=zeros(Nformant, 3);  B=zeros(Nformant, 3);
for k=1: Nformant
    [b, a]=single_tune(Fdown, formant(k), bw(k));
    B(k, :)=0.8^(k-1)*b;  A(k, :)=a;
end

% 성도의 전달 함수
b1=B(1, :);  a1=A(1, :);
for k=2: Nformant
    [b1, a1]=parallel(b1, a1, B(k, :), A(k, :));
end

% 성문 펄스열 발생
Fp=1/Tp;
[t, glottis]=OSC(Fdown,Fp,Tw,'g');

% 유성음 발생
lipsig=filter(b1, a1, glottis);
b2=[1 -1];  a2=[1 0];
voice=filter(b2, a2, lipsig);

% 올림 표본화
voice=interp(voice, Ndown);    

%신호 정규화와 시간 벡터
voice=voice/max(voice);             % 진폭을 최대 1로 정규화
dt=t(2)-t(1);                        % 시간 간격
t=[0: length(voice)-1]'*dt/Ndown;    % 시간 벡터
