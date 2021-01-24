clear;
clc;
%%  Initial Parameters:
Fs = 3.782;
Epoch_time = 20;
Epoch_ovl = 5;
Epoch_samp = round(Fs*Epoch_time);
Epoch_ovl_samp = round(Fs*Epoch_ovl);
Epoch_nonovl_samp = Epoch_samp - Epoch_ovl_samp;
Data_Windowed_H = zeros(Epoch_samp,4,1000);
Data_Windowed_U = zeros(Epoch_samp,4,1000);

load('Data_H.mat')
load('Data_U.mat')
%%
Hbo_far_H = [];
Hbo_near_H = [];
Hbr_far_H = [];
Hbr_near_H = [];
for i=1:length(Data_H)
    Data_temp = Data_H{i};
    Data_temp(isnan(Data_temp))=0;
    Data_temp(isinf(Data_temp))=0;
    Row_num = floor(size(Data_temp,1)/(Epoch_nonovl_samp));
    if(rem(size(Data_temp,1),(Epoch_nonovl_samp))<Epoch_ovl_samp)
        Row_num=Row_num-1;
    end
    for Ri = 1:Row_num
        Hbo_far_H = cat(2,Hbo_far_H,Data_temp(1:Epoch_samp,1));
        Hbo_near_H = cat(2,Hbo_near_H,Data_temp(1:Epoch_samp,2));
        Hbr_far_H = cat(2,Hbr_far_H,Data_temp(1:Epoch_samp,3));
        Hbr_near_H = cat(2,Hbr_near_H,Data_temp(1:Epoch_samp,4));
        Data_temp(1:Epoch_nonovl_samp,:)=[];
    end
end

Hbo_far_U = [];
Hbo_near_U = [];
Hbr_far_U = [];
Hbr_near_U = [];
for i=1:length(Data_U)
    Data_temp = Data_U{i};
    Data_temp(isnan(Data_temp))=0;
    Data_temp(isinf(Data_temp))=0;
    Row_num = floor(size(Data_temp,1)/(Epoch_nonovl_samp));
    if(rem(size(Data_temp,1),(Epoch_nonovl_samp))<Epoch_ovl_samp)
        Row_num=Row_num-1;
    end
    for Ri = 1:Row_num
        Hbo_far_U = cat(2,Hbo_far_U,Data_temp(1:Epoch_samp,1));
        Hbo_near_U = cat(2,Hbo_near_U,Data_temp(1:Epoch_samp,2));
        Hbr_far_U = cat(2,Hbr_far_U,Data_temp(1:Epoch_samp,3));
        Hbr_near_U = cat(2,Hbr_near_U,Data_temp(1:Epoch_samp,4));
        Data_temp(1:Epoch_nonovl_samp,:)=[];
    end
end
Thresh = 30;
[~,F] = mode(Hbo_far_H);
Hbo_far_H(:,F>Thresh)=[];
Hbo_near_H(:,F>Thresh)=[];
Hbr_far_H(:,F>Thresh)=[];
Hbr_near_H(:,F>Thresh)=[];

[~,F] = mode(Hbo_near_H);
Hbo_far_H(:,F>Thresh)=[];
Hbo_near_H(:,F>Thresh)=[];
Hbr_far_H(:,F>Thresh)=[];
Hbr_near_H(:,F>Thresh)=[];

[~,F] = mode(Hbr_far_H);
Hbo_far_H(:,F>Thresh)=[];
Hbo_near_H(:,F>Thresh)=[];
Hbr_far_H(:,F>Thresh)=[];
Hbr_near_H(:,F>Thresh)=[];

[~,F] = mode(Hbr_near_H);
Hbo_far_H(:,F>Thresh)=[];
Hbo_near_H(:,F>Thresh)=[];
Hbr_far_H(:,F>Thresh)=[];
Hbr_near_H(:,F>Thresh)=[];

[~,F] = mode(Hbo_far_U);
Hbo_far_U(:,F>Thresh)=[];
Hbo_near_U(:,F>Thresh)=[];
Hbr_far_U(:,F>Thresh)=[];
Hbr_near_U(:,F>Thresh)=[];

[~,F] = mode(Hbo_near_U);
Hbo_far_U(:,F>Thresh)=[];
Hbo_near_U(:,F>Thresh)=[];
Hbr_far_U(:,F>Thresh)=[];
Hbr_near_U(:,F>Thresh)=[];

[~,F] = mode(Hbr_far_U);
Hbo_far_U(:,F>Thresh)=[];
Hbo_near_U(:,F>Thresh)=[];
Hbr_far_U(:,F>Thresh)=[];
Hbr_near_U(:,F>Thresh)=[];

[~,F] = mode(Hbr_near_U);
Hbo_far_U(:,F>Thresh)=[];
Hbo_near_U(:,F>Thresh)=[];
Hbr_far_U(:,F>Thresh)=[];
Hbr_near_U(:,F>Thresh)=[];


save('DataReformed.mat','Hbo_far_H',...
                        'Hbo_near_H',...
                        'Hbr_far_H',...
                        'Hbr_near_H',...
                        'Hbo_far_U',...
                        'Hbo_near_U',...
                        'Hbr_far_U',...
                        'Hbr_near_U');