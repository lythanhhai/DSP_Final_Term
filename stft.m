%clear; clc; clf;
%function to compute log magnitude spectrum of a speech segment for a particular window type
function [c] = stft(Speech_signal, Fs, window_type)
y=Speech_signal; y2=0;
zero=zeros(1:1);
w=window(window_type,length(y));
for i=1:length(y)
  y(i)=y(i)*w(i);
end
y2 = [zero y zero];

dfty=abs(fft(y2));
dfty=dfty(1:(length(dfty)/2));
dfty=10*log(dfty);
c=dfty;
endfunction
