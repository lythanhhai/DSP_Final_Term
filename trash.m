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


% thuật toán hps
%{
%[data1, locs1] = findpeaks(y, 'SORTSTR', 'descend');

[data1, locs1] = findpeaks(y);
data1;
locs1;
[data2, locs2] = findpeaks(data1);
data2;
locs2;

Maximum = locs1(1);
    
if y(locs1(1)) * 0.5 < y(locs1(2))
   Maximum = locs1(length(locs1));
end
    
F1 =  ((Maximum / pointFFT) * fs)
%}




% thuật toán propose

%{
        [data1, locs1] = findpeaks(newDftk);
        data1;
        locs1;
        [data, locs] = findpeaks(data1);
        %data = [ data 0 ];
        data;
        locs;
        sum = 0;
        for i=1:length(data1)
            sum = sum + data1(i);
        end
        averageData = sum / length(data1);
        
        % tìm min cực đại
        min = max(data);
        for i=1:length(data)
            if data(i) < min
               min = data(i);
            end
        end
        min;

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
            %if data(i) > averageData 
            %if data(i) > 9.90
            %if data(i) * 0.36 > min
            %if max(data) * 0.65 < data(i) && i > vitri
                harmonic(index) = locs1(locs(i));% mảng lưu vị trí
                %harmonic(index) = locs(i);% mảng lưu vị trí
                index = index + 1;
            %end
        end
        harmonic;

        % tìm khoảng cách giữa các hài.
        space = zeros(length(harmonic)-1, 1);
        for i=1:length(harmonic)-1
            space(i) = (harmonic(i + 1) - harmonic(i)) * fs / pointFFT; 
        end
        space;
        % check các khoảng trống xem bằng nhau không
        check = 0; % biến kiểm tra;
        for i=1:length(space)-1
            if space(i) < (space(i + 1) + 30) && space(i) > (space(i + 1) - 30)
               check = check + 1;
            end
        end
        

        % nếu bằng nhau
        if check == length(space)-1
            F1 =  (harmonic(2) - harmonic(1)) * fs / pointFFT;
            if F1 > 400 || F1 < 70 || ste(index_frame_test) < th_ste
                F1 =  0;
            end
        % nếu không bằng nhau    
        else 
            F1 = 0;
        end
    F1;
    %}