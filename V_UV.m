 %close all;clear;clc
 function [P] =  V_UV(filename, tenFile, MDA01, pointFFT, rangeFreq)
 
 % input audio
 [x,fs]=audioread(filename);
 figure('name', tenFile);
 
 x = x./max(x);
 
 % phân khung cho tín hiệu
 frame_duration = 0.03;
 frame_len = 0.03 * fs;% chiều dài khung, 1 khung 30ms
 overlap_duration = 0.01;
 overlap_len = 0.01 * fs;
 L = length(x);

 %{
 numberFrames = floor(L / frame_len);% số khung được chia
 P = zeros(numberFrames, frame_len);
 for i = 1:numberFrames
     startIndex = (i - 1) * frame_len + 1;
     for j = 1:frame_len
         P(i, j) = x(startIndex + j - 1);
     end
 end
%}
 
 % chia khung
 numberFrames = floor((L - frame_len) / overlap_len + 1);% số khung được chia
 P = zeros(numberFrames, frame_len);
 for i = 1:numberFrames
     startIndex = (i - 1) * overlap_len + 1;
     endIndex = (i - 1) * overlap_len + frame_len + 1;
     if endIndex <= L
        for j = 1:frame_len
            P(i, j) = x(startIndex + j - 1);
        end 
     else 
        for j = 1:(L - startIndex)
            P(i, j) = x(startIndex + j - 1);
        end 
        for j = (L - startIndex + 1):frame_len
            P(i, j) = 0;
        end
     end
 end
 
% tính STE cho từng khung
sumSTE = 0;
ste = zeros(1, numberFrames);
for l=1:numberFrames
    sumSTE=0;
    for k=1:frame_len
        sumSTE = sumSTE + power(P(l, k), 2);
    end
    ste(1, l) = sumSTE;
end

% normalized ste
ste = ste./max(ste(1, :));


ste_copy = zeros(numberFrames, 1);
for i = 1:numberFrames
    ste_copy(i) = ste(i);
end
ste_copy;

ste_wave = 0;
for j = 1 : length(ste)
    l = length(ste_wave);
    ste_wave(l : l + frame_len) = ste(j);
end

time = (1/fs)*length(x);
t = linspace(0, time, length(x));

time1 = 0.01 * length(ste);
t1 = linspace(0, time1, length(ste));

t2 = [0 : 1/fs : length(ste_wave)/fs];
t2 = t2(1:end - 1) / 3;

subplot(5,1,1);
%plot(t3,zcr_wave,'r','LineWidth',1);
plot(t, x, 'b', t2, ste_wave, 'r');
xlabel('time(sec)');
ylabel('magnitude');
legend('x','STE');
title('Speech signal vs STE');

subplot(5,1,2);
plot(t, x);
xlabel('time(sec)');
ylabel('magnitude');
%legend('','ste','zcr');
title('Vowel vs Silence');

% đường biên chuẩn trong file lab
for i=1:length(MDA01)
     xline(MDA01(i), 'r-', 'LineWidth', 2);
end

% xác định ngưỡng và xét
th_ste = 0.02;
%th_zcr = 0.254467;

% overlap
% theo thuật toán ste
for i=1:numberFrames-1
    %vowel
    if(ste(1, i) > th_ste)
        if ((ste(1, i + 1) < th_ste))
            xline(0.01 * i, 'g', 'LineWidth', 2);
        end
    %silence 
    else 
        if (ste(1, i + 1) > th_ste)
            xline(0.01 * (i + 3), 'g', 'LineWidth', 2);
        end
    end
end

max_value=max(abs(x));
F0 = zeros(1, numberFrames);
z = zeros(numberFrames, frame_len);
% gán khung cho mảng z
for index_frame=1:numberFrames
    for i=1:frame_len
        z(index_frame, i) = P(index_frame, i) / max_value;
    end
end

sumThresh = 0;
arrThresh = zeros(numberFrames, 1);
% tìm thresh
for index_frame=1:numberFrames
    dftz = Window_Hamming(z(index_frame, :));
    
    for i=1:length(dftz)
        % giới hạn dãy tần số <= 1kHz hoặc 2kHz
        if i * (fs / pointFFT) <= rangeFreq
            newDftz(i) = dftz(i);
        end
    end

    thresh = threshHPS(newDftz);
    sumThresh = sumThresh + thresh;
    arrThresh(index_frame) = thresh;
end

count = 0.1;
for i = 1:numberFrames
    if arrThresh(i) > 0
        count = count + 1;
    end
end
averageThresh = sumThresh / count;

