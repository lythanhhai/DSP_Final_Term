%clear; clc; clf;
function [F0, averageData] = pitchDetectPropose(newDftz, index_frame, fs, ste, th_ste, pointFFT)
    [data, locs] = findpeaks(newDftz);
    %[data, locs] = findpeaks(data1);
    % biến đổi data và locs
    %{
    data = zeros(floor(length(data1) / 3), 3);
    locs = zeros(floor(length(data1) / 3), 3);
    index_data = 1;
    for i=1:3:length(data1)
        data(index_data, 1) = data1(i);
        data(index_data, 2) = data1(i+1);
        data(index_data, 3) = data1(i+2);
        locs(index_data, 1) = locs1(i);
        locs(index_data, 2) = locs1(i+1);
        locs(index_data, 3) = locs1(i+2);
        index_data = index_data + 1;
    end
    %}
    if ste > th_ste
        sum = 0;
        for i=1:length(data)
            sum = sum + data(i);
        end
        averageData = sum / length(data);
        
        % tìm min cực đại
        min = max(data);
        for i=1:length(data)
            %if data(i) < min && data(i) > 0
            if data(i) < min
               min = data(i);
            end
        end

        % tìm vị trí cực đại lớn nhất
        vitri = 1;
        for i=1:length(data)
            if max(data) == data(i)
                vitri = i;
                break;
            end
        end
        % tìm hài cho khung tín hiệu
        %harmonic = [];
        index = 1;
        harmonic = [];
        for i=1:length(data)
            if data(i) > averageData 
            %if data(i) > 9.91
            %if data(i) * 0.36 > min
            %if max(data) * 0.5 < data(i)
            %if data(i) > averageData
                harmonic(index) = locs(i);% mảng lưu vị trí
                index = index + 1;
            end
        end

        % tìm khoảng cách giữa các hài.
        space = zeros(length(harmonic)-1, 1);
        for i=1:length(harmonic)-1
            space(i) = (harmonic(i + 1) - harmonic(i)) * fs / pointFFT; 
        end

        % check các khoảng trống xem bằng nhau không
        check = 0; % biến kiểm tra;
        for i=1:length(space)-1
            if space(i) < (space(i + 1) + 30) && space(i) > (space(i + 1) - 30)
               check = check + 1;
            end
        end
       

        % nếu bằng nhau
        if check == length(space) - 1
            F0 =  (harmonic(2) - harmonic(1)) * fs / pointFFT;
            %if length(space) > 1
                %F0 =  sum(space)/length(space);
            %end
            
            if F0 > 400 || F0 < 70 || ste < th_ste
                F0 =  0;
            end
        % nếu không bằng nhau    
        else 
            %F0 =  space(1);
            F0 = 0;
        end
    else 
        F0 = 0;
        averageData = 0;
    end
end
