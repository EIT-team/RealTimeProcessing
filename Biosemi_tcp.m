%Set up variables and TCP object for loading data from BioSemi over TCP
%Tom Dowrick November 2015.
%% Set variables Default values used, can change if necessary
%BioSemi IP Address, Port and TCP Buffer Size
EEG.IP      = '127.0.0.1';
EEG.Port    = 8888;
EEG.TCP_buffer  = 101376; %IMPORTANT: Need to check the TCP tab in Actiview to get corect value for this!
EEG.Type = 'BioSemi';

%Sampling Frequency
EEG.Fs = 16384;

%Number of data channels and samples per TCP packet
EEG.N_elecs = 32;
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

%Connect to Biosemi over TCP
EEG.tcp_obj = create_tcp_obj(EEG.IP,EEG.Port,EEG.TCP_buffer);

