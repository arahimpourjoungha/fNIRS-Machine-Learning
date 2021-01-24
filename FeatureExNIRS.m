clear;
clc;
%%  Initial Parameters:
Fnum = 116;
Fs = 3.782;
Epoch_time = 20;
Epoch_ovl = 5;
Epoch_samp = round(Fs*Epoch_time);
load('DataReformed.mat')
%%  --------------------
%   Smoothing and detrending
%%  --------------------
Feat_H = zeros(Fnum,size(Hbo_far_H,2));
for i=1:size(Hbo_far_H,2)
    delta_C_Hbo_near = Hbo_near_H(:,i);
    delta_C_Hbr_near = Hbr_near_H(:,i);
    delta_C_Hbo_far = Hbo_far_H(:,i);
    delta_C_Hbr_far = Hbr_far_H(:,i);

    Feat_H(:,i) = Feature_Ex(delta_C_Hbo_far,...
                             delta_C_Hbo_near,...
                             delta_C_Hbr_far,...
                             delta_C_Hbr_near);
end

Feat_U = zeros(Fnum,size(Hbo_far_U,2));
for i=1:size(Hbo_far_U,2)
    delta_C_Hbo_near = Hbo_near_U(:,i);
    delta_C_Hbr_near = Hbr_near_U(:,i);
    delta_C_Hbo_far = Hbo_far_U(:,i);
    delta_C_Hbr_far = Hbr_far_U(:,i);

    Feat_U(:,i) = Feature_Ex(delta_C_Hbo_far,...
                             delta_C_Hbo_near,...
                             delta_C_Hbr_far,...
                             delta_C_Hbr_near);
end

ind = randperm(size(Feat_H,2));
Feat_H = Feat_H(:,ind);
ind = randperm(size(Feat_U,2));
Feat_U = Feat_U(:,ind);
for i=1:size(Feat_H,1)
    Feat_H(i,:) = (Feat_H(i,:) - min(Feat_H(i,:)))/(max(Feat_H(i,:)) - min(Feat_H(i,:)));
    Feat_U(i,:) = (Feat_U(i,:) - min(Feat_U(i,:)))/(max(Feat_U(i,:)) - min(Feat_U(i,:)));
end
save('Features.mat','Feat_H','Feat_U')