########################################
# 3.4  단일연도 상장폐지사 예측 모델링 #
########################################

## (1) data load 및 Formula

load("data/3yr_data_04to13.rdata")
myFormula<-v04_D_YN~.

## (2) 모델링
### (a) party
detach(package:partykit)
library(party)
# Train the model
T_901_ctree<-ctree(myFormula,data=T_901)
(T_901_ct_m_tr<-table(predict(T_901_ctree),T_901$v04_D_YN))
T_901_ct_m_tr[2,2]/sum(T_901_ct_m_tr[2,]) # Precision
T_901_ct_m_tr[2,2]/sum(T_901_ct_m_tr[,2]) # Detect rate
sum(diag(T_901_ct_m_tr))/sum(T_901_ct_m_tr) # Accuracy

# Visualization
plot(T_901_ctree,type="simple")

# Test the model
tPred_p_2011<-predict(T_901_ctree,newdata=T_012)
(T_901_ct_m_tt<-table(tPred_p_2011,newdata=T_012$v04_D_YN))
T_901_ct_m_tt[2,2]/sum(T_901_ct_m_tt[2,]) # Precision
T_901_ct_m_tt[2,2]/sum(T_901_ct_m_tt[,2]) # Detect rate
sum(diag(T_901_ct_m_tt))/sum(T_901_ct_m_tt) # Accuracy

### (b) raprt
library(rpart)
library(partykit)
# Train the model
T_901_rp<-rpart(myFormula,data=T_901,control=rpart.control(minsplit=10))
(T_901_rp_m_tr<-table(predict(T_901_rp, newdata=T_901,type="class"),T_901$v04_D_YN))
T_901_rp_m_tr[2,2]/sum(T_901_rp_m_tr[2,]) # Precision
T_901_rp_m_tr[2,2]/sum(T_901_rp_m_tr[,2]) # Detect rate
sum(diag(T_901_rp_m_tr))/sum(T_901_rp_m_tr) # Accuracy

# Visualization
plot(as.party(T_901_rp))

# Test the model
tPred_rp_2013<-predict(T_901_rp, newdata=T_012,type="class")
(T_901_rp_m_tt<-table(tPred_rp_2013,T_012$v04_D_YN))
T_901_rp_m_tt[2,2]/sum(T_901_rp_m_tt[2,]) # Precision
T_901_rp_m_tt[2,2]/sum(T_901_rp_m_tt[,2]) # Detect rate
sum(diag(T_901_rp_m_tt))/sum(T_901_rp_m_tt) # Accuracy

### (c) randomForest
library(randomForest)
set.seed(2020)
# Train the model
T_901_rf<-randomForest(myFormula,data=T_901_rF,prox=TRUE)
(T_901_rF_m_tr<-table(predict(T_901_rf),T_901_rF$v04_D_YN))
T_901_rF_m_tr[2,2]/sum(T_901_rF_m_tr[2,])
T_901_rF_m_tr[2,2]/sum(T_901_rF_m_tr[,2])
sum(diag(T_901_rF_m_tr))/sum(T_901_rF_m_tr)

# Visualization
plot(T_901_rf)
legend("topright", colnames(T_901_rf$err.rate),col=1:4,cex=0.8,fill=1:4)

# Test the model
tPred_rF_2013<-predict(T_901_rf,newdata=T_012_rF)
(T_901_rF_m_tt<-table(tPred_rF_2013,newdata=T_012_rF$v04_D_YN))
T_901_rF_m_tt[2,2]/sum(T_901_rF_m_tt[2,])
T_901_rF_m_tt[2,2]/sum(T_901_rF_m_tt[,2])
sum(diag(T_901_rF_m_tt))/sum(T_901_rF_m_tt)
