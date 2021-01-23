%This is the copy-pasted example from mathworks.com

c = 340; %speed of light
t = linspace(0,1,50e3)'; %timestep
sig = chirp(t,0,1,1000); %chirp signal

microphone = phased.OmnidirectionalMicrophoneElement(...
    'FrequencyRange',[20 20e3]); %what is 20e3?
array = phased.ULA('Element',microphone,'NumElements',10,...
    'ElementSpacing',0.01); %<1/2 wavelength at 50kHz sampling freq
collector = phased.WidebandCollector('Sensor',array,'SampleRate',5e4,...
    'PropagationSpeed',c,'ModulatedInput',false); %makes sense
sigang = [60;0]; %60 degree azimuth, 0 degree elevation
rsig = collector(sig,sigang);
rsig = rsig + 0.1*randn(size(rsig)); %add random noise

beamformer = phased.TimeDelayBeamformer('SensorArray',array,...
    'SampleRate',5e4,'PropagationSpeed',c,'Direction',sigang);
y = beamformer(rsig);

subplot(2,1,1)
plot(t(1:5000),real(rsig(1:5e3,5)))
axis([0,t(5000),-0.5,1])
title('Signal (real part) at the 5th element of the ULA')
subplot(2,1,2)
plot(t(1:5000),real(y(1:5e3)))
axis([0,t(5000),-0.5,1])
title('Signal (real part) with time-delay beamforming')
xlabel('Seconds')