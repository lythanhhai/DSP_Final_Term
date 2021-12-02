 %close all;clear;clc
 function [P] =  V_UV(filename, tenFile, MDA01)
 
 % input audio
 [x,fs]=audioread(filename);
 figure('name', tenFile);
 x = x./max(x);
 % phân khung cho tín hiệu
 frame_duration = 0.03;
 frame_len = 0.03 * fs;% chiều dài khung, 1 khung 30ms
 overlap_duration = 0.01;
 overlap_len = 0.01 * fs;
 overlap_time = 0.01;
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

% xác định ngưỡng và xét
%th_ste = 0.061372;
th_ste = 0.08;
%th_zcr = 0.254467;

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

% frame
%{
% theo thuật toán zcr và ste
for i=1:numberFrames-1
    %voice
    if(ste(1, i) > th_ste && zcr(1, i) < th_zcr)
        for j = (i - 1) * frame_duration : frame_duration / 2 : frame_duration * i
            if ((ste(1, i + 1) < th_ste || zcr(1, i + 1) > th_zcr) && j == (frame_duration * i))
                xline(j, 'k', 'LineWidth', 1.5);
            end
        end
    %unvoice 
    else 
        for j = (i - 1) * frame_duration : frame_duration / 2 : frame_duration * i
            if (ste(1, i + 1) > th_ste && zcr(1, i + 1) < th_zcr && j == (frame_duration * i))
                xline(j, 'k', 'LineWidth', 1.5);
            end
        end
    end
end
%}

max_value=max(abs(x));
F0 = zeros(1, numberFrames);
z = zeros(numberFrames, frame_len);
% gán khung cho mảng z
for index_frame=1:numberFrames
    for i=1:frame_len
        z(index_frame, i) = P(index_frame, i) / max_value;
    end
end
%z=P(1, :);%60
%z=z/max_value;

%{
t3=(1/(fs):1/fs:(length(z)/fs));
subplot(5,1,3);
plot(t3,z);
title('Voiced segment of speech');
xlabel("Time(sec)");
%}

% tạo cửa sổ cho từng khung
for index_frame=1:numberFrames
    
    [dftz, dftzlog] = Window_Hamming(z(index_frame, :));
    for i=1:length(dftzlog)
        % giới hạn dãy tần số <= 1kHz
        if i * (fs / 4096) <= 1000
            newDftzlog(i) = dftzlog(i);
        end
    end
    
    hps1 = downsample(newDftzlog,1);
    hps2 = downsample(newDftzlog,2);
    hps3 = downsample(newDftzlog,3);
    hps4 = downsample(newDftzlog,4);
    hps5 = downsample(newDftzlog,5);
    
    HPS = zeros(length(hps5), 1);
    for j=1:length(hps5)
          Product = hps1(j) * hps2(j) * hps3(j) * hps4(j) * hps5(j);
          HPS(j) = Product;
    end
    
    [data, locs] = findpeaks(HPS, 'SORTSTR', 'descend');
    data;

    Maximum = locs(1);
    F0(index_frame) =  ((Maximum / 4096) * fs);
    
    if F0(index_frame) > 450 || F0(index_frame) < 70
        F0(index_frame) =  0;
    end
    
end

% lọc trung vị
soPhanTu = 5;
filterFo = zeros(1, numberFrames + 4);
% thêm 2 biên cho dãy Fo
for i=1:numberFrames+4
    if i==1 || i == 2
       filterFo(i) = F0(1);
    elseif i== numberFrames+3 || i == numberFrames+4
       filterFo(i) = F0(numberFrames);
    else 
       filterFo(i) = F0(i - 2);
    end 
end

%duyệt từng giá trị
%khung=zeros(1, soPhanTu);

u=1;% số khung chứa mỗi 5 phần tử
for j=3:numberFrames+2
    for k=1:soPhanTu
        if k == 1
            khung(u, k) = filterFo(j - 2);
        elseif k == 2
            khung(u, k) = filterFo(j - 1);
        elseif k == 3
            khung(u, k) = filterFo(j);
        elseif k == 4
            khung(u, k) = filterFo(j + 1);
        else
            khung(u, k) = filterFo(j + 2);
        end
    end
    u = u + 1;
end

% sắp xếp cho từng khung 
for i=1:u-1
    for j=1:(soPhanTu - 1)
        for k=(j+1):soPhanTu
            if khung(i, j) > khung(i, k) 
                temp = khung(i, j);
                khung(i, j) = khung(i, k);
                khung(i, k) = temp;
            end
        end
    end
end

% gán điểm đang xét cho điểm chính giữa mỗi khung được tách 
index=1;
for i=3:numberFrames+2
    filterFo(i) = khung(index, 3);
    index = index + 1;
end

% tính trung bình cộng Fo sau khi lọc trung vị (Fo_mean_median)
fomean_median = 0;
j =0;
for i=1:(numberFrames + 4)
    if filterFo(i) ~= 0
       fomean_median = fomean_median + filterFo(i);
       j = j + 1;
    end
end

% tính độ lệch chuẩn (Fo_std)
phuongsai_median = 0;
for i=1:(numberFrames + 4)
    if filterFo(i) ~= 0
        phuongsai_median = phuongsai_median + power(filterFo(i) - fomean_median/j, 2);
    end
end

% trung bình cộng
fo_mean_median = fomean_median/j
% độ lệch chuẩn
fo_std_median = sqrt(phuongsai_median / (j-1))


subplot(5,1,3);
plot(filterFo, '.');

%{
freq=linspace(1/fs, fs, length(dftz));
length(dftzlog);
subplot(5,1,4);
plot(freq, dftzlog);
title('Log magnitude spectrum using hamming window');
xlabel("Frequent(HZ)");

subplot(5,1,5);
plot(F0, '.');
%}


%{
figure(2);
max_value=max(abs(x));
z=P(60, :);
z=z/max_value;
t=1/fs:1/fs:(length(z)/fs);
subplot(3,1,1);
plot(t,z);
title('Voiced Speech waveform');

dftz=abs(fft(z, 4096));
dftz=dftz(1:(length(dftz)/2));
dftzlog=10*log10(dftz);
freq=linspace(1/fs,fs/2000,length(dftz));
subplot(3,1,2);
plot(freq,dftzlog);
title('Log Magnitude Spectrum');
%}

end
