%clear; clc; clf;
function [dftz] = Window_Hamming(Speech_signal, pointFFT)
    z = Speech_signal;
    z2 = zeros(length(z), 1);
    w = hamming(length(z));
    for i=1:length(z)
      z2(i) = z(i)*w(i);
    end

    dftz = abs(fft(z2, pointFFT));
    dftz = dftz(1:(length(dftz) / 2));
    dftz = 10*log10(dftz);
end










%{
zero = zeros(1, 3000);
%z2 = [zero z zero];
%}