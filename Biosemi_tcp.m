%BioSemi IP Address, Port and TCP Buffer Size
BioSemi_IP      = '127.0.0.1';
BioSemi_Port    = 8888;
BioSemi_Buffer  = 24576;

%Connect to Biosemi over TCP
biosemi_tcp_obj = create_tcp_obj(BioSemi_IP,BioSemi_Port,BioSemi_Buffer);


%Sampling Frequency
EEG_Settings.Fs = 16384;

%Number of data channels and samples per TCP packet
EEG_Settings.N_CHANNELS = 8;
EEG_Settings.BYTES_PER_SAMPLE = 3;
EEG_Settings.SAMPLES_PER_PACKET = BioSemi_Buffer /(EEG_Settings.N_CHANNELS*EEG_Settings.BYTES_PER_SAMPLE);

EEG_Settings.SAMPLES_READ = 0;

fclose(biosemi_tcp_obj)

fopen(biosemi_tcp_obj)

clear data

%No. of samples read so far

%How many seconds of data to read
EEG_Settings.Seconds_Of_Data = 1;

%Dimensions of a single packet of data, N_Channels x N_Samples
dims = ([EEG_Settings.N_CHANNELS EEG_Settings.SAMPLES_PER_PACKET]);

while(EEG_Settings.SAMPLES_READ < EEG_Settings.Fs*EEG_Settings.Seconds_Of_Data)
    
    %pre allocate matrix for speed
        %Create 
    if exist('data','var')
        data =[data zeros(dims)];
    else
        data= zeros(dims);
    end
    
    %Get block of data from Biosemi
   %Get block of data from Biosemi
    data(:, (EEG_Settings.SAMPLES_READ+1) : EEG_Settings.SAMPLES_READ + EEG_Settings.SAMPLES_PER_PACKET) = ...
        get_tcp_packet_from_BioSemi(    biosemi_tcp_obj, ...
                                        EEG_Settings.N_CHANNELS,...
                                        EEG_Settings.SAMPLES_PER_PACKET,...
                                        EEG_Settings.BYTES_PER_SAMPLE);
    
    EEG_Settings.SAMPLES_READ = EEG_Settings.SAMPLES_READ + EEG_Settings.SAMPLES_PER_PACKET;
    
    %% Plotting stuff
    if ~mod(EEG_Settings.SAMPLES_READ,EEG_Settings.Fs/10)
        
        for i = 1:8
        subplot(8,2,2*i-1)
        plot(data(i,:))
        
        end
              
        drawnow
    end
    
    if ~mod(EEG_Settings.SAMPLES_READ,2*EEG_Settings.Fs)
        subplot(1,2,2)
        plot( abs(hilbert( filtfilt(b,a,data(1,:)))))
        %pwelch(data(1,EEG_Settings.SAMPLES_READ-EEG_Settings.Fs:EEG_Settings.SAMPLES_READ),EEG_Settings.Fs,.95,[],EEG_Settings.Fs)
    end
end

mean(T)