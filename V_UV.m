 %close all;clear;clc
 function [sgn] =  V_UV(filename, tenFile);
 
 % input audio
 [x,fs]=audioread(filename);
 figure('name', tenFile);
 
 % phân khung cho tín hiệu
 frame_len = 0.03 * fs;% chiều dài khung, 1 khung 30ms
 L = length(x);
 numberFrames = floor(L / frame_len);% số khung được chia
 P = zeros(numberFrames, frame_len);
 for i = 1:numberFrames
     startIndex = (i - 1) * frame_len + 1;
     for j = 1:frame_len
         P(i, j) = x(startIndex + j - 1);
     end
 end
 
% tính STE cho từng khung
%sumSTE = 0;
%ste = zeros(1, numberFrames);
%for l=1:numberFrames
    %sumSTE=0;
    %x_frame = x(frame_len * (l - 1) + 1 : frame_len * l);
    %for k=1:frame_len
        %sumSTE = sumSTE + power(P(l, k), 2);
    %end
    %ste(1, l) = sumSTE;
%end

sumSTE = 0;
ste = zeros(numberFrames);
for l=1:numberFrames
    sumSTE=0;
    %x_frame = x(frame_len * (l - 1) + 1 : frame_len * l);
    for k=1:frame_len
        sumSTE = sumSTE + power(P(l, k), 2);
    end
    ste(l) = sumSTE;
end

%normalized ste
ste = ste./max(ste(1, :));
 
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
            sumZCR = sumZCR + 1;
        elseif P(l, k) > 0 && P(l, k + 1) < 0
            sumZCR = sumZCR + 1;
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
 
time1 = 0.03 * length(ste);
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
plot(t, x, t1, ste(1, :), 'r', t1, zcr(1, :), 'g');
xlabel('time(sec)');
ylabel('Bien do');
%legend('x','ste','zcr');
title('Speech signal');

% xác định ngưỡng và xét
th_ste = 0.02;
th_zcr = 0.5;

frame_duration = 0.03;
for i=1:numberFrames-1
    %voice
    if(ste(1, i) > th_ste && zcr(1, i) < th_zcr)
        for j = (i - 1) * frame_duration : frame_duration / 2 : frame_duration * i
            if ((ste(1, i + 1) < th_ste || zcr(1, i + 1) > th_zcr) && j == (frame_duration * i))
                xline(j, 'y', 'LineWidth', 1);
            end
        end
    %unvoice 
    else 
        for j = (i - 1) * frame_duration : frame_duration / 2 : frame_duration * i
            if (ste(1, i + 1) > th_ste && zcr(1, i + 1) < th_zcr && j == (frame_duration * i))
                xline(j, 'y', 'LineWidth', 1);
            end
        end
    end
end

end
