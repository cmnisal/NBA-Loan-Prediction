#©️ By Nisal Chandrasekara for BA Assignment CIS-7026
#ST20163553-CL/CARDIFFMB/18/336	

#Setting-Up Working Directory and Loading Data
getwd()
ntb_data<-read_excel('NTB-Bank-Dataset.xlsx',sheet = 2)
str(ntb_data)
head(ntb_data)
summary(ntb_data)

#Checking Data
sum(is.na(ntb_data))
sum(is.na(ntb_data[6]))
sum(is.na(ntb_data[2]))
sum(is.na(ntb_data[3]))
sum(is.na(ntb_data[4]))
sum(is.na(ntb_data[5]))
sum(is.na(ntb_data[7]))
sum(is.na(ntb_data[8]))
sum(is.na(ntb_data[9]))
sum(is.na(ntb_data[10]))
sum(is.na(ntb_data[11]))
sum(is.na(ntb_data[12]))
sum(is.na(ntb_data[13]))
sum(is.na(ntb_data[14]))


#Replace Missing Values
median(ntb_data$`Family members`,na.rm = TRUE)
ntb_data$`Family members`[which(is.na(ntb_data$`Family members`))]<-median(ntb_data$`Family members`,na.rm = TRUE)
sum(is.na(ntb_data[6]))

#Removing Unwanted Features
ntb_data[rowSums(ntb_data < 0) == 0,]
which(ntb_data$`Experience (in years)`<0)
ntb_data$`Experience (in years)`[which(ntb_data$`Experience (in years)`<0)]<-0

#Box-Plots for Age, Income and Experience
boxplot(ntb_data$`Age (in years)`)
boxplot(ntb_data$`Experience (in years)`)
boxplot(ntb_data$`Income (in K/month)`)

#Outlier Detection
for(i in 2:14){
  outlier_check<-boxplot(ntb_data[i],plot = FALSE)$Out
  print(outlier_check)
}

#Removing Unwanted Variables
ntb_data1<-ntb_data[,-c(1,5)]

#Multiple Histograms
multi.hist(ntb_data1)
boxplot(ntb_data1,col='BLUE',horizontal = TRUE,las=2,cex.axis=0.4)

plot(ntb_data1$CCAvg,ntb_data1$Mortgage)
plot(ntb_data1$CCAvg,ntb_data1$`Income (in K/month)`)
plot(ntb_data1$Education,ntb_data1$`Income (in K/month)`)
plot(ntb_data1$Mortgage,ntb_data1$`Income (in K/month)`)
plot(ntb_data1$`Family members`,ntb_data1$`Personal Loan`)

#Corelations
cor.plot(ntb_data1,numbers = TRUE,xlas=2)

#Removing Unwanted Variables
ntb_data2<-ntb_data[,-c(1,5)]

table(ntb_data2$`Personal Loan`)
ntb_data2$`Age (in years)`<-scale(ntb_data2$`Age (in years)`)
ntb_data2$`Experience (in years)`<-scale(ntb_data2$`Experience (in years)`)
ntb_data2$`Income (in K/month)`<-scale(ntb_data2$`Income (in K/month)`)
ntb_data2$`Family members`<-scale(ntb_data2$`Family members`)
ntb_data2$CCAvg<-scale(ntb_data2$CCAvg)
ntb_data2$Education<-scale(ntb_data2$Education)
ntb_data2$Mortgage<-scale(ntb_data2$Mortgage)

#K-Means Clutering
km.res<-kmeans(ntb_data2,5,nstart = 25)
print(km.res)

#Sum of squares after running k times.
fviz_nbclust(ntb_data2,kmeans,method = 'wss',print.summary = TRUE,k.max = 40)
km.res<-kmeans(ntb_data2,13,nstart = 25)
print(km.res)
fviz_cluster(km.res,ntb_data2,ellipse.type='norm')

#CART, Evaluatio and Splitting Data
set.seed(1234)
sample<-sample.split(ntb_data2,SplitRatio=0.8)
p_train<-subset(ntb_data2,sample==TRUE)
p_test<-subset(ntb_data2,sample==FALSE)
table(p_train$`Personal Loan`)
table(p_test$`Personal Loan`)

#Define Control Parameters CART
r.ctrl <- rpart.control(minsplit = 515, minbucket = 172,cp=0.33,xval = 10)#972

attach(ntb_data2)
#To make the model
m1 <- rpart(formula = `Personal Loan`~., data = p_train, method = "class", control = r.ctrl)

#To draw decision tree | Root is Income
fancyRpartPlot(m1)
plot(m1)


#To find the accuracy of the train data, need the predicted class
#For each case and the predicted probability
p_train$predict.class <- predict (m1, p_train, type = "class")
head(p_train)

p_train$predict.score<-predict(m1, p_train)
head(p_train)

#Draw confusion matrix
with(p_train, table(`Personal Loan`, predict.class))
#accuracy = (2623+195)/2917 = 97%

#Applying on TEST Data
p_test$predict.class <- predict (m1, p_test, type = "class")
head(p_test)

p_test$predict.score<-predict(m1, p_test)
head(p_test)

#Draw Confusion matrix
with(p_test, table(`Personal Loan`, predict.class))
#accuracy = (1897+102)/2083 = 96%




# Get KS , AUC and Gini

pred_test <- prediction(p_test$predict.score[,2], p_test$`Personal Loan`)
perf_test <- performance(pred_test, "tpr", "fpr")
plot(perf_test)
KS_test <- max(attr(perf_test, 'y.values')[[1]]-attr(perf_test, 'x.values')[[1]])
KS_test
auc_test <- performance(pred_test,"auc")
auc_test <- as.numeric(auc_test@y.values)
auc_test
gini_test = ineq(p_test$predict.score[,2], type="Gini")
gini_test

#Pruning
bestcp <- m1$cptable[which.min(m1$cptable[,"xerror"]), "CP"]
bestcp
m1_pruned<- prune(m1, cp= bestcp ,"CP")


#RandomForest

getwd()
ntb_data<-read_excel('Thera Bank-Data Set.xlsx',sheet = 2)

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

#Scaling of variables.
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
sample1<-sample.split(ntb_dataRF,SplitRatio=0.6)
p_trainRF<-subset(ntb_dataRF,sample1==TRUE)
p_testRF<-subset(ntb_dataRF,sample1==FALSE)
table(p_trainRF$PersonalLoan)
table(p_testRF$PersonalLoan)
class(p_trainRF)

#Running random forest
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


pred_test_rf <- prediction(p_testRF$predict.score[,2], p_testRF$PersonalLoan)
perf_test_rf <- performance(pred_test_rf, "tpr", "fpr")
plot(perf_test_rf)
KS_test_rf <- max(attr(perf_test_rf, 'y.values')[[1]]-attr(perf_test_rf, 'x.values')[[1]])
KS_test_rf
auc_test_rf <- performance(pred_test_rf,"auc"); 
auc_test_rf <- as.numeric(auc_test_rf@y.values)
auc_test_rf

gini_test_rf = ineq(p_testRF$predict.score[,2], type="Gini")
gini_test_rf





