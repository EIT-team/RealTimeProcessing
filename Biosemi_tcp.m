%BioSemi IP Address, Port and TCP Buffer Size
BioSemi_IP      = '127.0.0.1';
BioSemi_Port    = 8888;
BioSemi_Buffer  = 24576;

%Sampling Frequency
Fs = 16384;

%Number of data channels and samples per TCP packet
N_CHANNELS = 8;
BYTES_PER_SAMPLE = 3;
SAMPLES_PER_PACKET = BioSemi_Buffer /(N_CHANNELS*BYTES_PER_SAMPLE);

%Connect to Biosemi over TCP
biosemi_tcp_obj = create_tcp_obj(BioSemi_IP,BioSemi_Port,BioSemi_Buffer);

fclose(biosemi_tcp_obj)
fopen(biosemi_tcp_obj)

clear data

%No. of samples read so far
SAMPLES_READ = 0;

%Using this to measure run time
T = [];
tic
while(SAMPLES_READ < Fs*100)
    
    %pre allocate for speed
    if exist('data','var')
        data =[data zeros(N_CHANNELS,SAMPLES_PER_PACKET)];
    else
        data= zeros(N_CHANNELS,SAMPLES_PER_PACKET);
    end
    
    %Get block of data from Biosemi
    data(:,(SAMPLES_READ+1):SAMPLES_READ+SAMPLES_PER_PACKET) = ...
        get_tcp_packet_from_BioSemi(biosemi_tcp_obj, N_CHANNELS, SAMPLES_PER_PACKET, BYTES_PER_SAMPLE);
    
    SAMPLES_READ = SAMPLES_READ + SAMPLES_PER_PACKET;
    
    %% Plotting stuff
    if ~mod(SAMPLES_READ,Fs/10)
        
        T = [T toc];
        tic
        
        for i = 1:8
        subplot(8,2,2*i-1)
        plot(data(i,:))
        
        end
              
        drawnow
    end
    
    if ~mod(SAMPLES_READ,2*Fs)
        subplot(1,2,2)
        pwelch(data(1,SAMPLES_READ-Fs:SAMPLES_READ),Fs,.95,[],Fs)
    end
end

mean(T)