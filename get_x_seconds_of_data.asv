%Reads x seconds of data from tcp_obj, where x is EEG_Settings.Seconds_Of_Data

function data = get_x_seconds_of_data(tcp_obj,EEG_Settings)
    
%Dimensions of a single packet of data, N_Channels x N_Samples
dims = ([EEG_Settings.N_CHANNELS EEG_Settings.SAMPLES_PER_PACKET]);


while(EEG_Settings.SAMPLES_READ < EEG_Settings.Fs*EEG_Settings.Seconds_Of_Data)
    
    %pre allocate matrix for speed
    if exist('data','var')
        data =[data zeros(dims)];
    else
        data= zeros(dims);
    end
    
    %Get block of data from Biosemi
    data(:, (EEG_Settings.SAMPLES_READ+1) : EEG_Settings.SAMPLES_READ + EEG_Settings.SAMPLES_PER_PACKET) = ...
        get_tcp_packet_from_BioSemi(    tcp_obj, ...
                                        EEG_Settings.N_CHANNELS,...
                                        EEG_Settings.SAMPLES_PER_PACKET,...
                                        EEG_Settings.BYTES_PER_SAMPLE);
    
    EEG_Settings.SAMPLES_READ = EEG_Settings.SAMPLES_READ + EEG_Settings.SAMPLES_PER_PACKET;
    
end
