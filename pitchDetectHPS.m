%clear; clc; clf;
function [F0] = pitchDetectHPS(newDftz, index_frame, fs, ste, th_ste)
    %{
    hps1 = downsample(newDftz, 1);
    hps2 = downsample(newDftz, 2);
    hps3 = downsample(newDftz, 3);
    hps4 = downsample(newDftz, 4);
    hps5 = downsample(newDftz, 5);
    %}
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
    
    y = zeros(length(hps5), 1);
    for i=1:length(hps5)
          Product = hps1(i) * hps2(i) * hps3(i) * hps4(i) * hps5(i);
          y(i) = Product;
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
    
    %if HPS(locs(1)) * 0.5 > HPS(locs(2))
        %Maximum = locs(length(locs));
    %end
    
    F0 =  ((Maximum / 4096) * fs);
    
    if F0 > 400 || F0 < 70 || ste < th_ste
        F0 =  0;
    end
end
