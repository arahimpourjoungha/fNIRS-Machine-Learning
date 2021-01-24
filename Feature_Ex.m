function feature4 = Feature_Ex(delta_C_Hbo_far,...
                               delta_C_Hbo_near,...
                               delta_C_Hbr_far,...
                               delta_C_Hbr_near)
% data_span = 76;
% S_delta_C_Hbo_near = smooth(delta_C_Hbo_near,data_span);
% S_delta_C_Hbr_near = smooth(delta_C_Hbr_near,data_span);
% S_delta_C_Hbo_far  = smooth(delta_C_Hbo_far,data_span);
% S_delta_C_Hbr_far  = smooth(delta_C_Hbr_far,data_span);
% Detrend_delta_C_Hbo_near = delta_C_Hbo_near-S_delta_C_Hbo_near;
% Detrend_delta_C_Hbr_near = delta_C_Hbr_near-S_delta_C_Hbr_near;
% Detrend_delta_C_Hbo_far  = delta_C_Hbo_far-S_delta_C_Hbo_far;
% Detrend_delta_C_Hbr_far  = delta_C_Hbr_far-S_delta_C_Hbr_far;

Detrend_delta_C_Hbo_near = delta_C_Hbo_near;
Detrend_delta_C_Hbr_near = delta_C_Hbr_near;
Detrend_delta_C_Hbo_far  = delta_C_Hbo_far;
Detrend_delta_C_Hbr_far  = delta_C_Hbr_far;
%%  --------------------
%   Low-pass filter 
%%  -------------------
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
%%  --------------------
%%  ---------Plot-----------
%%%%%%%%%%%%%%%%%%%%%%Temporal Features%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FeatureOfActivity=zeros(4,1);
FeatureOfMobility=zeros(4,1);
FeatureOfComplexity=zeros(4,1);
FeatureOfSkewness=zeros(4,1);
FeatureOfKurtosis=zeros(4,1);
FeatureOfPositivearea=zeros(4,1);
FeatureOfNegativearea=zeros(4,1);
FeatureOfTotalarea=zeros(4,1);
FeatureOfAbsolutetotalarea=zeros(4,1);
FeatureOfTotalabsolutearea=zeros(4,1);
FeatureOfAverageabsolutesignalslope=zeros(4,1);
FeatureOfNumberofzeros=zeros(4,1);
[a,b]=size(filtered_delta_C_Hbo_near);
[c,d]=size(filtered_delta_C_Hbr_near);
[e,f]=size(filtered_delta_C_Hbo_far);
[g,h]=size(filtered_delta_C_Hbr_far);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xx1=filtered_delta_C_Hbo_near;
xx2=filtered_delta_C_Hbr_near;
xx3=filtered_delta_C_Hbo_far;
xx4=filtered_delta_C_Hbr_far;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% feature extraction#1 for each data
% S=xx1;
% Lvl = 10;
% Wavename = 'db5';
% [C,L] = wavedec(S,Lvl,Wavename);
% % Extract approximation and detail coefficients
% cA = appcoef(C,L,Wavename,Lvl);
% % Reconstruct the Level 3 approximation
% A = wrcoef('a',C,L,Wavename,Lvl);
% figure
% subplot 311
% plot(S)
% hold on;
% plot(A,'r')
% subplot 312
% plot(cA,'k')
% subplot 313
% plot(S-A)

Lvl = 3;
Wavename = 'db5';
[C,L] = wavedec(xx1,Lvl,Wavename);
cAxx1 = appcoef(C,L,Wavename,Lvl);

[C,L] = wavedec(xx2,Lvl,Wavename);
cAxx2 = appcoef(C,L,Wavename,Lvl);

[C,L] = wavedec(xx3,Lvl,Wavename);
cAxx3 = appcoef(C,L,Wavename,Lvl);

[C,L] = wavedec(xx4,Lvl,Wavename);
cAxx4 = appcoef(C,L,Wavename,Lvl);


FeatureOfActivity(1,1)=var(xx1);
 
FeatureOfActivity(2,1)=var(xx2);
   
FeatureOfActivity(3,1)=var(xx3);
   
