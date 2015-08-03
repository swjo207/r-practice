############################
# 3.6 탐지율을 높이는 방법 #
############################

## (1) prior 옵션을 적용한 rpart 모델링

load("data/3yr_data_04to13.rdata")
myFormula<-v04_D_YN~.

library(rpart)
library(partykit)

# Train the Model
T_901_rpp<-rpart(myFormula,data=T_901,parms=list(prior=c(0.8,0.2)))
(T_901_rpp_m_tr<-table(predict(T_901_rpp, newdata=T_901,type="class"),T_901$v04_D_YN))
T_901_rpp_m_tr[2,2]/sum(T_901_rpp_m_tr[2,]) # Precision
T_901_rpp_m_tr[2,2]/sum(T_901_rpp_m_tr[,2]) # Detect rate
sum(diag(T_901_rpp_m_tr))/sum(T_901_rpp_m_tr) # Accuracy

# Visualization
par(ps = 10)
plot(as.party(T_901_rpp))

T_901_rpp$where[1:10]
predict(T_901_rpp)[1:10,2]

ind_pred<-which(predict(T_901_rpp)[,2]>0.5)
table(T_901_rpp$where[ind_pred])
sum(table(T_901_rpp$where[ind_pred]))

# Test the Model
tPred_rpp_012<-predict(T_901_rpp, newdata=T_012,type="class")
(T_901_rpp_m_tt<-table(tPred_rpp_012,T_012$v04_D_YN))
T_901_rpp_m_tt[2,2]/sum(T_901_rpp_m_tt[2,]) # Precision
T_901_rpp_m_tt[2,2]/sum(T_901_rpp_m_tt[,2]) # Detect rate
sum(diag(T_901_rpp_m_tt))/sum(T_901_rpp_m_tt) # Accuracy

## (2) 2014년 예측에 적용

# Train the Model
T_012_rpp<-rpart(myFormula,data=T_012,parms=list(prior=c(0.7,0.3)))
(T_012_rpp_m_tr<-table(predict(T_012_rpp, newdata=T_012,type="class"),T_012$v04_D_YN))
T_012_rpp_m_tr[2,2]/sum(T_012_rpp_m_tr[2,]) # Precision
T_012_rpp_m_tr[2,2]/sum(T_012_rpp_m_tr[,2]) # Detect rate
sum(diag(T_012_rpp_m_tr))/sum(T_012_rpp_m_tr) # Accuracy

# Visualization
plot(as.party(T_012_rpp))

# Test the Model
tPred_rpp_012<-predict(T_012_rpp, newdata=T_123,type="class")
(T_012_rpp_m_tt<-table(tPred_rpp_012,T_123$v04_D_YN))
T_012_rpp_m_tt[2,2]/sum(T_012_rpp_m_tt[2,]) # Precision
T_012_rpp_m_tt[2,2]/sum(T_012_rpp_m_tt[,2]) # Detect rate
sum(diag(T_012_rpp_m_tt))/sum(T_012_rpp_m_tt) # Accuracy
