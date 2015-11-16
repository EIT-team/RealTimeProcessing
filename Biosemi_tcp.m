%Code for loading BioSemi data directly into MATLAB over TCP

%Tom Dowrick November 2015.

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
EEG_Settings.Max_Voltage = 1e6; %1V in uV
%Running total of recorded samples
EEG_Settings.SAMPLES_READ = 0;

%How many seconds of data to read
EEG_Settings.Seconds_Of_Data = 2;

%Detect injection frequency and calculate filter coefficents
Fc = get_inj_freq;
F_Band = 100;
F_Ord = 1;
[b,a] = butter(F_Ord,(Fc+[-F_Band,F_Band])./(EEG_Settings.Fs/2));

try
    fopen(biosemi_tcp_obj)
catch
    disp('Unable to open TCP connection with BioSemi, check ActiView is running')
end

clear data

%Create axes handles and setup plotting
h = create_axes(EEG_Settings);

while(1)
data  = get_x_seconds_of_data(biosemi_tcp_obj,EEG_Settings,EEG_Settings.Seconds_Of_Data);
data = filtfilt(b,a,data');
data = abs(hilbert(data));
data = data';
plot_data(data,EEG_Settings,h);
drawnow;
end
fclose(biosemi_tcp_obj);
