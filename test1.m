clear;clc;clf;
[y,Fs]=audioread('./tinHieuHuanLuyen/01MDA.wav');%input: voiced speech segment

max_value=max(abs(y));
y=y/max_value;
y=y(1:(Fs*.035));

t=1/Fs:1/Fs:(length(y)/Fs);
subplot(3,1,1);plot(t,y);
title('Voiced Speech waveform');

dfty=abs(fft(y));
dfty=dfty(1:(length(dfty)/2));
tt=linspace(1/Fs,Fs/2,length(dfty));
subplot(3,1,2);plot(tt,dfty);
title('Linear Magnitude Spectrum');

dftylog=10*log10(dfty);
subplot(3,1,3);plot(tt,dftylog);
title('Log Magnitude Spectrum');