function [periodic] = AMDF(P, numberFrames, frame_len, fs)
    % tính AMDF cho từng khung
    sum1 = 0;
    d = zeros(numberFrames, frame_len);
    for l=1:numberFrames
        sum1=0;
        for k=1:frame_len
            for m = 1:(frame_len - 1 - k)
                sum1 = sum1 + abs(P(l, m) - P(l, m + k));
            end
            d(l, k) = sum1;
            sum1=0;
        end
    end

    % chuẩn hóa
    max123=max(d(:));
    normalizedAMDF = d / max123;


    % tìm cực tiểu của khung tín hiệu(con người có tần số thuộc khoảng 70-450Hz)
    T0_min=fs/400;
    T0_max=fs/70;
    minimum = zeros(numberFrames, frame_len);% lưu các cực tiểu cục bộ trong 1 khung 
    maxSignal = zeros(numberFrames, 1);% tìm kiếm giá trị lớn nhất của khung tín hiệu
    for nf=1:numberFrames
        for r=2:frame_len
               if (normalizedAMDF(nf, r) < normalizedAMDF(nf, r-1)) && (normalizedAMDF(nf, r) < normalizedAMDF(nf, r+1)) && r > T0_min && r < T0_max
                   minimum(nf, r) = normalizedAMDF(nf, r);
               end   
        end
        maxSignal(nf) = max(normalizedAMDF(nf, :));
    end

    % tìm cực tiểu cục bộ nhỏ nhất của từng khung và vị trí của nó
    minimum1=zeros(numberFrames, 1);
    vitri=zeros(numberFrames, 1);
    min1 = 10000;
    vitriMin=10000;
    for e=1:numberFrames
        min1 = 10000;
        vitriMin=10000;
        for r=1:frame_len
            if minimum(e, r) ~= 0 && min1 > minimum(e, r)
                min1 = minimum(e, r);
                vitriMin = r;
            end
        end
        minimum1(e) = min1;
        vitri(e) = vitriMin;
    end

    % so sánh với ngưỡng để phân biệt vô thanh, hữu thanh
    periodic = zeros(numberFrames, 1);
    for i=1:numberFrames
        max1 = max(normalizedAMDF(i, :));
        if minimum1(i) < (max1 * 0.33)
           periodic(i) = 1;
        end
    end
end