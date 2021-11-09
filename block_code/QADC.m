function xb=QADC(xl, Nb)
% 파일명 : QADC.m
% [입력] xl = 10진 양자화 준위로 양자화된 신호
%        Nb = 양자화 비트수
% [출력] xb = xl 을 부호화한 비트 데이터열
if nargin~=2 error('입력은 2개 이다!'),end
M=2^Nb; % 양자화 준위 수
d2b=zeros(M, Nb);
for i=1:M
    decimal = i-1;
    for k=1:Nb
        if(fix(decimal/(2^(Nb-k)))==1)
            d2b(i,k)=1;
            decimal=decimal-2^(Nb-k);
        end
    end
end
% A/D 변환
xb=[];
for n=1:length(xl)
    i=xl(n);
    xb=[xb;d2b(i+1,:)'];
end
