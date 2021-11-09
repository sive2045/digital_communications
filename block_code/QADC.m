function xb=QADC(xl, Nb)
% ���ϸ� : QADC.m
% [�Է�] xl = 10�� ����ȭ ������ ����ȭ�� ��ȣ
%        Nb = ����ȭ ��Ʈ��
% [���] xb = xl �� ��ȣȭ�� ��Ʈ �����Ϳ�
if nargin~=2 error('�Է��� 2�� �̴�!'),end
M=2^Nb; % ����ȭ ���� ��
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
% A/D ��ȯ
xb=[];
for n=1:length(xl)
    i=xl(n);
    xb=[xb;d2b(i+1,:)'];
end
