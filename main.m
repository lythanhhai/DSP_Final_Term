% số điểm fft
pointFFT = 4096;
rangeFreq_male = 1000;
rangeFreq_female = 2000;

% tín hiệu kiểm thử
%FTN30 = [0.59, 0.97, 1.76, 2.11, 3.44, 3.77, 4.70, 5.13, 5.96, 6.28];
FQT42 = [0.46, 0.99, 1.56, 2.13, 2.51, 2.93, 3.79, 4.38, 4.77, 5.22];
%MTT44 = [0.93, 1.42, 2.59, 3.00, 4.71, 5.11, 6.26, 6.66, 8.04, 8.39];
%MDV45 = [0.88, 1.34, 2.35, 2.82, 3.76, 4.13, 5.04, 5.50, 6.41, 6.79];


FTN = V_UV('./fileTinHieuKiemThu/30FTN.wav', '30FTN', FTN30, pointFFT, rangeFreq_female);
FQT = V_UV('./fileTinHieuKiemThu/42FQT.wav', '42FQT', FQT42, pointFFT, rangeFreq_female);
MTT = V_UV('./fileTinHieuKiemThu/44MTT.wav', '44MTT', MTT44, pointFFT, rangeFreq_male);
MDV = V_UV('./fileTinHieuKiemThu/45MDV.wav', '45MDV', MDV45, pointFFT, rangeFreq_male);


% tính hiệu huấn luyện

MDA01 = [0.45, 0.81, 1.53, 1.85, 2.69, 2.86, 3.78, 4.15, 4.84, 5.14];
FVA02 = [0.83, 1.37, 2.09, 2.60, 3.57, 4.00, 4.76, 5.33, 6.18, 6.68];
MAB03 = [1.03, 1.42, 2.46, 2.80, 4.21, 4.52, 6.81, 7.14, 8.22, 8.50];
FTB06 = [1.52, 1.92, 3.91, 4.35, 6.18, 6.60, 8.67, 9.14, 10.94, 11.33];

%{
MDA = V_UV('./tinHieuHuanLuyen/01MDA.wav', '01MDA', MDA01, pointFFT, rangeFreq_male);
FVA = V_UV('./tinHieuHuanLuyen/02FVA.wav', '02FVA', FVA02, pointFFT, rangeFreq_female);
MAB = V_UV('./tinHieuHuanLuyen/03MAB.wav', '03MAB', MAB03, pointFFT, rangeFreq_male);
FTB = V_UV('./tinHieuHuanLuyen/06FTB.wav', '06FTB', FTB06, pointFFT, rangeFreq_female);
%}
