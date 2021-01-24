%Classifier with L(L-1)/2 Hyper Planes
clc
clear all

for iter=1:100
    
[X_train X_test index]=whitening();
[m nt c]=size(X_test);
[m n c]=size(X_train);
eta=1.5;
iteration=100;
error=1e-3;

counter=1;
for i=1:c-1
    for j=i+1:c
        w(:,counter)=kashyap(X_train(:,:,i)',X_train(:,:,j)',eta,error,iteration);
        num(:,counter)=[i;j];
        counter=counter+1;
    end
end

% confu_X=zeros(c,c);
% for i=1:c
%     for j=1:n
%         d=[1 X_train(:,j,i)']*w;
%         class=[num(1,find(d>=0)) num(2,find(d<0))];
%         class1=zeros(c,1);
%         for i1=1:c
%             class1(i1)=sum(class==i1);
%         end
%         [class2 num1]=sort(class1);
%         confu_X(i,num1(c))=confu_X(i,num1(c))+1;
%     end
% end
% confusion_matrix=confu_X/n
% CCR=sum(diag(confusion_matrix))/c

confu_X=zeros(c,c);
for i=1:c
    for j=1:nt
        d=[1 X_test(:,j,i)']*w;
        class=[num(1,find(d>=0)) num(2,find(d<0))];
        class1=zeros(c,1);
        for i1=1:c
            class1(i1)=sum(class==i1);
        end
        [class2 num1]=sort(class1);
        confu_X(i,num1(c))=confu_X(i,num1(c))+1;
    end
end
confusion_matrix=confu_X/nt;
CCR=sum(diag(confusion_matrix))/c;

conft(:,:,iter)=confusion_matrix;
CCRt(iter)=CCR;
indext(iter,:)=index;

end
CCRmean=mean(CCRt)