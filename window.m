clear; clc; clf;
function [dfty, dftylog] = stft(Speech_signal, Fs)
y=Speech_signal;
%{
y2=0;
zero=zeros(1:10000);
w=window(@hamming, length(y));
for i=1:length(y)
  y(i)=y(i)*w(i);
end
y2 = [zero y zero];
%}
dfty=abs(fft(y));
dfty=dfty(1:(length(dfty)/2));
dftylog=10*log(dfty);

end