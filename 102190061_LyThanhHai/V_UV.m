 %close all;clear;clc
 function [P] =  V_UV(filename, tenFile, magnitude, pointFFT, rangeFreq, frame_voice, frame_silence)
 
     % input audio
     [x,fs]=audioread(filename);
     figure('name', tenFile);

     % chuẩn hóa tín hiệu
     x = x./max(x);

     frame_duration = 0.03;
     frame_len = frame_duration * fs;% chiều dài khung, 1 khung 30ms
     overlap_duration = 0.01;
     overlap_len = overlap_duration * fs;
     L = length(x);

     % phân khung cho tín hiệu
     numberFrames = floor((L - frame_len) / overlap_len + 1);% số khung được chia
     P = zeros(numberFrames, frame_len);
     for i = 1:numberFrames
         startIndex = (i - 1) * overlap_len + 1;
         endIndex = (i - 1) * overlap_len + frame_len + 1;
         if endIndex <= L
            for j = 1:frame_len
                P(i, j) = x(startIndex + j - 1);
            end 
         else 
            for j = 1:(L - startIndex)
                P(i, j) = x(startIndex + j - 1);
            end 
            for j = (L - startIndex + 1):frame_len
                P(i, j) = 0;
            end
         end
     end

    % mảng xác định khung có tuần hoàn không
    periodic = AMDF(P, numberFrames, frame_len, fs);

    % tính STE cho từng khung
    ste = zeros(1, numberFrames);
    for l=1:numberFrames
        sumSTE=0;
        for k=1:frame_len
            sumSTE = sumSTE + power(P(l, k), 2);
        end
        ste(1, l) = sumSTE;
    end

    % normalized ste
    ste = ste./max(ste(1, :));

    ste_copy = zeros(numberFrames, 1);
    for i = 1:numberFrames
        ste_copy(i) = ste(i);
    end
    %ste_copy;

    ste_wave = 0;
    for j = 1 : length(ste)
        l = length(ste_wave);
        ste_wave(l : l + frame_len) = ste(j);
    end

    max_value=max(abs(x));
    F0 = zeros(1, numberFrames);
    z = zeros(numberFrames, frame_len);
    % gán khung cho mảng z
    for index_frame=1:numberFrames
        for i=1:frame_len
            z(index_frame, i) = P(index_frame, i) / max_value;
        end
    end

    % tạo cửa sổ và tính HPS cho từng khung
    for index_frame=1:numberFrames
        dftz = Window_Hamming(z(index_frame, :), pointFFT);

        for i=1:length(dftz)
            % giới hạn dãy tần số <= 1kHz hoặc 2kHz
            if i * (fs / pointFFT) <= rangeFreq
                newDftz(i) = dftz(i);
            end
        end

        F0(index_frame) = 0;
        if periodic(index_frame) == 1
            [F0(index_frame), thresh] = pitchDetectHPS(newDftz, index_frame, fs, pointFFT, periodic);
        end

        %[F0(index_frame), averageData] = pitchDetectPropose(newDftz, index_frame, fs, ste(index_frame), th_ste, pointFFT);
        %averageData;

    end

    % tính trung bình cộng Fo trước khi lọc trung vị
    fomean_median = 0;
    j = 0;
    for i=1:(numberFrames)
        if F0(i) ~= 0
           fomean_median = fomean_median + F0(i);
           j = j + 1;
        end
    end

    % tính độ lệch chuẩn (Fo_std)
    phuongsai_median = 0;
    for i=1:(numberFrames)
        if F0(i) ~= 0
            phuongsai_median = phuongsai_median + power(F0(i) - fomean_median / j, 2);
        end
    end

    % trung bình cộng
    fo_mean_median_be = fomean_median/j;
    % độ lệch chuẩn
    fo_std_median_be = sqrt(phuongsai_median / (j-1));

    % lọc trung vị
    [filterFo, fo_mean_median, fo_std_median] = filterF0(F0, numberFrames);
    %subplot(5,1,3);
    %plot(filterFo, '.');
    fo_mean_median;
    fo_std_median;
    
    % kiểm tra khung bị pitch ảo
    %{
    index_frame_test = 70;
    k = P(index_frame_test, :);
    t3=(1/(fs):1/fs:(length(k)/fs));
    subplot(2, 2, 1);
    plot(t3,k);
    title('Voiced segment of speech');
    xlabel("Time(sec)");
    ylabel("Magnitude");
    

    w = hamming(length(k));
    for i=1:length(k)
      k2(i) = k(i)*w(i);
    end

    dftk = abs(fft(k2, pointFFT));
    dftk = dftk(1:(length(dftk) / 2));
    dftk = 10*log10(dftk);

    for i=1:length(dftk)
        % giới hạn dãy tần số <= 1kHz
        if i * (fs / pointFFT) <= rangeFreq
           newDftk(i) = dftk(i);
        end
    end
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

    y = zeros(length(hps5), 1);
    for i=1:length(hps5)
        Product = hps1(i) * hps2(i) * hps3(i) * hps4(i) * hps5(i);
          y(i) = Product;
    end
    %{
    [data, locs] = findpeaks(y, 'SORTSTR', 'descend');
    data;
    locs;
    [data1, locs1] = findpeaks(y);
    data1;
    locs1;
    [data2, locs2] = findpeaks(data1);
    data2;
    locs2;
    subplot(5,1,3);
    plot(data);
    subplot(5,1, 5);
    plot(data1);
    %}
    freq = linspace(1/fs, 44100 / pointFFT * length(newDftk), length(newDftk));
    subplot(2, 2, 3);
    plot(freq, newDftk);
    title('Log magnitude spectrum using hamming window');
    xlabel("Frequent(HZ)");
    ylabel("LMS(db)");

    %{
    time = (1/fs)*length(x);
    t = linspace(0, time, length(x));
    subplot(5,1,4);
    plot(t, x);
    xlabel('time(sec)');
    ylabel('magnitude');
    title(['Speech signal ', tenFile]);
    %}
    
    index_frame_test = 366;
    k = P(index_frame_test, :);
    t3=(1/(fs):1/fs:(length(k)/fs));
    subplot(2,2,2);
    plot(t3,k);
    title('Voiced segment of speech');
    xlabel("Time(sec)");
    ylabel("Magnitude");
    
    
    w = hamming(length(k));
    for i=1:length(k)
      k2(i) = k(i)*w(i);
    end

    dftk = abs(fft(k2, pointFFT));
    dftk = dftk(1:(length(dftk) / 2));
    dftk = 10*log10(dftk);

    for i=1:length(dftk)
        % giới hạn dãy tần số <= 1kHz
        if i * (fs / pointFFT) <= rangeFreq
           newDftk(i) = dftk(i);
        end
    end
    
    freq = linspace(1/fs, 44100 / pointFFT * length(newDftk), length(newDftk));
    subplot(2,2,4);
    plot(freq, newDftk);
    title('Log magnitude spectrum using hamming window');
    xlabel("Frequent(HZ)");
    ylabel("LMS(db)");
    
    %}
    

    row = 7;

    % khung thời gian tín hiệu
    time = (1/fs)*length(x);
    t = linspace(0, time, length(x));

    % khung thời gian F0 sau khi lọc trung vị
    time2 = 0.01 * length(F0);
    t2 = linspace(0, time2, length(F0));

    % khung thời gian F0
    time1 = 0.01 * length(filterFo);
    t1 = linspace(0, time1, length(filterFo));

    % khung thời gian ste
    t3 = [0 : 1/fs : length(ste_wave)/fs];
    t3 = t3(1:end - 1) / 3;

    % vẽ tín hiệu
    subplot(row,1,1);
    plot(t, x);
    xlabel('time(sec)');
    ylabel('magnitude');
    title(['Speech signal ', tenFile]);

    % kết quả khi chưa lọc
    subplot(row,1,2);
    plot(t, x);
    xlabel('time(sec)');
    ylabel('magnitude');
    %legend('','ste','zcr');
    title('Vowel vs Silence');

    % vẽ biến chuẩn và biên theo thuật toán
    findMagnitude = drawMagnitude(ste, magnitude, numberFrames);
    findMagnitude1 = zeros(length(findMagnitude), 1);
    for i = 1:length(findMagnitude)
        findMagnitude1(i) = findMagnitude(i);
    end
    findMagnitude1;

    % kết quả khi chưa lọc
    subplot(row,1,3);
    plot(t2, F0, '.');
    xlabel('time(sec)');
    ylabel('F0(Hz)');
    title(['Fo trước khi lọc trung vị: ', 'Fomean = ', num2str(fo_mean_median_be), 'Hz ', ' Fostd = ', num2str(fo_std_median_be), 'Hz']);

    % kết quả khi đã lọc
    subplot(row,1,4);
    plot(t1, filterFo, '.');
    xlabel('time(sec)');
    ylabel('F0(Hz)');
    title(['Fo sau khi lọc trung vị: ', 'Fomean = ', num2str(fo_mean_median), 'Hz ', ' Fostd = ', num2str(fo_std_median), 'Hz']);

    % vẽ đồ thị trung gian ste
    subplot(row,1,5);
    plot(t, x, t3, ste_wave, 'r');
    xlabel('time(sec)');
    ylabel('magnitude');
    legend('Speech signal','STE');
    title('Speech signal vs STE');

    % voice
    time4 = (1/fs)*length(P(frame_voice, :));
    t4 = linspace(0, time4, length(P(frame_voice, :)));

    % silence
    time5 = (1/fs)*length(P(frame_silence, :));
    t5 = linspace(0, time4, length(P(frame_silence, :)));

    % khung voice trên miền thời gian
    subplot(row,2,11);
    plot(t4, P(frame_voice, :));
    xlabel('time(sec)');
    ylabel('magnitude');
    title('Khung voice');

    % khung khoảng lặng trên miền thời gian
    subplot(row,2,12);
    plot(t5, P(frame_silence, :));
    xlabel('time(sec)');
    ylabel('magnitude');
    title('Khung silence');

    k1 = Window_Hamming(z(frame_voice, :), pointFFT); 
    k2 = Window_Hamming(z(frame_silence, :), pointFFT);

    % phổ biên độ voice
    freq_voice = linspace(1/fs, fs / 2000, length(k1));

    % phổ biên độ silence
    freq_silence = linspace(1/fs, fs / 2000, length(k2));

    % phổ biên độ khung voice sau khi tính fft
    subplot(row,2,13);
    plot(freq_voice, k1);
    xlabel('frequency(kHz)');
    ylabel('LMS(dB)');
    title('Phổ biên độ khung voice');

    % phổ biên độ khung khoảng lặng sau khi tính fft
    subplot(row,2,14);
    plot(freq_silence, k2);
    xlabel('frequency(kHz)');
    ylabel('LMS(dB)');
    title('Phổ biên độ khung silence');


end
