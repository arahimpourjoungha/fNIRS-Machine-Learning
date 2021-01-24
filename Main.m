%   Ch_near   |   Ch_far   |
%---------------------------
%  730 | 850  | 730 | 850  |
%%  --------------------
%   Intensities read
%%  --------------------
clc; close all; clear all;
%addpath C:\Users\Nima\Desktop\fNIRS_New_Data
%addpath H:\Tepid_Ice_Water(26.11.2014)\Nima_hemmati
%addpath C:\Users\User\Desktop\EMBC DATA\Sahar
Data_730a=importdata('Data_730a.txt');
Data_850a=importdata('Data_850a.txt');
Data_730b=importdata('Data_730b.txt');
Data_850b=importdata('Data_850b.txt');
%file_name = 'Output_file.xlsx';
%Intensity = xlsread(file_name);
Intensity(:,1) = Data_730b(1:529,1);
Intensity(:,2) = Data_850b(1:529,1);
Intensity(:,3) = Data_730b(1:529,2);
Intensity(:,4) = Data_850b(1:529,2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
I_near_730 = Intensity(:,1);
I_near_850 = Intensity(:,2);
I_far_730  = Intensity(:,3);
I_far_850  = Intensity(:,4);
%%  --------------------
e_Hbo_730 = 0.4383*log(10);    %mMol-1cm-1
e_Hbo_850 = 1.1596*log(10);
e_Hbr_730 = 1.3029*log(10);
e_Hbr_850 = 0.7861*log(10);
DPF_730   = 6.451;
DPF_850   = 5.946;
d1 = 1.5;    %cm
d2 = 3;
A = e_Hbr_850/DPF_730;
B = e_Hbr_730/DPF_850;
C = e_Hbo_730/DPF_850;
D = e_Hbo_850/DPF_730;
denom     =  (e_Hbr_850*e_Hbo_730-e_Hbr_730*e_Hbo_850);
Ib = mean(Intensity(1:110,:));  % mean of 30s baseline period
I_b_near_730 = Ib(:,1);
I_b_near_850 = Ib(:,2);
I_b_far_730  = Ib(:,3);
I_b_far_850  = Ib(:,4);
%%  --------------------
%   Near and Far channel Concentrations
%%  --------------------
delta_OD_near_730 = log(I_b_near_730./I_near_730(1:end));
delta_OD_near_850 = log(I_b_near_850./I_near_850(1:end));
delta_C_Hbo_near  = (A*delta_OD_near_730-B*delta_OD_near_850)/(d1*denom);
delta_C_Hbr_near  = (C*delta_OD_near_850-D*delta_OD_near_730)/(d1*denom);
delta_C_tHb_near  = delta_C_Hbo_near+delta_C_Hbr_near;
% -----
delta_OD_far_730 = log(I_b_far_730./I_far_730(1:end));
delta_OD_far_850 = log(I_b_far_850./I_far_850(1:end));
delta_C_Hbo_far  = (A*delta_OD_far_730-B*delta_OD_far_850)/(d2*denom);
delta_C_Hbr_far  = (C*delta_OD_far_850-D*delta_OD_far_730)/(d2*denom);
delta_C_tHb_far  = delta_C_Hbo_far+delta_C_Hbr_far;
%%  --------------------
data_span = 672+1;   % data span = 120sec
S_delta_C_Hbo_near = smooth(delta_C_Hbo_near,data_span);
S_delta_C_Hbr_near = smooth(delta_C_Hbr_near,data_span);
S_delta_C_Hbo_far  = smooth(delta_C_Hbo_far,data_span);
S_delta_C_Hbr_far  = smooth(delta_C_Hbr_far,data_span);
Detrend_delta_C_Hbo_near = delta_C_Hbo_near-S_delta_C_Hbo_near;
Detrend_delta_C_Hbr_near = delta_C_Hbr_near-S_delta_C_Hbr_near;
Detrend_delta_C_Hbo_far  = delta_C_Hbo_far-S_delta_C_Hbo_far;
Detrend_delta_C_Hbr_far  = delta_C_Hbr_far-S_delta_C_Hbr_far;
%%  --------------------
% Low-pass filter
[D,C] = cheby2(3,40,0.030,'low');
[SOS,G] = tf2sos(D,C);
filtered_delta_C_Hbo_near = sosfilt(SOS,Detrend_delta_C_Hbo_near);
filtered_delta_C_Hbo_near = G*filtered_delta_C_Hbo_near;
filtered_delta_C_Hbr_near = sosfilt(SOS,Detrend_delta_C_Hbr_near);
filtered_delta_C_Hbr_near = G*filtered_delta_C_Hbr_near;
filtered_delta_C_Hbo_far  = sosfilt(SOS,Detrend_delta_C_Hbo_far);
filtered_delta_C_Hbo_far  = G*filtered_delta_C_Hbo_far;
filtered_delta_C_Hbr_far  = sosfilt(SOS,Detrend_delta_C_Hbr_far);
filtered_delta_C_Hbr_far  = G*filtered_delta_C_Hbr_far;
%%%
delta_C_Hbo_near = 1000*delta_C_Hbo_near(332:482,:);
delta_C_Hbr_near = 1000*delta_C_Hbr_near(332:482,:);
delta_C_Hbo_far = 1000*delta_C_Hbo_far(332:482,:);
delta_C_Hbr_far = 1000*delta_C_Hbr_far(332:482,:);
delta_C_tHb_nea = 500*(delta_C_tHb_near(332:482,:));
delta_C_tHb_far = 500*(delta_C_tHb_far(332:482,:));
%%  --------------------
figure(1);
subplot(211);plot(0:1/3.7382:(size(delta_C_Hbo_near)-1)/3.7382,1000*delta_C_Hbo_near,'r','linewidth',2)
hold on;plot(0:1/3.7382:(size(delta_C_Hbr_near)-1)/3.7382,1000*delta_C_Hbr_near,'b','linewidth',2)
plot(0:1/3.7382:(size(S_delta_C_Hbo_near)-1)/3.7382,1000*S_delta_C_Hbo_near,'--g','linewidth',2)
plot(0:1/3.7382:(size(S_delta_C_Hbr_near)-1)/3.7382,1000*S_delta_C_Hbr_near,'--g','linewidth',2)
legend('HbO_2','HbR');xlabel('time','fontsize',12,'fontweight','b');ylabel('C (microM)','fontsize',12,'fontweight','b');title('Near Channel (d=1.5cm)','fontsize',12,'fontweight','b');
subplot(212);plot(0:1/3.7382:(size(delta_C_Hbo_far)-1)/3.7382,1000*delta_C_Hbo_far,'r','linewidth',2)
hold on;plot(0:1/3.7382:(size(delta_C_Hbr_far)-1)/3.7382,1000*delta_C_Hbr_far,'b','linewidth',2)
plot(0:1/3.7382:(size(S_delta_C_Hbo_far)-1)/3.7382,1000*S_delta_C_Hbo_far,'--g','linewidth',2)
plot(0:1/3.7382:(size(S_delta_C_Hbr_far)-1)/3.7382,1000*S_delta_C_Hbr_far,'--g','linewidth',2)
legend('HbO_2','HbR');xlabel('time','fontsize',12,'fontweight','b');ylabel('C (microM)','fontsize',12,'fontweight','b');title('far Channel (d=3cm)','fontsize',12,'fontweight','b');
figure(2);
subplot(211);
%plot(0:1/3.7382:(size(Detrend_delta_C_Hbo_near)-1)/3.7382,1000*Detrend_delta_C_Hbo_near,'m','linewidth',1)
hold on;
%plot(0:1/3.7382:(size(Detrend_delta_C_Hbr_near)-1)/3.7382,1000*Detrend_delta_C_Hbr_near,'c','linewidth',1)
plot(0:1/3.7382:(size(filtered_delta_C_Hbo_near)-1)/3.7382,1000*filtered_delta_C_Hbo_near,'r','linewidth',2)
plot(0:1/3.7382:(size(filtered_delta_C_Hbr_near)-1)/3.7382,1000*filtered_delta_C_Hbr_near,'b','linewidth',2)
legend('HbO_2','HbR');xlabel('time','fontsize',10);ylabel('Concentration (microM)','fontsize',10,'fontweight','b');title('Near Channel (d=1.5cm)','fontsize',10);
subplot(212);
%plot(0:1/3.7382:(size(Detrend_delta_C_Hbo_far)-1)/3.7382,1000*Detrend_delta_C_Hbo_far,'m','linewidth',1)
hold on;
%plot(0:1/3.7382:(size(Detrend_delta_C_Hbr_far)-1)/3.7382,1000*Detrend_delta_C_Hbr_far,'c','linewidth',1)
plot(0:1/3.7382:(size(filtered_delta_C_Hbo_far)-1)/3.7382,1000*(filtered_delta_C_Hbo_far),'r','linewidth',2)
plot(0:1/3.7382:(size(filtered_delta_C_Hbr_far)-1)/3.7382,1000*filtered_delta_C_Hbr_far,'b','linewidth',2)
legend('HbO_2','HbR');xlabel('time','fontsize',10);ylabel('Concentration (microM)','fontsize',10,'fontweight','b');title('far Channel (d=3cm)','fontsize',10);


% for kk=1
%     subplot(2,1,kk)
%         line([120 120], [-10 10],'color',[0 1 1],'linewidth',2);
%     line([240 240], [-10 10],'color',[0 1 1],'linewidth',2);
%             line([360 360], [-10 10],'color',[0 1 1],'linewidth',2);
%     line([480 480], [-10 10],'color',[0 1 1],'linewidth',2);
%             line([600 600], [-10 10],'color',[0 1 1],'linewidth',2);
%     line([720 720], [-10 10],'color',[0 1 1],'linewidth',2);
%             line([840 840], [-10 10],'color',[0 1 1],'linewidth',2);
%     line([960 960], [-10 10],'color',[0 1 1],'linewidth',2);
%             line([1080 1080], [-10 10],'color',[0 1 1],'linewidth',2);
%     line([1200 1200], [-10 10],'color',[0 1 1],'linewidth',2);
%             line([1320 1320], [-10 10],'color',[0 1 1],'linewidth',2);
%     axis([0 1400 -6 6])
% end
% for kk=2
%     subplot(2,1,kk)
%         line([120 120], [-10 10],'color',[0 1 1],'linewidth',2);
%     line([240 240], [-10 10],'color',[0 1 1],'linewidth',2);
%             line([360 360], [-10 10],'color',[0 1 1],'linewidth',2);
%     line([480 480], [-10 10],'color',[0 1 1],'linewidth',2);
%             line([600 600], [-10 10],'color',[0 1 1],'linewidth',2);
%     line([720 720], [-10 10],'color',[0 1 1],'linewidth',2);
%             line([840 840], [-10 10],'color',[0 1 1],'linewidth',2);
%     line([960 960], [-10 10],'color',[0 1 1],'linewidth',2);
%             line([1080 1080], [-10 10],'color',[0 1 1],'linewidth',2);
%     line([1200 1200], [-10 10],'color',[0 1 1],'linewidth',2);
%             line([1320 1320], [-10 10],'color',[0 1 1],'linewidth',2);
%     axis([0 1400 -2 2])
% end
Hbo_near = 1000*delta_C_Hbo_near(332:482,:);
Hbr_near = 1000*delta_C_Hbr_near(332:482,:);
Hbo_far = 1000*delta_C_Hbo_far(332:482,:);
Hbr_far = 1000*delta_C_Hbr_far(332:482,:);
Total_near = 500*(delta_C_tHb_near(332:482,:));
Total_far = 500*(delta_C_tHb_far(332:482,:));

figure;hist(Hbo_near,50)
figure;hist(Hbo_far,50)
figure;hist(Hbr_near,50)
figure;hist(Hbr_far,50)
figure;hist(Total_near,50)
figure;hist(Total_far,50)
%%
    for i=1:31
    smooth_Hbo_near(i,1)=mean(Hbo_near(i:119+i),1)
    end
    
    smooth_Hbo_near=smooth_Hbo_near(:,1);
    figure;hist(smooth_Hbo_near,50)
    
    %%
    for i=1:31
    smooth_Hbo_far(i,1)=mean(Hbo_far(i:119+i),1)
    end
    smooth_Hbo_far=smooth_Hbo_far(:,1);
    figure;hist(smooth_Hbo_far,50)
    %%
   for i=1:31
    smooth_Hbr_near(i,1)=mean(Hbr_near(i:119+i),1)
    end
    
    smooth_Hbr_near=smooth_Hbr_near(:,1);
    figure;hist(smooth_Hbr_near,50)
    %%
   for i=1:31
    smooth_Hbr_far(i,1)=mean(Hbr_far(i:119+i),1)
    end
    
    smooth_Hbr_far=smooth_Hbr_far(:,1);
    figure;hist(smooth_Hbr_far,50)
    %%
  for i=1:31
    smooth_Total_near(i,1)=mean(Total_near(i:119+i),1)
    end
    
    smooth_Total_near=smooth_Total_near(:,1);
    figure;hist(smooth_Total_near,50)
    %%
  for i=1:31
    smooth_Total_far(i,1)=mean(Total_far(i:119+i),1)
    end
    
    smooth_Total_far=smooth_Total_far(:,1);
    figure;hist(smooth_Total_far,50)