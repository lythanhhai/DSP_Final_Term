 %close all;clear;clc
 function [P] =  V_UV(filename, tenFile, MDA01);
 
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
        for j = L:(endIndex - L)
            P(i, j) = 0;
        end
     end
 end
 

% tính STE cho từng khung
sumSTE = 0;
ste = zeros(1, numberFrames);
for l=1:numberFrames
    sumSTE=0;
    %x_frame = x(frame_len * (l - 1) + 1 : frame_len * l);
    for k=1:frame_len
        sumSTE = sumSTE + power(P(l, k), 2);
    end
    ste(1, l) = sumSTE;
end

%normalized ste
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
%length(ste_wave)

time = (1/fs)*length(x);
t = linspace(0, time, length(x));
grid on

time1 = 0.01 * length(ste);
t1 = linspace(0, time1, length(ste));

t2 = [0 : 1/fs : length(ste_wave)/fs];
t2 = t2(1:end - 1) / 3;

 
subplot(4,1,1);
%plot(t3,zcr_wave,'r','LineWidth',1);
plot(t, x, 'c', t2, ste_wave, 'r');
xlabel('time(sec)');
ylabel('magnitude');
legend('x','STE');
title('Speech signal vs STE');

% xác định ngưỡng và xét
%th_ste = 0.061372;
th_ste = 0.00024;
th_zcr = 0.254467;

subplot(4,1,2)
plot(t, x);
xlabel('time(sec)');
ylabel('magnitude');
%legend('','ste','zcr');
title('Vowel vs Silence');

% chuẩn trong file lab
for i=1:length(MDA01)
     xline(MDA01(i), 'r-', 'LineWidth', 2);
end

%overlap
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

% frame
%{
% theo thuật toán zcr và ste
for i=1:numberFrames-1
    %voice
    if(ste(1, i) > th_ste && zcr(1, i) < th_zcr)
        for j = (i - 1) * frame_duration : frame_duration / 2 : frame_duration * i
            if ((ste(1, i + 1) < th_ste || zcr(1, i + 1) > th_zcr) && j == (frame_duration * i))
                xline(j, 'g', 'LineWidth', 1.5);
            end
        end
    %unvoice 
    else 
        for j = (i - 1) * frame_duration : frame_duration / 2 : frame_duration * i
            if (ste(1, i + 1) > th_ste && zcr(1, i + 1) < th_zcr && j == (frame_duration * i))
                xline(j, 'g', 'LineWidth', 1.5);
            end
        end
    end
end
%}

%{
% phổ biên độ sử dụng fft
y = fft(x, 4096);
subplot(3,1,3)
plot(y);
xlabel('Frequency(Hz)');
ylabel('magnitude');
%legend('','ste','zcr');
title('Spectrum');
%}

% test
%{
max_value=max(abs(x));
x=x/max_value;

dftx=abs(fft(x, 4096));
len=length(dftx);
tt=linspace(1/fs, fs/2000, length(dftx));
dftxlog=10*log10(dftx);
subplot(4,1,3);
plot(tt,dftxlog);
xlabel('frequency in Hz');
%}



max_value=max(abs(x));
z=P(60, :);
z=z/max_value;
t3=(1/(fs):1/fs:(length(z)/fs));
subplot(4,1,3);
plot(t3,z);
title('Voiced segment of speech');
xlabel("Time(sec)");


z2=0;
zero=zeros(1:10000);
w=window(@hamming, length(z));
for i=1:length(z)
  z(i)=z(i)*w(i);
end
z2 = [zero y zero];

dftz=abs(fft(z2));
dftz=dftz(1:(length(dftz)/2));
dftzlog=10*log10(dftz);
freq=linspace(1/fs, fs/2000, length(dftz));
subplot(4,1,4);
plot(freq,dftzlog);
title('Log magnitude spectrum using hamming window');
xlabel("Frequent in HZ");


%{
figure(2);
max_value=max(abs(x));
z=P(60, :);
z=z/max_value;
t=1/fs:1/fs:(length(z)/fs);
subplot(3,1,1);
plot(t,z);
title('Voiced Speech waveform');

dftz=abs(fft(z));
dftz=dftz(1:(length(dftz)/2));
dftzlog=10*log10(dftz);
freq=linspace(1/fs,fs/2000,length(dftz));
subplot(3,1,2);
plot(freq,dftylog);
title('Log Magnitude Spectrum');
%}

end
