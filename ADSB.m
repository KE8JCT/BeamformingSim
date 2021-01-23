function [signal,time2] = ADSB(time)
%This script attempts to generate a manchester-encoded, PPM signal from a
%hex text document file (adsb.txt). 

%scan each line into an array or vector
%cut up line into pieces: preamble (0-16), data (17-32), etc
%convert individual block

fileID = fopen('adsb.txt');
raw_plane = fscanf(fileID, '%s', [2,1]); %constraint: have to input size of text document

%now onto redundancy checks / demodulator
%aside from physically building the packet (which you should use matlab
%for), all you have to do is send out cosine wave 

%DEMODULATOR - HEX

DF = '8D'; 
CA = '0';
ICAO = '4840D6';
DATA = '202CC371C32CE0';
PARITY = '576098';

hex_packet = {DF; CA; ICAO; DATA; PARITY};

preamble = '1010000101000000';

binary_packet = hex2dec(hex_packet);

DF_bin = dec2bin(hex2dec(DF),8);
%CA_bin = dec2bin(hex2dec(CA),);
ICAO_bin = dec2bin(hex2dec(ICAO), 24);
DATA_bin = dec2bin(hex2dec(DATA), 56);
PARITY_bin = dec2bin(hex2dec(PARITY), 24);

BINARY_packet = [DF_bin ICAO_bin DATA_bin PARITY_bin];
%BINARY_packet = convertCharsToStrings(BINARY_packet);
%BINARY_packet = str2double(BINARY_packet);

BINARY_packet = [preamble BINARY_packet];
bit = zeros(1,length(BINARY_packet));

for k = 1:length(BINARY_packet)
    bit(k) = str2double(BINARY_packet(k));
end
 


%binary_packet = dec2bin(binary_packet);

%packet = hextobin(preamble,df,ca,icao,data,parity)
%packet = [preamble df ca icao data parity]
%bitwise reading may not even need to happen
%{
for k=1:length(BINARY_packet)
    for n=1:length(BINARY_packet(k))
        bit(k,n) = BINARY_packet(n)
    end
end
%}

%what you should actually do is double-modulate it
f = 4e6;
%bit = [0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,1,1];
tt = 1:(2*length(bit));

signal = zeros(1,length(bit));
for k=1:length(tt)
    if mod(tt(k), 2) == 0 %even number
    signal(k) = bit(k/2)* cos(2*pi*f * tt(k));
    else
    signal(k) = bit(k/2 + .5)* cos(2*pi*f * tt(k));
    end
end

while length(signal) < time
   
    signal = [signal signal];

    
end

%signal = signal;
time2 = length(signal);

end

