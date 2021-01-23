%Two stages to device

%REDO WITH AM MODULATION - GOOD TEACHING AID WITH AUDIO FILES
clear all
%1. DOA estimator. Use Beamscan / MUSIC / ESPRITE to find DoA

%2. Conventional, time-dependent Phase Shift Beamformer

%% DoA
%1. Create Signals and Array
fs = 8000;
%{
t = (0:1/fs:1).';
time = length(t);
[x1, time2] = ADSB(time);
fc = 1090e6;
time2 = linspace(0,1,time2)';
x1 = x1(1:length(t)).';
%t = time2(1:length(t));
%}

[xm, fs] = audioread('beamforming_wav.wav');
fc = 150e6;
[x1,t] = modulate(xm,fc,400e6, 'am');


antenna = phased.IsotropicAntennaElement('FrequencyRange',[100e6 200e6]); %one antenna within range (150 MHz)
array = phased.ULA('Element',antenna,'NumElements',10,'ElementSpacing',1); %array of 10 antennas

x = collectPlaneWave(array,x1,[10 20]',fc); %what does collectPlaneWave do?
noise = 0.1*(randn(size(x)) + 1i*randn(size(x)));

%2. Solve for DoA
estimator = phased.BeamscanEstimator('SensorArray',array, ...
    'OperatingFrequency',fc,'DOAOutputPort',true,'NumSignals',1);
[~,doas] = estimator(x + noise);
doas = broadside2az(sort(doas),20);
disp(doas)

%3. Improve results
estimator2 = phased.BeamscanEstimator('SensorArray',array, ...
    'OperatingFrequency',fc,'ScanAngles',-60:0.1:60, ...
    'DOAOutputPort',true,'NumSignals',1);
[~,doas] = estimator2(x + noise);
doas = broadside2az(sort(doas),20);
disp(doas)

%4. Plot
figure(1)
plotSpectrum(estimator)

%% Beamforming to receive Audio
clear x


incidentAngle = [doas; 0];
array = phased.ULA('NumElements',10);
c = physconst('Lightspeed');
x = collectPlaneWave(array,x1,incidentAngle,fc,c);
noise = 0.1*(randn(size(x)) + 1j*randn(size(x)));
rx = x + noise;

beamformer = phased.PhaseShiftBeamformer('SensorArray',array,...
    'OperatingFrequency',fc,'PropagationSpeed',c,...
    'Direction',incidentAngle,'WeightsOutputPort',true);
[y,w] = beamformer(rx);



%Plot
figure(2)
plot(t(1:1e3,1),real(rx(1:1e3,4)),'r:')
hold on
plot(t(1:1e3,1),real(y(1:1e3)))
xlabel('Time (sec)')
ylabel('Amplitude')
legend('Input','Beamformed')
title("Beamformed and Input signal")
hold off


figure(3)
pattern(array,fc,[-180:180],0,'PropagationSpeed',c,'Type',...
    'powerdb','CoordinateSystem','polar','Weights',w)

%% Demodulate
%
message = demod(rx,150e6,400e6,'am');
figure(4)
plot(abs(message))
hold on
plot(xm, '--')
title("Beamformed and Original Audio Files")
xlabel("Time (samples)")
ylabel("Amplitude")
legend("Beamformed","Original")
hold off

%audiowrite("received_wav.wav", real(rx), 12e3)

%sound(abs(message),12e3);

audiowrite('received_audio.wav', abs(message), 12e3);

