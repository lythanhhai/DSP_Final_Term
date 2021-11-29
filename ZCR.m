% tính ZCR cho từng khung
sumZCR = 0;
zcr = zeros(1, numberFrames);
for l=1:numberFrames
    sumZCR = 0;
    for k=1:frame_len-1
        if P(l, k) < 0 && P(l, k + 1) >= 0
                sumZCR = sumZCR + 2;
        elseif P(l, k) >= 0 && P(l, k + 1) < 0
                sumZCR = sumZCR + 2;
        end
    end
    zcr(1, l) = sumZCR;
end

%normalized zcr
%zcr1 = zcr./length(P(1, :));
%zcr = zcr1./max(zcr1);
zcr = zcr./(max(zcr(1, :)));


zcr_copy = zeros(numberFrames, 1);
for i = 1:numberFrames
    zcr_copy(i) = zcr(i);
end
zcr_copy;


zcr_wave = 0;
for j = 1 : length(zcr)
    l = length(zcr_wave);
    zcr_wave(l : l + frame_len) = zcr(j);
end
