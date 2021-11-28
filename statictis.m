MDA01 = [0, 0.45, 0.81, 1.53, 1.85, 2.69, 2.86, 3.78, 4.15, 4.84, 5.14, 5.58];

% tính trung bình cộng Fo (Fo_mean)
fomean = 0;
j =0;
for i=1:numberFrames
    if Fo(i) ~= 0
       fomean = fomean + Fo(i);
       j = j + 1;
    end
end

% tính độ lệch chuẩn (Fo_std)
phuongsai = 0;
for i=1:numberFrames
    if Fo(i) ~= 0
        phuongsai = phuongsai + power(Fo(i) - fomean/j, 2);
    end
end

% trung bình cộng
fo_mean = fomean/j; 
% độ lệch chuẩn
fo_std = sqrt(phuongsai / (j-1));