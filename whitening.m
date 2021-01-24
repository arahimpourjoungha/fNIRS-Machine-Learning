function [X_train1 X_test1 index]=whitening() 

load ficher1
load ficher2
load ficher3
load ficher4

featuret=zeros(12,10,5);
featuret(:,1:10,:)=feature3;
% featuret(:,11:20,:)=feature2;
% featuret(:,21:30,:)=feature3;
% featuret(:,31:40,:)=feature4;
feature=zeros(12,20,2);
feature(:,:,1)=[featuret(:,:,1),featuret(:,:,2)];
feature(:,:,2)=[featuret(:,:,4),featuret(:,:,5)];

feature=feature([7 8],:,:);


[m ndata c]=size(feature);

feature=reshape(feature,m,ndata*c);
feature(:,[10 7 9 1  39 33 36 26])=[];
feature=reshape(feature,m,ndata-4,c);

[m ndata c]=size(feature);

ratio=0.5;
ntrain=floor(ndata*ratio);
ntest=ndata-ntrain;
index=randperm(ndata);
X_train1=feature(:,index(1:ntrain),:);
X_test1=feature(:,index(ntrain+1:end),:);
