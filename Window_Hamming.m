%clear; clc; clf;
function [dftz, dftzlog] = Window_Hamming(Speech_signal)
z=Speech_signal;
z2=0;
zero=zeros(1, 1000);
w = window(@hamming, length(z));
for i=1:length(z)
  z(i)=z(i)*w(i);
end
z2 = [zero z zero];

dftz=abs(fft(z2, 4096));
dftz=dftz(1:(length(dftz)/2));
dftzlog=10*log10(dftz);
end