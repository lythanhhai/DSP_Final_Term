%Phone_F1 = [0.53, 1.14, 1.21, 1.35, 1.45, 1.60, 1.83, 2.20, 2.28, 2.35, 2.40, 2.52, 2.66, 2.73];
%Fo_studio_fe = V_UV('./fileTinHieuMoi/studio_F1.wav', 'studio female1', Studio_F1);
%Fo_studio_ma = V_UV('./fileTinHieuMoi/studio_M1.wav', 'studio male');
%Fo_phone_fe = V_UV('./fileTinHieuMoi/phone_F1.wav', 'phone female', Phone_F1);
%Fo_phone_ma = V_UV('./fileTinHieuMoi/phone_M1.wav', 'phone male');


MDA01 = [0.45, 0.81, 1.53, 1.85, 2.69, 2.86, 3.78, 4.15, 4.84, 5.14];


MDA = V_UV('./tinHieuHuanLuyen/01MDA.wav', 'studio female', MDA01);

Fo_studio_fe1 = V_UV('./tinHieuHuanLuyen/01MDA.wav', 'studio female', MDA01);

%Fo_studio_fe1 = V_UV('./tinHieuHuanLuyen/01MDA.wav', 'studio female');


%Fo_studio_ma = V_UV('./tinHieuHuanLuyen/02FVA.wav', 'studio male');
%Fo_phone_fe = V_UV('./tinHieuHuanLuyen/03MAB.wav', 'phone female');
%Fo_phone_ma = V_UV('./tinHieuHuanLuyen/06FTB.wav', 'phone male');