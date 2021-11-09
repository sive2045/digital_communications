%% Huffman
% input parameter :
% p : prob row vector
% output parameter :
% hcode = Huffman code
% L : E[L;length]

function [hcode, L] = cal_Huffman(p)
    if length(find(p<0))~=0
        error('prob value must be positive!');
    end
    
    if abs(sum(p)-1)>10e-10
        error('sum of prob must be 1!')
    end
    
    Np=length(p);
    q=p;
    m=zeros(Np-1,Np);
    for i=1:Np-1
        [q, index]=sort(q);
        m(i,:)=[index(1:Np-i+1),zeros(1,i-1)];
        q=[q(1)+q(2),q(3:Np),1];
    end

    for i=1:Np-1
        b(i,:)=blanks(Np*Np);
    end    

    b(Np-1,Np)='0';
    b(Np-1,2*Np)='1';

    for i=2:Np-1
        n1=Np*(find(m(Np-i+1,:)==1))-(Np-2);
        n2=Np*(find(m(Np-i+1,:)==1));
        b(Np-i,1:Np-1)= b(Np-i+1,n1:n2);
        b(Np-i, Np)='0';
        b(Np-i,Np+1:2*Np-1)=b(Np-i, 1:Np-1);
        b(Np-i,2*Np)='1';
    
        for k=1:i-1
            n1=Np*(find(m(Np-i+1,:)==k+1)-1)+1;
            n2=Np*find(m(Np-i+1,:)==k+1);
            b(Np-i,(k+1)*Np+1:(k+2)*Np)=b(Np-i+1,n1:n2);
        end  
    end
    
    for i=1:Np
        n1=Np*(find(m(1,:)==i)-1)+1;
        n2=find(m(1,:)==i)*Np;
        hcode(i,1:Np)=b(1, n1:n2);
        s(i)=length(find(abs(hcode(i,:))~=32));
    end
    L=sum(p.*s);        
end