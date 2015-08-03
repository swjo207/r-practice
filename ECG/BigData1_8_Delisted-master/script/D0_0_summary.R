# (1) 변수 확인
load("data/3_3yr_bind.rdata")

names(T_4to8_rF)[1] # 상장폐지 여부 (Target 변수)
names(T_4to8_rF)[c(2,19,36)] # 감사의견
names(T_4to8_rF)[c(3:12,20:29,37:46)] # 재무정보
names(T_4to8_rF)[c(13:17,30:34,47:51)] # 재무비율
names(T_4to8_rF)[c(18,35,52)] # 파생변수

## (2) 모델링
# (a) randomForest
# install.packages("randomForest")
library(randomForest)

set.seed(2020)
myFormula<-v04_D_YN~.
T_4to8_mdl_rF<-randomForest(myFormula,data=T_4to8_rF,prox=TRUE)

(T_4to8_rF_m_tr<-table(predict(T_4to8_mdl_rF),T_4to8_rF$v04_D_YN))
T_4to8_rF_m_tr[2,2]/sum(T_4to8_rF_m_tr[2,]) # Precision
T_4to8_rF_m_tr[2,2]/sum(T_4to8_rF_m_tr[,2]) # Detect rate
sum(diag(T_4to8_rF_m_tr))/sum(T_4to8_rF_m_tr) # Accuracy

tPred_rF_9to13<-predict(T_4to8_mdl_rF, newdata=T_9to13_rF,type="class")
(T_4to8_rF_m_tt<-table(tPred_rF_9to13,T_9to13$v04_D_YN))
T_4to8_rF_m_tt[2,2]/sum(T_4to8_rF_m_tt[2,]) # Precision
T_4to8_rF_m_tt[2,2]/sum(T_4to8_rF_m_tt[,2]) # Detect rate
sum(diag(T_4to8_rF_m_tt))/sum(T_4to8_rF_m_tt) # Accuracy

# (b) rpart의 prior 옵션 이용
library(rpart)
T_4to8_rpp<-rpart(myFormula,data=T_4to8,parms=list(prior=c(0.5,0.5)))

(T_4to8_rpp_m_tr<-table(predict(T_4to8_rpp, newdata=T_4to8,type="class"),T_4to8$v04_D_YN))
T_4to8_rpp_m_tr[2,2]/sum(T_4to8_rpp_m_tr[2,]) # Precision
T_4to8_rpp_m_tr[2,2]/sum(T_4to8_rpp_m_tr[,2]) # Detect rate
sum(diag(T_4to8_rpp_m_tr))/sum(T_4to8_rpp_m_tr) # Accuracy

tPred_rpp_9to13<-predict(T_4to8_rpp, newdata=T_9to13,type="class")
(T_9to13_rpp_m_tt<-table(tPred_rpp_9to13,T_9to13$v04_D_YN))
T_9to13_rpp_m_tt[2,2]/sum(T_9to13_rpp_m_tt[2,]) # Precision
T_9to13_rpp_m_tt[2,2]/sum(T_9to13_rpp_m_tt[,2]) # Detect rate
sum(diag(T_9to13_rpp_m_tt))/sum(T_9to13_rpp_m_tt) # Accuracy
