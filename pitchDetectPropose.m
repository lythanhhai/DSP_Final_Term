%clear; clc; clf;
function [F0, averageData] = pitchDetectPropose(newDftz, index_frame, fs, ste, th_ste)
    [data, locs] = findpeaks(newDftz);
    if ste > th_ste
        sum = 0;
        for i=1:length(data)
            sum = sum + data(i);
        end
        averageData = sum / length(data);
        % tìm hài cho khung tín hiệu
        %harmonic = [];
        index = 1;
        harmonic = [];
        for i=1:length(data)
            if data(i) > 10
                harmonic(index) = locs(i);% mảng lưu vị trí
                index = index + 1;
            end
        end

        % tìm khoảng cách giữa các hài.
        space = zeros(length(harmonic)-1);
        for i=1:length(harmonic)-1
            space(i) = (harmonic(i + 1) - harmonic(i)) * fs / 4096; 
        end

        % check các khoảng trống xem bằng nhau không
        check = 0; % biến kiểm tra;
        for i=1:length(space)-1
            if space(i) < (space(i + 1) + 50) && space(i) > (space(i + 1) - 50)
               check = check + 1;
            end
        end

        % nếu bằng nhau
        if check == length(space)-1
            F0 =  (harmonic(2) - harmonic(1)) * fs / 4096;

            if F0 > 400 || F0 < 70 || ste < th_ste
                F0 =  0;
            end
        % nếu không bằng nhau    
        else 
            F0 = 0;
        end
    else 
        F0 = 0;
        averageData = 0;
    end
    
    
end
