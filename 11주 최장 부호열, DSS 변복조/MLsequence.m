function seq = MLsequence(m, sw, Lseq)
    if nargin~=3 error('입력은 3개이다!'), end
    if length(sw)>=m error('레지스터 결합이 부적절하다!'), end
    
    connect=[zeros(1, m-1) 1];
    connect(sw)=1;
    register=[zeros(1, m-1) 1];
    for k=1:Lseq
        addout=rem(register*connect', 2);
        register(2:m)=register(1:m-1);
        register(1)=addout;
        seq(k)=register(m);
    end
end