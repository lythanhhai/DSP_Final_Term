 %close all;clear;clc
 function [Fo] =  V_UV(filename, tenFile);
 
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

%set sgn
n = -10000:10000;
sgn = [zeros(1, 10000) ones(1, 10001)];

 time = (1/fs)*length(x);
 t = linspace(0, time, length(x));
 subplot(3,1,1);
 plot(t,x);
 title(['signal ', tenFile]);
 xlabel('time(sec)');
 ylabel('amplitude');
 grid on
 
 time1 = 0.03 * length(ste);
 t1 = linspace(0, time1, length(ste));
 subplot(3,1,2);
 plot(t1, ste(1, :));
 title("test");
 grid on
 % tính ZCR cho từng khung
sumZCR = 0;
ste = zeros(numberFrames, frame_len);
for l=1:numberFrames
    sumSTE=0;
    for k=1:frame_len
        sumSTE = sumSTE + x(l - k);
        ste(l) = sumSTE;
        sumSTE = 0;
    end
end
 

end
