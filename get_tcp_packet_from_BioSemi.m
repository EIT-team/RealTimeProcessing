function data = get_tcp_packet_from_BioSemi (tcp_obj, N_CHANNELS, SAMPLES_PER_PACKET, BYTES_PER_SAMPLE)

stream = fread(tcp_obj);

data = zeros(N_CHANNELS,SAMPLES_PER_PACKET);
for chan = 1:N_CHANNELS
    
for sample = 1:SAMPLES_PER_PACKET

%Biosemi data is formatted C1S1, C2S1, C3S1, C4S1, C1S2, C2S2 etc. Where
%C1=Channel 1 and S1 = Sample 1. Each sample is 3 bytes (24-bit), but needs
%to be padded to 32-bit before converting to an interger in twos complement
%format.
offset = ((sample-1))*N_CHANNELS*BYTES_PER_SAMPLE + (chan-1)*BYTES_PER_SAMPLE;

BYTES = dec2bin(stream((offset+1):(offset+3)));
EMPTY_BYTE = '00000000';

data(chan,sample) =  twos2dec( strcat (BYTES(3,:),BYTES(2,:),BYTES(1,:),EMPTY_BYTE));
          
end
end