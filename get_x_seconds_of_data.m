%Reads x seconds of data from tcp_obj, where x is EEG_Settings.Seconds_Of_Data
%Currently smallest time period that will work is 50ms (16.11.2015), which
%is dependent on the tcp buffer size/ActiView settings.
%If the trigger channel has been recorded, return this as well


%Tom Dowrick


function [data triggers] = get_x_seconds_of_data(EEG)

%Dimensions of a single packet of data, N_Channels x N_Samples
dims = ([EEG.N_elecs EEG.Samples_per_packet * EEG.Seconds_of_data]);

%pre allocate matrix for speed
data= zeros(dims);

while(EEG.Samples_read < EEG.Fs*EEG.Seconds_of_data)
    
    x_range = (EEG.Samples_read+1) : EEG.Samples_read + EEG.Samples_per_packet;
    
    %Get block of data from Biosemi
    [data(:, x_range) triggers(:,x_range)] = ...
        get_tcp_packet_from_BioSemi(EEG);
    
    EEG.Samples_read = EEG.Samples_read + EEG.Samples_per_packet;
    
end
