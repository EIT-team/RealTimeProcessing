function BV0 = get_BV (Data,EEG,Filt,Freqs,Prt)

elec = 1:EEG.N_elecs;
N_prt = size(Prt,1);

for i = 1:size(Freqs)
    
    Fc = Freqs(i);
    
    %Filter and demodulate at each frequency
    [b,a] = butter(Filt.Order,(Fc+[-Filt.Band,Filt.Band])./(EEG.Fs/2));
    
    X1 = filtfilt(b,a,Data);
    X1 = abs(hilbert(X1));
    
    BV(i,:)= mean( X1(end/10:9*end/10,:));
    SD(i,:)= std( X1(end/10:9*end/10,:));
    
end


BV0 = 1e-6*cell2mat(arrayfun(@(i)BV(i,setdiff(elec,Prt(i,:))),1:N_prt,...
    'UniformOutput',false))';

end
