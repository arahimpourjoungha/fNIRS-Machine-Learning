clc
clear all

%parameter=input('parameter=');

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

[m n c]=size(feature);

feature=reshape(feature,m,n*c);
feature(:,[10 7 9 1  39 33 36 26])=[];
feature=reshape(feature,m,n-4,c);

[m n c]=size(feature);

ratio=0.5;
ntrain=floor(n*ratio);
ntest=n-ntrain;

% %PCA
% data=reshape(feature,m,n*c);
% mue=sum(data')'/n;
% [V D]=eig(cov(data',1));
% D=D(6:m,6:m);
% V=V(:,6:m);
% for i=1:c
%     feature1(:,:,i)=D^(-0.5)*V'*(feature(:,:,i)-repmat(mue,1,n));
% end
% feature=feature1;
% %%%%%%%%%%%%%%%%%%%%%
error=zeros(n*c,1);
for iter=1:100

index=randperm(n);
X_train=feature(:,index(1:ntrain),:);
X_test=feature(:,index(ntrain+1:end),:);

data_train=[];
data_test=[];
for i=1:c
    data_train=[data_train;X_train(:,:,i)'];
    data_test=[data_test;X_test(:,:,i)'];
end

% if parameter==0
% %one against all
% class_test=[];
% for i=1:c
%     class_test=[class_test;i*ones(ntest,1)];
% end
% 
% for i=1:c-1
%     class=zeros(ntrain*c,1);
%     class((i-1)*ntrain+1:i*ntrain)=1;
%     tic;
%     svmstruct=svmtrain(data_train,class,'Kernel_Function','polynomial','Polyorder',5);
%     train_time(i)=toc;
%     tic;
%     group(:,i)=svmclassify(svmstruct,data_test);
%     test_time(i)=toc;
% end
% 
% confu=zeros(c,c);
% for i=1:ntest*c
%     num=find(group(i,:)~=0,1);
%     if isempty(num)==1
%         num=c;
%     end
%     confu(class_test(i),num)=confu(class_test(i),num)+1;
% end
% 
% confusion_matrix=confu/ntest
% CCR=sum(diag(confusion_matrix))/c
% 
% testing_time=sum(test_time)
% training_time=sum(train_time)
% 
% 
% 
% else
    
class_test=[];
for i=1:c
    class_test=[class_test;i*ones(ntest,1)];
end

cnt=0;
for i=1:c-1
    for j=i+1:c
        cnt=cnt+1;
        class=[i*ones(ntrain,1);j*ones(ntrain,1)];
        data=[data_train((i-1)*ntrain+1:i*ntrain,:);data_train((j-1)*ntrain+1:j*ntrain,:)];
        tic;
        svmstruct=svmtrain(data,class,'Kernel_Function','polynomial','Polyorder',3);
        %svmstruct=svmtrain(data,class,'Kernel_Function','rbf','RBF_Sigma',5);
        %svmstruct=svmtrain(data,class,'Kernel_Function','mlp','Mlp_Params',[0.02 -1]);
        train_time(cnt)=toc;
        tic;
        group(:,cnt)=svmclassify(svmstruct,data_test);
        test_time(cnt)=toc;
    end
end

indextemp=[index(ntrain+1:end) index(ntrain+1:end)+n];
confu=zeros(c,c);
for i=1:ntest*c
    for j=1:c
        dec(j)=sum(group(i,:)==j);
    end
    [dec1 num]=sort(dec,'descend');
    numtt(i)=num(1);
    
    if class_test(i)~=num(1)
     error(indextemp(i),1)=error(indextemp(i),1)+1;
    end
    confu(class_test(i),num(1))=confu(class_test(i),num(1))+1;
end

confusion_matrix=confu/ntest;
CCR=sum(diag(confusion_matrix))/c;

training_time=sum(train_time);
testing_time=sum(test_time);

conft(:,:,iter)=confusion_matrix;
CCRt(iter)=CCR;
indext(iter,:)=index;
clear dec
clear group
end
CCRmean=mean(CCRt)