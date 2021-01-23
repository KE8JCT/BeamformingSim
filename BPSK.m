function [tt,zz,signal_out] = BPSK(string1,fs)
%The following is an attempt to modulate and demodulate binary phase-shift
%keying
string1 = 'usma';
b = flip(de2bi(double(string1)),2);

b = reshape(b.',1, []);

B = (b + .5)*100;
c = ones(1, (length(B)*100 + 1));
C = c

for d = 0:(length(B)-1)
    for e = 1:100
        C(e+(d*100)) = B((d+1));
    end
end



tt = 0:1/length(b):1
t = (0:1/fs:1);
%F = C(:)
%xx = sin(2*pi*C.*tt);
%yy = sin(2*pi*F*tt);
%{
%To plot two B-FSK Signals
tiledlayout(2, 1)
nexttile
plot(tt, xx)
title('Binary FSK signal')
xlabel('TIME (sec)')
nexttile
plot(tt, yy)
title('Binary FSK signal - Blocky')
xlabel('TIME (sec)')
%}

%Binary Phased-Shift Keying

for d = 0:(length(b)-1)
    for e = 1:100
        c(e+(d*100)) = b((d+1));
    end
end

%for d=0:legth(

for i = 1:length(c)
    if c(i) == 0
        c(i) = -1;
    end
    
end

%add awgn

%{
t = (0:1/fs:1)

zz = [zz zz zz];
zz=zz(1:t);
%}

zz = c.*sin(2*pi*1.4*tt);
noise = 0.1*(randn(size(zz)) + 1i*randn(size(zz)));
signal_out = (zz+noise);
%zn = awgn(zz, 20) %SNR of 20
%xx = sin(2*pi*.789*tt+pi)
end

