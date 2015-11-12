function data = get_tcp_packet_from_BioSemi (tcp_obj, N_CHANNELS, SAMPLES_PER_PACKET, BYTES_PER_SAMPLE)

offset = 0;             %Byte offset corresponding to chan/sample being processed
data = zeros(N_CHANNELS,SAMPLES_PER_PACKET);
stream = fread(tcp_obj);

for sample = 1:SAMPLES_PER_PACKET

for chan = 1:N_CHANNELS
    


%Biosemi data is formatted C1S1, C2S1, C3S1, C4S1, C1S2, C2S2 etc. Where
%C1=Channel 1 and S1 = Sample 1. Each sample is 3 bytes (24-bit), but needs
%to be padded to 32-bit before converting to an interger in twos complement
%format.

%offset = ((sample-1))*N_CHANNELS*BYTES_PER_SAMPLE + (chan-1)*BYTES_PER_SAMPLE;
tic
 %this_sample = sum((bitshift ( stream((offset+1):(offset+3)) , [8;16;24])));
 this_sample = bitshift(stream(offset+1),8) + bitshift(stream(offset+2),16) + bitshift(stream(offset+3),24);
 fprintf('Bitshift %1.5f\n',toc)
 tic
data(chan,sample) = typecast (uint32(this_sample),'int32');
 fprintf('cast %1.5f\n',toc)

offset = offset + 3;
        

end
end

