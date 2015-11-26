%Code for loading BioSemi data directly into MATLAB over TCP
clear all
%Tom Dowrick November 2015.
%% Set variables
%BioSemi IP Address, Port and TCP Buffer Size
EEG.IP      = '127.0.0.1';
EEG.Port    = 8888;
EEG.TCP_buffer  = 27648;
EEG.Type = 'BioSemi';

%Connect to Biosemi over TCP
EEG.tcp_obj = create_tcp_obj(EEG.IP,EEG.Port,EEG.TCP_buffer);


%Sampling Frequency
EEG.Fs = 16384;

%Number of data channels and samples per TCP packet
EEG.N_elecs = 8;
EEG.Triggers = 1; %0 if triggers not recorded
EEG.N_recorded_channels = EEG.N_elecs + EEG.Triggers;
EEG.Bytes_per_sample = 3;
EEG.Samples_per_packet = EEG.TCP_buffer /(EEG.N_recorded_channels*EEG.Bytes_per_sample);
EEG.Max_voltage_uV = 1e6; %1V in uV
%Running total of recorded samples
EEG.Samples_read = 0;
EEG.N_trig_chans = 16; %Number of trigger channels (Biosemi has 16)

%How many seconds of data to read
EEG.Seconds_of_data = 1;

%Detect injection frequency and calculate filter coefficents
Fc = get_inj_freq;
F_Band = 100;
F_Ord = 1;
[b,a] = butter(F_Ord,(Fc+[-F_Band,F_Band])./(EEG.Fs/2));

fclose(EEG.tcp_obj);

try
    fopen(EEG.tcp_obj)
catch
    disp('Unable to open TCP connection with BioSemi, check ActiView is running')
end

clear datawrite

%Create axes handles and setup plotting
h = create_axes(EEG);
%%
while(1)

    [data triggers]  = get_x_seconds_of_data(EEG);

data = filtfilt(b,a,data);
data = abs(hilbert(data));
% data = data';
 plot_data(data,EEG,h);
drawnow;
end
