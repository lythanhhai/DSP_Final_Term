%clear; clc; clf;
function [HPS] = HPS_function(newDftzlog)
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
end
