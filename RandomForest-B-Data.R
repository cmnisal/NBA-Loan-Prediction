#©️ By Nisal Chandrasekara for BA Assignment CIS-7026
#ST20163553-CL/CARDIFFMB/18/336	

#Setting-Up Working Directory and Loading Data
getwd()
ntb_data<-read_excel('NTB-Bank-Dataset.xlsx',sheet = 2)

#Replace Missing Values
sum(is.na(ntb_data[6]))
ntb_data$`Family members`[which(is.na(ntb_data$`Family members`))]<-median(ntb_data$`Family members`,na.rm = TRUE)

which(ntb_data$`Experience (in years)`<0)
ntb_data$`Experience (in years)`[which(ntb_data$`Experience (in years)`<0)]<-0

ntb_dataRF<-ntb_data[,-c(1,5)]
table(ntb_dataRF$`Personal Loan`)

#Changing to categorical variables
ntb_dataRF$`Family members`<-as.factor(ntb_dataRF$`Family members`)
ntb_dataRF$Education<-as.factor(ntb_dataRF$Education)
ntb_dataRF$`Securities Account`<-as.factor(ntb_dataRF$`Securities Account`)
ntb_dataRF$`CD Account`<-as.factor(ntb_dataRF$`CD Account`)
ntb_dataRF$Online<-as.factor(ntb_dataRF$Online)
ntb_dataRF$CreditCard<-as.factor(ntb_dataRF$CreditCard)
ntb_dataRF$`Personal Loan`<-as.factor(ntb_dataRF$`Personal Loan`)

#Scaling of variables
ntb_dataRF$`Age (in years)`<-scale(ntb_dataRF$`Age (in years)`)
ntb_dataRF$`Experience (in years)`<-scale(ntb_dataRF$`Experience (in years)`)
ntb_dataRF$`Income (in K/month)`<-scale(ntb_dataRF$`Income (in K/month)`)
ntb_dataRF$CCAvg<-scale(ntb_dataRF$CCAvg)
ntb_dataRF$Mortgage<-scale(ntb_dataRF$Mortgage)

#Changing variable names
names(ntb_dataRF)[1]<-"Age"
names(ntb_dataRF)[2]<-"Experience"
names(ntb_dataRF)[3]<-"Income"
names(ntb_dataRF)[4]<-"FamilyMembers"
names(ntb_dataRF)[8]<-"PersonalLoan"
names(ntb_dataRF)[9]<-"SecuritiesAccount"
names(ntb_dataRF)[10]<-"CDAccount"
class(ntb_dataRF$PersonalLoan)

#Splitting train and test
set.seed(1234)
sample1<-sample.split(ntb_dataRF,SplitRatio=0.8)
p_trainRF<-subset(ntb_dataRF,sample1==TRUE)
p_testRF<-subset(ntb_dataRF,sample1==FALSE)
table(p_trainRF$PersonalLoan)
table(p_testRF$PersonalLoan)
class(p_trainRF)

#Running Random Forest
mtry<-tuneRF(p_trainRF[-8],p_trainRF$PersonalLoan,ntreeTry = 500,stepFactor = 1.5,improve = 0.01,
             trace = TRUE,plot = TRUE)

rf<-randomForest(formula= PersonalLoan~.,data = p_trainRF, mtry=6, ntree=500,importance=TRUE)
varImpPlot(rf)
print(rf)

#Accuracy 98.7%

#Predicting on Validation set
predTest <- predict(rf, p_testRF, type = "class")
# Checking classification accuracy
mean(predTest == p_testRF$PersonalLoan)                    
table(predTest,p_testRF$PersonalLoan) 
# Accuracy 98.7


# Get KS , AUC and Gini

p_testRF$predict.class <- predict(rf, p_testRF, type="class")
p_testRF$predict.score <- predict(rf, p_testRF, type="prob")

#Performance Testing
pred_test_rf <- prediction(p_testRF$predict.score[,2], p_testRF$PersonalLoan)
perf_test_rf <- performance(pred_test_rf, "tpr", "fpr")
plot(perf_test_rf)
KS_test_rf <- max(attr(perf_test_rf, 'y.values')[[1]]-attr(perf_test_rf, 'x.values')[[1]])
KS_test_rf
auc_test_rf <- performance(pred_test_rf,"auc"); 
auc_test_rf <- as.numeric(auc_test_rf@y.values)
auc_test_rf

#Gini Test
gini_test_rf = ineq(p_testRF$predict.score[,2], type="Gini")
gini_test_rf














