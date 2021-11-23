function xds=DSS(Fmax, x, Tc, m, sw)
    Ts = 1/(2*Fmax);
    
    Lc=round(Tc/Ts);
    Lseq=fix(length(x)/Lc)+1;
    seq=MLsequence(m,sw,Lseq);
    chip=[];
    for k=1:Lseq
        chip=[chip; ((seq(k)==1)-(seq(k)==0))*ones(Lc,1)];
    end
    chip(length(x)+1: end)=[];
    xds =chip.*x;
end