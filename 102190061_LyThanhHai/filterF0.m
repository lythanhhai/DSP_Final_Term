% lọc trung vị
function [filterFo, fo_mean_median, fo_std_median] = filterF0(F0, numberFrames)
    soPhanTu = 5;
    filterFo = zeros(1, numberFrames + 4);
    % thêm 2 biên cho dãy Fo
    for i=1:numberFrames+4
        if i==1 || i == 2
           filterFo(i) = F0(1);
        elseif i== numberFrames+3 || i == numberFrames+4
           filterFo(i) = F0(numberFrames);
        else 
           filterFo(i) = F0(i - 2);
        end 
    end

    %duyệt từng giá trị
    %khung=zeros(1, soPhanTu);

    u=1;% số khung chứa mỗi 5 phần tử
    for j=3:numberFrames+2
        for k=1:soPhanTu
            if k == 1
                khung(u, k) = filterFo(j - 2);
            elseif k == 2
                khung(u, k) = filterFo(j - 1);
            elseif k == 3
                khung(u, k) = filterFo(j);
            elseif k == 4
                khung(u, k) = filterFo(j + 1);
            else
                khung(u, k) = filterFo(j + 2);
            end
        end
        u = u + 1;
    end

    % sắp xếp cho từng khung 
    for i=1:u-1
        for j=1:(soPhanTu - 1)
            for k=(j+1):soPhanTu
                if khung(i, j) > khung(i, k) 
                    temp = khung(i, j);
                    khung(i, j) = khung(i, k);
                    khung(i, k) = temp;
                end
            end
        end
    end

    % gán điểm đang xét cho điểm chính giữa mỗi khung được tách 
    index=1;
    for i=3:numberFrames+2
        filterFo(i) = khung(index, 3);
        index = index + 1;
    end

    % tính trung bình cộng Fo sau khi lọc trung vị (Fo_mean_median)
    fomean_median = 0;
    j =0;
    for i=1:(numberFrames + 4)
        if filterFo(i) ~= 0
           fomean_median = fomean_median + filterFo(i);
           j = j + 1;
        end
    end

    % tính độ lệch chuẩn (Fo_std)
    phuongsai_median = 0;
    for i=1:(numberFrames + 4)
        if filterFo(i) ~= 0
            phuongsai_median = phuongsai_median + power(filterFo(i) - fomean_median/j, 2);
        end
    end

    % trung bình cộng
    fo_mean_median = fomean_median/j;
    % độ lệch chuẩn
    fo_std_median = sqrt(phuongsai_median / (j-1));
end