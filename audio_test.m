
[xm, fs] = audioread('beamforming_wav.wav');

fc = 150e6;

[y,t] = modulate(xm,fc,400e6, 'am');
T = 1/400e6
L = length(t)
Y1 = fft(y);
Fs1 = 400e6;


P21 = abs(Y1/L);
P11 = P21(1:L/2+1);
P11(2:end-1) = 2*P11(2:end-1);


f1 = Fs1*(0:(L/2))/L;

Y2 = fft(xm);
Fs2 = 400e6;


P22 = abs(Y2/L);
P12 = P22(1:L/2+1);
P12(2:end-1) = 2*P12(2:end-1);


f2 = Fs2*(0:(L/2))/L;

plot(f1,P11) 
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')
hold on
plot(f2, P12)
hold off

%{
tiledlayout(2,1)
nexttile
plot(y)
hold on
plot(xm, '--')
hold off




nexttile
plot(fft(abs(y)))
hold on
plot(fft(rea(xm)))
%}