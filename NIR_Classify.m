function [ClassLinear,ClassRBF,ClassMLP,ClassPOL] = NIR_Classify(Classifier,X)



ClassLinear = svmclassify(Classifier.Linear,X);
ClassRBF = svmclassify(Classifier.RBF,X);
ClassMLP = svmclassify(Classifier.MLP,X);
ClassPOL = svmclassify(Classifier.POL,X);

end

