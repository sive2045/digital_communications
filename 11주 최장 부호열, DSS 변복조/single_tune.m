function [b, a]=single_tune(Fmax, Fo, Bw)

if nargin~=3  error('입력 수는 3개이다!'), end
if (Fo>=Fmax)|(Bw>=Fmax)  error('주파수 관계가 부적절하다!'),  end
if nargout~=2  error('출력 수는 2개이다!'), end

% 중심 주파수와 대역폭의 디지털 주파수
Wo=Fo/Fmax*pi;  Ww=Bw/Fmax*pi;

% 공진 회로의 감쇄 상수
B=(Ww/2)^2;
C=cos(2*Wo);
r1=roots([1  B-2*C-2  2+4*C-2*B+2*B*C  -3*B-2*C-2  2*B+1]);
r1(find((imag(r1)~=0)|(r1<=0)|(r1>=1)))=0;
R1=max(r1);
R2=(2+B-sqrt((2+B)^2-4))/2;
R=max(R1,R2);

% 공진 회로의 전달 함수
b=[0  2*(1-R)*cos(Wo)  R^2-1];   % 분자 계수 벡터
a= [1  -2*R*cos(Wo)  R^2];       % 분모 계수 벡터
