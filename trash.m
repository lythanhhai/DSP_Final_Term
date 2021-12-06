%{
index1 = 1;
for i = 1:length(newDftk)
    hps1(index1) = newDftk(i);
    index1 = index1 + 1;
end

index1 = 1;
for i = 1:length(newDftk)
    if mod(i, 2) == 0
        hps2(index1) = newDftk(i);
        index1 = index1 + 1;
    end
end

index1 = 1;
for i = 1:length(newDftk)
    if mod(i, 3) == 0
        hps3(index1) = newDftk(i);
        index1 = index1 + 1;
    end
end

index1 = 1;
for i = 1:length(newDftk)
    if mod(i, 4) == 0
        hps4(index1) = newDftk(i);
        index1 = index1 + 1;
    end
end

index1 = 1;
for i = 1:length(newDftk)
    if mod(i, 5) == 0
        hps5(index1) = newDftk(i);
        index1 = index1 + 1;
    end
end

hps5;
%}