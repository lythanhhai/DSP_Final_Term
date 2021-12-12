%clear; clc; clf;
function [F0] = pitchDetectHPS(newDftz, index_frame, fs, ste, th_ste, pointFFT, averageThresh)
    
    index1 = 1;
    for i = 1:length(newDftz)
        hps1(index1) = newDftz(i);
        index1 = index1 + 1;
    end

    index1 = 1;
    for i = 1:length(newDftz)
        if mod(i, 2) == 0
            hps2(index1) = newDftz(i);
            index1 = index1 + 1;
        end
    end

    index1 = 1;
    for i = 1:length(newDftz)
        if mod(i, 3) == 0
            hps3(index1) = newDftz(i);
            index1 = index1 + 1;
        end
    end

    index1 = 1;
    for i = 1:length(newDftz)
        if mod(i, 4) == 0
            hps4(index1) = newDftz(i);
            index1 = index1 + 1;
        end
    end

    index1 = 1;
    for i = 1:length(newDftz)
        if mod(i, 5) == 0
            hps5(index1) = newDftz(i);
            index1 = index1 + 1;
        end
    end
    %{
    hps1 = downsample(newDftz, 1);
    hps2 = downsample(newDftz, 2);
    hps3 = downsample(newDftz, 3);
    hps4 = downsample(newDftz, 4);
    hps5 = downsample(newDftz, 5);
    %}
    y = zeros(length(hps5), 1);
    %index = 0;
    for i=1:length(hps5)
          Product = hps1(i) * hps2(i) * hps3(i) * hps4(i) * hps5(i);
          y(i) = Product;
          index(i) = i;% vị trí
    end
    
    %{
    y = [];
    for i=1:length(hps5)
      Product =   hps1(i) * hps2(i) * hps3(i) * hps4(i) * hps5(i);
      y(i) = [Product];
    end
    %}
    
    [data, locs] = findpeaks(y, 'SORTSTR', 'descend');
    data;

    Maximum = locs(1);
    
    thresh = 0;
    
    % phát hiện pitch ảo
    
    
    if length(locs) > 2
        thresh = y(locs(2)) / y(locs(1));
        if y(locs(1)) * averageThresh < y(locs(2))
            [data1, locs1] = findpeaks(y);
            [data2, locs2] = findpeaks(data1);
            %Maximum = locs(length(locs));
            if length(locs2) > 0
                Maximum = locs1(locs2(length(locs2)));
            end
        end
    end
    
    if Maximum < 20 && Maximum > 7
        %Maximum = Maximum * 2;
    end
    
    
    F0 =  ((Maximum / pointFFT) * fs);
    
    if F0 > 400 || F0 < 70 || ste < th_ste
        F0 =  0;
    end
end
