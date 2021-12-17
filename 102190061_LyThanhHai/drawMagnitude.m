function [findMagnitude] = drawMagnitude(ste, magnitude, numberFrames)
    % đường biên chuẩn trong file lab
    for i=1:length(magnitude)
         xline(magnitude(i), 'r-', 'LineWidth', 2);
    end

    % xác định ngưỡng và xét
    th_ste = 0.02;
    %th_zcr = 0.254467;

    % overlap
    % mảng chứa các biên tìm được
    % theo thuật toán ste
    index = 1;
    for i=1:numberFrames-1
        % vowel
        if(ste(1, i) > th_ste)
            if ((ste(1, i + 1) < th_ste))
                xline(0.01 * (i), 'g', 'LineWidth', 2);
                findMagnitude(index) = 0.01 * (i);
                index = index + 1;
            end
        % silence 
        else 
            if (ste(1, i + 1) > th_ste)
                xline(0.01 * (i + 1), 'g', 'LineWidth', 2);
                findMagnitude(index) = 0.01 * (i + 1);
                index = index + 1;
            end
        end
    end
end