FeatureOfActivity(4,1)=var(xx4);

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% feature extraction#2 for each data

    FeatureOfMobility(1,1)=sqrt(var(diff(xx1)./(FeatureOfActivity(1,1)))); 

    FeatureOfMobility(2,1)=sqrt(var(diff(xx2)./(FeatureOfActivity(2,1)))); 
   
    FeatureOfMobility(3,1)=sqrt(var(diff(xx3)./(FeatureOfActivity(3,1)))); 
   
    FeatureOfMobility(4,1)=sqrt(var(diff(xx4)./(FeatureOfActivity(4,1)))); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% feature extraction#3 for each data
    FeatureOfComplexity(1,1)=sqrt(var(diff(xx1,2))*FeatureOfActivity(1,1)/var(diff(xx1))); 

    FeatureOfComplexity(2,1)=sqrt(var(diff(xx2,2))*FeatureOfActivity(2,1)/var(diff(xx2))); 
   

    FeatureOfComplexity(3,1)=sqrt(var(diff(xx3,2))*FeatureOfActivity(3,1)/var(diff(xx3))); 
   

    FeatureOfComplexity(4,1)=sqrt(var(diff(xx4,2))*FeatureOfActivity(4,1)/var(diff(xx4))); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% feature extraction#4 for each data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
 FeatureOfSkewness(1,1)=skewness(xx1);

 FeatureOfSkewness(2,1)=skewness(xx2);
   
 FeatureOfSkewness(3,1)=skewness(xx3);
   
 FeatureOfSkewness(4,1)=skewness(xx4);
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%           
% feature extraction#5 for each data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
 FeatureOfKurtosis(1,1)=kurtosis(xx1);

 FeatureOfKurtosis(2,1)=kurtosis(xx2);
   
 FeatureOfKurtosis(3,1)=kurtosis(xx3);
   
 FeatureOfKurtosis(4,1)=kurtosis(xx4);
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%           
% feature extraction#6 for each data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 FeatureOfPositivearea(1,1)=(0.5).*(sum((xx1)+abs(xx1)));

 FeatureOfPositivearea(2,1)=(0.5).*(sum((xx2)+abs(xx2)));
   
 FeatureOfPositivearea(3,1)=(0.5).*(sum((xx3)+abs(xx3)));
   
 FeatureOfPositivearea(4,1)=(0.5).*(sum((xx4)+abs(xx4)));
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
% feature extraction#7 for each data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 FeatureOfNegativearea(1,1)=(0.5).*(sum((xx1)-abs(xx1)));

 FeatureOfNegativearea(2,1)=(0.5).*(sum((xx2)-abs(xx2)));
   

 FeatureOfNegativearea(3,1)=(0.5).*(sum((xx3)-abs(xx3)));   

 FeatureOfNegativearea(4,1)=(0.5).*(sum((xx4)-abs(xx4)));

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
% feature extraction#8 for each data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 FeatureOfTotalarea(1,1)=FeatureOfPositivearea(1,1)+FeatureOfNegativearea(1,1); 

 FeatureOfTotalarea(2,1)=FeatureOfPositivearea(2,1)+FeatureOfNegativearea(2,1);
   
 FeatureOfTotalarea(3,1)=FeatureOfPositivearea(3,1)+FeatureOfNegativearea(3,1);   

 FeatureOfTotalarea(4,1)=FeatureOfPositivearea(4,1)+FeatureOfNegativearea(4,1);

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
% feature extraction#9 for each data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 FeatureOfAbsolutetotalarea(1,1)=abs(FeatureOfTotalarea(1,1)); 

 FeatureOfAbsolutetotalarea(2,1)=abs(FeatureOfTotalarea(2,1));
   
 FeatureOfAbsolutetotalarea(3,1)=abs(FeatureOfTotalarea(3,1));   

 FeatureOfAbsolutetotalarea(4,1)=abs(FeatureOfTotalarea(4,1));

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
% feature extraction#10 for each data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 FeatureOfTotalabsolutearea(1,1)=FeatureOfPositivearea(1,1)+abs(FeatureOfNegativearea(1,1)); 

 FeatureOfTotalabsolutearea(2,1)=FeatureOfPositivearea(2,1)+abs(FeatureOfNegativearea(2,1)); 
   
 FeatureOfTotalabsolutearea(3,1)=FeatureOfPositivearea(3,1)+abs(FeatureOfNegativearea(3,1)); 

 FeatureOfTotalabsolutearea(4,1)=FeatureOfPositivearea(4,1)+abs(FeatureOfNegativearea(4,1)); 

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
% feature extraction#11 for each data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 FeatureOfAverageabsolutesignalslope(1,1)=(1./(floor((a)/11))).*(sum(diff(xx1))); 

 FeatureOfAverageabsolutesignalslope(2,1)=(1./(floor((c)/11))).*(sum(diff(xx2))); 
   
 FeatureOfAverageabsolutesignalslope(3,1)=(1./(floor((e)/11))).*(sum(diff(xx3)));  

 FeatureOfAverageabsolutesignalslope(4,1)=(1./(floor((g)/11))).*(sum(diff(xx4)));

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% feature extraction#12 for each data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%number of zeros 
m=zeros(1,(floor((a)/11)-1));
n=zeros(1,(floor((c)/11)-1));
q=zeros(1,(floor((e)/11)-1));
z=zeros(1,(floor((g)/11)-1));

for jj=1:(floor((a)/11)-1)
   if      xx1(jj)*xx1(jj+1)<0
       m=[m,1];
       
   end
   if      xx2(jj)*xx2(jj+1)<0
       n=[n,1];
             
   end
   if      xx3(jj)*xx3(jj+1)<0
       
       q=[q,1];
      
   end
   if      xx4(jj)*xx4(jj+1)<0
       
       z=[z,1];
      
   end
   
   
end
FeatureOfNumberofzeros(1,1)=sum(m);
FeatureOfNumberofzeros(2,1)=sum(n);
FeatureOfNumberofzeros(3,1)=sum(q);
FeatureOfNumberofzeros(4,1)=sum(z);



feature4=[FeatureOfActivity(:,1);FeatureOfMobility(:,1);FeatureOfComplexity(:,1);FeatureOfSkewness(:,1);FeatureOfKurtosis(:,1);FeatureOfPositivearea(:,1);
FeatureOfNegativearea(:,1);FeatureOfTotalarea(:,1);FeatureOfAbsolutetotalarea(:,1);FeatureOfTotalabsolutearea(:,1);FeatureOfAverageabsolutesignalslope(:,1),
FeatureOfNumberofzeros(:,1);cAxx1;cAxx2;cAxx3;cAxx4];
end