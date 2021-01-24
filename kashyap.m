function w=kashyap(x1,x2,eta,error,iteration)

%Implementing the Ho-Kashyap Linear Classifier
x=[ones(size(x1,1),1) x1;-ones(size(x2,1),1) -x2];
b=ones(size(x,1),1);
w=pinv(x'*x)*x'*b;
for i=1:iteration
    er=x*w-b;
    er1=(er+abs(er))/2;
    b=b+2*eta*er1;
    w=inv(x'*x)*x'*b;
    if max(abs(er))<=error
        break
    end
end