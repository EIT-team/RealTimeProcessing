function [data triggers] = get_tcp_packet_from_BioSemi (tcp_obj, EEG_Settings)

offset = 0;             %Byte offset corresponding to chan/sample being processed

%The 24-bit biosemi data is transmitted as 3 bytes, which need to be
%combined into one 32-bit value. Apply this bit mask to each set of 3 bytes
%and sum them to get the actual data value.
Bit_Shift_Mask = [8 16 24];

%Scale factor to get values in uV. Otherwise values don't make sense
MAGNITUDE_SCALE_FACTOR = 256*32;

%Pre allocate space
data = zeros(EEG_Settings.N_CHANNELS,EEG_Settings.SAMPLES_PER_PACKET);

%Read TCP data
stream = fread(tcp_obj);

%Process TCP data to voltages
new_data = bitshift(stream,repmat( Bit_Shift_Mask,1,length(stream)/3)');
shaped_data = reshape(new_data,3,EEG_Settings.SAMPLES_PER_PACKET*EEG_Settings.N_CHANNELS);
summed_data = sum(shaped_data);
final = reshape(summed_data,EEG_Settings.N_CHANNELS,EEG_Settings.SAMPLES_PER_PACKET);

%Data is received in 2s complement format, convert to 32 bit int.

for i = 1:EEG_Settings.N_elecs
    data(i,:) = typecast(uint32(final(i,:)),'int32')/(MAGNITUDE_SCALE_FACTOR);
end

if EEG_Settings.Triggers
    
    for j = ((1:EEG_Settings.N_trig_chans) + 8) %Trigger channels start at bit 9
        triggers(j-8,:) = bitget(final(i+1,:),j);
    end
end

