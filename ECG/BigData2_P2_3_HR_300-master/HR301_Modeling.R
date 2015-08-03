library(sqldf);library(gdata);library(party);library(rpart);library(randomForest);library(caret);library(gbm);library(plyr);library(C50);library(class);library(pROC);library(doMC);
registerDoMC(cores=6);

tr_s<-'2013-01-01'
tr_e<-'2013-02-28'
tt_s<-'2013-01-01'
tt_e<-'2013-06-30'

load("../HR200_Data_Mart/rdt/m_sl_f2011.rdata")
names(m_sl_f2011)

major<-m_sl_f2011[m_sl_f2011$date>=tr_s & m_sl_f2011$date<=tr_e,]
min(m_sl_f2011$date)
min(major$date)
max(major$date)

# split train & test set
ind <- sample(2,nrow(major),replace=TRUE,prob=c(0.7,0.3))
m_tr<-major[ind==1,]
m_tt<-major[ind==2,]

# exclude unavailable or irrelevant variables before the race 
m_tr_ex<-m_tr[,-c(1:7,11:13,15,49:50,214:216)]
names(m_tr_ex)

# formula
myformula<-targ~.
str(m_tr[,c("targ","round","origin","sex","type","pt4","wd2")])
names(m_tr)

# rpart with prior option
mdl_rpartp<-rpart(myformula,data=m_tr_ex,parms=list(prior=c(0.3,0.7)),cp=0.01)
res_mat_rpp_tr<-table(predict(mdl_rpartp,type="class"),m_tr$targ)
res_mat_rpp_tr*100/sum(res_mat_rpp_tr)

res_mat_rpp_tt<-table(predict(mdl_rpartp,newdata=m_tt,type="class"),m_tt$targ)
res_mat_rpp_tt*100/sum(res_mat_rpp_tt)

# result of rpart prior
m_tr_ex$rpp<-NULL
m_tt$rpp<-NULL
m_tr_ex$rpp<-predict(mdl_rpartp,type="class")
m_tt$rpp<-predict(mdl_rpartp,newdata=m_tt,type="class")
names(m_tt)
m_tr_ex$rpp<-factor(m_tr_ex$rpp)
m_tt$rpp<-factor(m_tt$rpp, levels=levels(m_tr_ex$rpp))

# knn (10 sec)
system.time(mdl_knn <- train(myformula,data=m_tr_ex,method="knn",preProcess=c("center","scale"),tuneLength=10,trControl=trainControl(method="cv")))
mdl_knn
confusionMatrix(mdl_knn)
res_mat_knn<-table(predict(mdl_knn, newdata=m_tt, type="raw"),m_tt$targ)
res_mat_knn*100/sum(res_mat_knn)
mdl_knn_Imp <<- varImp(mdl_knn)
plot(mdl_knn_Imp,top=20,cex=2,main="knn")

#c5.0 (1 min 40)
system.time(mdl_C50 <- train(myformula,data=m_tr_ex,method = "C5.0"))
mdl_C50
confusionMatrix(mdl_C50)
res_mat_C50<-table(predict(mdl_C50, newdata=m_tt, type="raw"),m_tt$targ)
res_mat_C50*100/sum(res_mat_C50)
mdl_C50_Imp <- varImp(mdl_C50)
plot(mdl_C50_Imp,top=20,cex=2,main="C50")

# randomForest (3 min)
system.time(mdl_rf <- train(myformula,data=m_tr_ex,method="rf",TuneLength=5,trControl=trainControl(method='cv',number=10,classProbs = TRUE),importance=TRUE))
mdl_rf
confusionMatrix(mdl_rf)
res_mat_rf<-table(predict(mdl_rf, newdata=m_tt, type="raw"),m_tt$targ)
res_mat_rf*100/sum(res_mat_rf)
mdl_rf_Imp <<- varImp(mdl_rf)
plot(mdl_rf_Imp,top=20,cex=2,main="randomForest")

# svmRadial (2 min 30)
system.time(mdl_svmradial <- train(myformula,data=m_tr_ex[,-61],method="svmRadial",preProcess = "range", tuneLength = 5,scaled=TRUE,trControl=trainControl(number=100)))
mdl_svmradial
confusionMatrix(mdl_svmradial)
res_mat_svm_tr<-table(predict(mdl_svmradial, newdata=m_tr_ex, type="raw"),m_tr_ex$targ)
res_mat_svm_tr*100/sum(res_mat_svm_tr)
res_mat_svm<-table(predict(mdl_svmradial, newdata=m_tt, type="raw"),m_tt$targ)
res_mat_svm*100/sum(res_mat_svm)
mdl_svmradial_Imp <<- varImp(mdl_svmradial)
plot(mdl_svmradial_Imp,top=20,cex=2,main="svmRadial")
names(m_tr_ex)

save(tt_s,tt_e,major,m_tr,m_tr_ex,m_tt,mdl_rpartp,mdl_knn,mdl_C50,mdl_rf,mdl_svmradial,file="model/model.rdata")
