function [] = drawMagnitude(ste, magnitude, numberFrames)
    % đường biên chuẩn trong file lab
    for i=1:length(magnitude)
         xline(magnitude(i), 'r-', 'LineWidth', 2);
    end

    % xác định ngưỡng và xét
    th_ste = 0.02;
    %th_zcr = 0.254467;

    % overlap
    % theo thuật toán ste
    for i=1:numberFrames-1
        % vowel
        if(ste(1, i) > th_ste)
            if ((ste(1, i + 1) < th_ste))
                xline(0.01 * i, 'g', 'LineWidth', 2);
            end
        % silence 
        else 
            if (ste(1, i + 1) > th_ste)
                xline(0.01 * (i + 3), 'g', 'LineWidth', 2);
            end
        end
    end
end