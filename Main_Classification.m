clear;
clc;
close all;

% First: Catenation.m  Second: DataReform.m   Thrid: FeatureExNIRS.m Last:
% Main_Classification.m
%% Initialize
Cnum = 2; % 2->Unhealthy 1->Healthy
load('Features.mat')
Find = 1:116;%[1:4:48,2:4:48,49:82];
TestD_H = Feat_H(Find,1:round(size(Feat_H,2)/3));
Feat_H(:,1:round(size(Feat_H,2)/3)) = [];
Label_H = ones(1,size(TestD_H,2),1);

TestD_U = Feat_U(Find,1:round(size(Feat_U,2)/3));
Feat_U(:,1:round(size(Feat_U,2)/3)) = [];
Label_U = zeros(1,size(TestD_U,2),1)+2;
TestData = ([TestD_U,TestD_H])';
TestLabel = ([Label_U,Label_H])';

TrainD_H = Feat_H(Find,:);
Label_H = ones(1,size(TrainD_H,2),1);
TrainD_U = Feat_U(Find,:);
Label_U = zeros(1,size(TrainD_U,2),1)+2;
TrainData = ([TrainD_U,TrainD_H])';
TrainLabel = ([Label_U,Label_H])';
%% Train
Classifier.Linear = svmtrain(TrainData,TrainLabel,'kernel_function','linear','method','SMO');
Classifier.RBF = svmtrain(TrainData,TrainLabel,'kernel_function','rbf','rbf_sigma',8.5,'method','SMO');%,'showplot','true');
Classifier.MLP = svmtrain(TrainData,TrainLabel,'kernel_function','mlp');
Classifier.POL = svmtrain(TrainData,TrainLabel,'kernel_function','polynomial','polyorder',5);
%% Test

DECMSVM=zeros(Cnum,Cnum);
DECMRBF=zeros(Cnum,Cnum);
DECMMLP=zeros(Cnum,Cnum);
DECMPOL=zeros(Cnum,Cnum);
AccSVM=0;
AccRBF=0;
AccMLP=0;
AccPOL=0;
for i=1:length(TestLabel)    
    [DecSVM,DecRBF,DecMLP,DecPOL] = NIR_Classify(Classifier,TestData(i,:));
    DECMSVM(TestLabel(i),DecSVM)=DECMSVM(TestLabel(i),DecSVM)+1;
    DECMRBF(TestLabel(i),DecRBF)=DECMRBF(TestLabel(i),DecRBF)+1;
    DECMMLP(TestLabel(i),DecMLP)=DECMMLP(TestLabel(i),DecMLP)+1;
    DECMPOL(TestLabel(i),DecPOL)=DECMPOL(TestLabel(i),DecPOL)+1;
    if(DecSVM==TestLabel(i))
        AccSVM = AccSVM+1;
    end
    if(DecRBF==TestLabel(i))
        AccRBF = AccRBF+1;
    end
    if(DecMLP==TestLabel(i))
        AccMLP = AccMLP+1;
    end
    if(DecPOL==TestLabel(i))
        AccPOL = AccPOL+1;
    end    
end
CCRSVM = AccSVM/length(TestLabel);
disp('CCR for training Datas for Linear SVM:');
disp(CCRSVM);
CCRRBF = AccRBF/length(TestLabel);
disp('CCR for training Datas for RBF SVM:');
disp(CCRRBF);
CCRMLP = AccMLP/length(TestLabel);
disp('CCR for training Datas for MLP SVM:');
disp(CCRMLP);
CCRPOL = AccPOL/length(TestLabel);
disp('CCR for training Datas for Polynomial SVM:');
disp(CCRPOL);