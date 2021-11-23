function [b, a]=single_tune(Fmax, Fo, Bw)

if nargin~=3  error('�Է� ���� 3���̴�!'), end
if (Fo>=Fmax)|(Bw>=Fmax)  error('���ļ� ���谡 �������ϴ�!'),  end
if nargout~=2  error('��� ���� 2���̴�!'), end

% �߽� ���ļ��� �뿪���� ������ ���ļ�
Wo=Fo/Fmax*pi;  Ww=Bw/Fmax*pi;

% ���� ȸ���� ���� ���
B=(Ww/2)^2;
C=cos(2*Wo);
r1=roots([1  B-2*C-2  2+4*C-2*B+2*B*C  -3*B-2*C-2  2*B+1]);
r1(find((imag(r1)~=0)|(r1<=0)|(r1>=1)))=0;
R1=max(r1);
R2=(2+B-sqrt((2+B)^2-4))/2;
R=max(R1,R2);

% ���� ȸ���� ���� �Լ�
b=[0  2*(1-R)*cos(Wo)  R^2-1];   % ���� ��� ����
a= [1  -2*R*cos(Wo)  R^2];       % �и� ��� ����
