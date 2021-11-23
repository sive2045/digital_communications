function [t, sig]=OSC(Fmax, Fo, Tw, stype)

if nargin~=4  error('입력 수는 4개이다!'), end
if (Fo>=Fmax)  error('주파수 관계가 부적절하다!'),  end
if nargout~=2  error('출력 수는 2개이다!'), end

Fs=2*Fmax;  Ts=1/Fs;     % 표본화 주파수, 표본 주기
To=1/Fo;                 % 신호의 기본 주기
N=round(Tw/Ts);          % 신호 길이(표본 수)
t=[0: N-1]'*Ts;          % 시간 벡터
tm=t-fix(Fo*t)*To;       % 시간 벡터의 modulo(To) 형태
sig=zeros(N, 1);         % 신호 벡터의 초기화


% 신호 발생 ##########################################
if stype=='s'     % 정현파
    sig=sin(2*pi*Fo*tm);
elseif stype=='r' % 구형파
    sig=(tm<To/2)-(tm>=To/2);
elseif stype=='t' % 삼각파
    sig=(tm<To/2)*2*Fo.*tm+(tm>=To/2).*(2-2*Fo*tm);
    sig=(sig-0.5)*2;
elseif stype=='sw'% 소인 신호
    sig=Fo*tm;
elseif stype=='g' % 성문 펄스열
    T1=To/2;  T2=To/5;
    for n=1:N
        if tm(n)<T1  sig(n)=0.5*(1-cos(pi*tm(n)/T1));
        elseif (tm(n)>=T1)&(tm(n)<(T1+T2))  sig=cos(0.5*pi*(tm(n)-T1)/T2);
        elseif tm(n)>=(T1+T2)  sig(n)=0;
        end
    end
else error('없는 신호이다!')
end
