%Reads x seconds of data from tcp_obj, where x is EEG_Settings.Seconds_Of_Data
%Currently smallest time period that will work is 50ms (16.11.2015)

%Tom Dowrick


function data = get_x_seconds_of_data(tcp_obj,EEG_Settings,seconds_to_get)
    
%Dimensions of a single packet of data, N_Channels x N_Samples
dims = ([EEG_Settings.N_CHANNELS EEG_Settings.SAMPLES_PER_PACKET * seconds_to_get]);
    
%pre allocate matrix for speed
data= zeros(dims);

while(EEG_Settings.SAMPLES_READ < EEG_Settings.Fs*seconds_to_get)
    
  
    
    %Get block of data from Biosemi
    data(:, (EEG_Settings.SAMPLES_READ+1) : EEG_Settings.SAMPLES_READ + EEG_Settings.SAMPLES_PER_PACKET) = ...
        get_tcp_packet_from_BioSemi(    tcp_obj, ...
                                        EEG_Settings.N_CHANNELS,...
                                        EEG_Settings.SAMPLES_PER_PACKET,...
                                        EEG_Settings.BYTES_PER_SAMPLE);
    
    EEG_Settings.SAMPLES_READ = EEG_Settings.SAMPLES_READ + EEG_Settings.SAMPLES_PER_PACKET;
    
end