% tạo cửa sổ và tính HPS cho từng khung
for index_frame=1:numberFrames
    dftz = Window_Hamming(z(index_frame, :));
    
    for i=1:length(dftz)
        % giới hạn dãy tần số <= 1kHz hoặc 2kHz
        if i * (fs / pointFFT) <= rangeFreq
            newDftz(i) = dftz(i);
        end
    end
    
    %newDftz1 = findpeaks(newDftz);
    
    F0(index_frame) = pitchDetectHPS(newDftz, index_frame, fs, ste(index_frame), th_ste, pointFFT, averageThresh);
    %[F0(index_frame), averageData] = pitchDetectPropose(newDftz, index_frame, fs, ste(index_frame), th_ste, pointFFT);
    %averageData;
    
end

F2 = downsample(F0, 3);

%figure(2);

index_frame_test = 386;
k = P(index_frame_test, :);
t3=(1/(fs):1/fs:(length(k)/fs));
subplot(5,1,4);
plot(t3,k);
title('Voiced segment of speech');
xlabel("Time(sec)");

%dftk = Window_Hamming(k);
%k2 = 0;

zero = zeros(1, 1000);
w = hamming(length(k));
for i=1:length(k)
  k(i) = k(i)*w(i);
end
k2 = [zero k zero];

dftk = abs(fft(k2, pointFFT));
dftk = dftk(1:(length(dftk) / 2));
dftk = 10*log10(dftk);

for i=1:length(dftk)
    % giới hạn dãy tần số <= 1kHz
    if i * (fs / pointFFT) <= rangeFreq
       newDftk(i) = dftk(i);
    end
end


%{
hps1 = downsample(newDftk, 1);
hps2 = downsample(newDftk, 2);
hps3 = downsample(newDftk, 3);
hps4 = downsample(newDftk, 4);
hps5 = downsample(newDftk, 5);
%}
index1 = 1;
    for i = 1:length(newDftk)
        hps1(index1) = newDftk(i);
        index1 = index1 + 1;
    end

    index1 = 1;
    for i = 1:length(newDftk)
        if mod(i, 2) == 0
            hps2(index1) = newDftk(i);
            index1 = index1 + 1;
        end
    end

    index1 = 1;
    for i = 1:length(newDftk)
        if mod(i, 3) == 0
            hps3(index1) = newDftk(i);
            index1 = index1 + 1;
        end
    end

    index1 = 1;
    for i = 1:length(newDftk)
        if mod(i, 4) == 0
            hps4(index1) = newDftk(i);
            index1 = index1 + 1;
        end
    end

    index1 = 1;
    for i = 1:length(newDftk)
        if mod(i, 5) == 0
            hps5(index1) = newDftk(i);
            index1 = index1 + 1;
        end
    end
    
y = zeros(length(hps5), 1);
for i=1:length(hps5)
    Product = hps1(i) * hps2(i) * hps3(i) * hps4(i) * hps5(i);
      y(i) = Product;
end

%{
[data1, locs1] = findpeaks(y);
data1
locs1
[data2, locs2] = findpeaks(data1);
data2
locs2
%}

fs;
freq = linspace(1/fs, 44100 / pointFFT * length(newDftk), length(newDftk));
%freq = linspace(1/fs, fs, length(dftk));
subplot(5,1,5);
%{
plot(k, 'g');
hold on
plot(w, 'b');
plot(k2, 'r');
%}
plot(freq, newDftk);
title('Log magnitude spectrum using hamming window');
xlabel("Frequent(HZ)");
%newDftk1 = findpeaks(newDftk);
%F1 = pitchDetectHPS(newDftk, 1, fs, ste(1), th_ste);


freq = linspace(1/fs, 44100 / pointFFT * length(newDftk), length(newDftk));
%freq = linspace(1/fs, fs, length(dftk));
subplot(5,1,5);
%{
plot(k, 'g');
hold on
plot(w, 'b');
plot(k2, 'r');
%}
plot(freq, newDftk);
title('Log magnitude spectrum using hamming window');
xlabel("Frequent(HZ)");

% lọc trung vị
[filterFo, fo_mean_median, fo_std_median] = filterF0(F0, numberFrames);
subplot(5,1,3);
plot(filterFo, '.');
fo_mean_median;
fo_std_median;

%{
figure(2);
max_value=max(abs(x));
z=P(60, :);
z=z/max_value;
t=1/fs:1/fs:(length(z)/fs);
subplot(3,1,1);
plot(t,z);
title('Voiced Speech waveform');

dftz=abs(fft(z, pointFFT));
dftz=dftz(1:(length(dftz)/2));
dftzlog=10*log10(dftz);
freq=linspace(1/fs,fs/2000,length(dftz));
subplot(3,1,2);
plot(freq,dftzlog);
title('Log Magnitude Spectrum');
%}

end
