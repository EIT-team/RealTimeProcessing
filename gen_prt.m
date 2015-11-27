function prtfull = gen_prt (Prt, N_elecs)

elec = 1:N_elecs;

prtfull = [];
start = 1;
for i = 1:length(Prt)
    a = setdiff(elec,Prt(i,:));
    
    n=size(a,2);
    fin = start+n-1;
    
    prtfull(start:fin,1:2) = repmat(Prt(i,1:2),n,1);
    prtfull(start:fin,3) = a ;
    prtfull(start:fin,4) = N_elecs+1;
    start = fin+1;
end