__author__ = 'nsrivas3'

from sklearn.naive_bayes import GaussianNB
from sklearn import svm

# 1. Develop a RBF classifier
# 2. Develop a classifier based on Naive Bayes

def ModelChoose(choice,response_var,predictors):
    if choice==1:
        Prediction = RBFClass(response_var,predictors)
    elif choice:
        Prediction = NaiveBayesClass(response_var,predictors)
    return(Prediction)


def NaiveBayesClass(response_var,predictors):
    # 1. response_var - Name or index of the response variable in the dataset
    # 2. List of predictor variables by name or as indexes
    gnb = GaussianNB()
    Fit = gnb.fit(predictors,response_var)
    Prediction = Fit.predict(predictors)
    return(Prediction)

def RBFClass(response_var,predictors):
    # 1. response_var - Name or index of the response variable in the dataset
    # 2. List of predictor variables by name or as indexes
    # 3. Vary C, gamma to see when we get a good result - Manually at the moment
    RBFclf = svm.SVC(kernel = 'rbf')
    Fit = RBFclf.fit(predictors,response_var)
    Prediction = Fit.predict(predictors)
    return(Prediction)

