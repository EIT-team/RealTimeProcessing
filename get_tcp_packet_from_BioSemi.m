function [data triggers] = get_tcp_packet_from_BioSemi (EEG)

offset = 0;             %Byte offset corresponding to chan/sample being processed

%The 24-bit biosemi data is transmitted as 3 bytes, which need to be
%combined into one 32-bit value. Apply this bit mask to each set of 3 bytes
%and sum them to get the actual data value.
Bit_Shift_Mask = [8 16 24];

%Scale factor to get values in uV. Otherwise values don't make sense
MAGNITUDE_SCALE_FACTOR = 256*32;

%Pre allocate space
data = zeros(EEG.N_elecs,EEG.Samples_per_packet);

%Read TCP data
stream = fread(EEG.tcp_obj);

%Process TCP data to voltages
new_data = bitshift(stream,repmat( Bit_Shift_Mask,1,length(stream)/3)');
shaped_data = reshape(new_data,3,EEG.Samples_per_packet*EEG.N_recorded_channels);
summed_data = sum(shaped_data);
final = reshape(summed_data,EEG.N_recorded_channels,EEG.Samples_per_packet);

%Data is received in 2s complement format, convert to 32 bit int.

for i = 1:EEG.N_elecs
    data(i,:) = typecast(uint32(final(i,:)),'int32')/(MAGNITUDE_SCALE_FACTOR);
end

if EEG.Triggers
  
    for j = ((1:EEG.N_trig_chans) + 8) %Trigger channels start at bit 9
        triggers(j-8,:) = bitget(final(i+1,:),j);
    end
end

