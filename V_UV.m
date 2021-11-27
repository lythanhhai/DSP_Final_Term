 %close all;clear;clc
 function [sgn] =  V_UV(filename, tenFile, MDA01);
 
 % input audio
 [x,fs]=audioread(filename);
 figure('name', tenFile);
 
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
     if endIndex < L
        for j = 1:frame_len
            P(i, j) = x(startIndex + j - 1);
        end 
     else 
        for j = startIndex:frame_len
            P(i, j) = x(j - 1);
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

ste_wave = 0;
for j=1:numberFrames
    l = length(ste_wave);
    ste_wave(l : l + frame_len) = ste(j);
end

%length(ste_wave)

length(ste_wave)

%set sgn
n = -1000:1000;
sgn = [zeros(1, 1000) ones(1, 1001)];

% tính ZCR cho từng khung
sumZCR = 0;
zcr = zeros(1, numberFrames);
for l=1:numberFrames
    sumZCR = 0;
    for k=1:frame_len-1
        if P(l, k) < 0 && P(l, k + 1) > 0
            sumZCR = sumZCR + 2;
        elseif P(l, k) > 0 && P(l, k + 1) < 0
            sumZCR = sumZCR + 2;
        end
        %sumZCR = sumZCR + abs(sgn(P(l, k)) - sgn(P(l, k - 1)));
    end
    zcr(1, l) = sumZCR;
end

%normalized zcr
zcr = zcr./max(zcr(1, :));
 
 
time = (1/fs)*length(x);
t = linspace(0, time, length(x));
%subplot(4,1,1);
%plot(t,x);
%title(['signal ', tenFile]);
%xlabel('time(sec)');
%ylabel('amplitude');
grid on

time1 = overlap_duration * length(ste);
t1 = linspace(0, time1, length(ste));
%subplot(4,1,2);
%plot(t1, ste(1, :));
%title("test");
%grid on
 
%subplot(4,1,3);
%plot(t1, zcr(1, :));
%title("test1");
%grid on 
 
subplot(2,1,1)
plot(t, x, 'c', t1, ste(1, :), 'r', t1, zcr(1, :), 'g');
xlabel('time(sec)');
ylabel('magnitude');
legend('x','STE','ZCR');
title('Speech signal vs STE vs ZCR');

% xác định ngưỡng và xét
th_ste = 0.001;
th_zcr = 0.81;


subplot(2,1,2)
plot(t, x);
xlabel('time(sec)');
ylabel('magnitude');
%legend('','ste','zcr');
title('Voice vs Unvoice');

% chuẩn trong file lab
for i=1:length(MDA01)
     xline(MDA01(i), 'r', 'LineWidth', 1.5);
end

% theo thuật toán zcr và ste
for i=1:numberFrames-1
    %voice
    if(ste(1, i) > th_ste && zcr(1, i) < th_zcr)

        for j = (i - 1) * overlap_duration : overlap_duration / 2 : overlap_duration * i
            if ((ste(1, i + 1) < th_ste || zcr(1, i + 1) > th_zcr) && j == (overlap_duration * i))
                xline(j, 'g', 'LineWidth', 1.5);

        for j = (i - 1) * frame_duration : frame_duration / 2 : frame_duration * i
            if ((ste(1, i + 1) < th_ste || zcr(1, i + 1) > th_zcr) && j == (frame_duration * i))
                xline(j, 'k', 'LineWidth', 1.5);
            end
        end
    %unvoice 
    else 

        for j = (i - 1) * overlap_duration : overlap_duration / 2 : overlap_duration * i
            if (ste(1, i + 1) > th_ste && zcr(1, i + 1) < th_zcr && j == (overlap_duration * i))
                xline(j, 'g', 'LineWidth', 1.5);
        for j = (i - 1) * frame_duration : frame_duration / 2 : frame_duration * i
            if (ste(1, i + 1) > th_ste && zcr(1, i + 1) < th_zcr && j == (frame_duration * i))
                xline(j, 'k', 'LineWidth', 1.5);
            end
        end
    end
end

end
