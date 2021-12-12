%clear; clc; clf;
function [thresh] = threshHPS(newDftz)
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
    for i=1:length(hps5)
          Product = hps1(i) * hps2(i) * hps3(i) * hps4(i) * hps5(i);
          y(i) = Product;
    end
    
    [data, locs] = findpeaks(y, 'SORTSTR', 'descend');

    thresh = 0;
    % tính thresh
    if length(locs) > 2
        thresh = y(locs(2)) / y(locs(1));
    end
end
