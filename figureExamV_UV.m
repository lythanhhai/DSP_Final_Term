FTN30 = [0.59, 0.97, 1.76, 2.11, 3.44, 3.77, 4.70, 5.13, 5.96, 6.28];
FQT42 = [0.46, 0.99, 1.56, 2.13, 2.51, 2.93, 3.79, 4.38, 4.77, 5.22];
MTT44 = [0.93, 1.42, 2.59, 3.00, 4.71, 5.11, 6.26, 6.66, 8.04, 8.39];
MDV45 = [0.88, 1.34, 2.35, 2.82, 3.76, 4.13, 5.04, 5.50, 6.41, 6.79];

% số điểm fft
pointFFT = 4096;
rangeFreq_male = 1000;
rangeFreq_female = 2000;
FTN = V_UV('./tinHieuHuanLuyen/30FTN.wav', '30FTN', FTN30, pointFFT, rangeFreq_female);
FQT = V_UV('./tinHieuHuanLuyen/42FQT.wav', '42FQT', FQT42, pointFFT, rangeFreq_female);
MTT = V_UV('./tinHieuHuanLuyen/44MTT.wav', '44MTT', MTT44, pointFFT, rangeFreq_male);
MDV = V_UV('./tinHieuHuanLuyen/45MDV.wav', '45MDV', MDV45, pointFFT, rangeFreq_male);


