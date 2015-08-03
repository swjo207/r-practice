###############################################
# 3.3 3개 data 통합 후 상장폐지사 예측 모델링 #
###############################################

## (1) 3개년 data 3개 합하기

load("data/3yr_data_04to13.rdata")

#########################
# 2004 to 2008 : T_4to8 #
#########################
names(T_456_ini)[1:10]
table(names(T_456_ini)==names(T_567_ini))
table(names(T_456_ini)==names(T_678_ini))
names(T_456_rF_ini)[1:10]
table(names(T_456_rF_ini)==names(T_567_rF_ini))
table(names(T_456_rF_ini)==names(T_678_rF_ini))

ind_456<-which(T_456_ini$v04_D_YN=="1")
ind_567<-which(T_567_ini$v04_D_YN=="1")
T_4to8_ini<-rbind(T_456_ini[ind_456,],T_567_ini[ind_567,],T_678_ini)
names(T_4to8_ini)[1:10]
T_4to8<-T_4to8_ini[,-c(1:3)]
names(T_4to8)[1:10]

ind_456_rF<-which(T_456_rF_ini$v04_D_YN=="1")
ind_567_rF<-which(T_567_rF_ini$v04_D_YN=="1")
T_4to8_rF_ini<-rbind(T_456_rF_ini[ind_456_rF,],T_567_rF_ini[ind_567_rF,],T_678_rF_ini)
names(T_4to8_rF_ini)[1:10]
T_4to8_rF<-T_4to8_rF_ini[,-c(1:3)]
names(T_4to8_rF)[1:10]
str(T_4to8_rF[,1:10])

table(T_4to8$v04_D_YN);table(T_4to8_rF$v04_D_YN)
120/(1827+120) # 6.16 %

#########################
# 2009 to 2013 : T_9to3 #
#########################
ind_901<-which(T_901_ini$v04_D_YN=="1")
ind_012<-which(T_012_ini$v04_D_YN=="1")
T_9to13_ini<-rbind(T_901_ini[ind_901,],T_012_ini[ind_012,],T_123_ini)
T_9to13<-T_9to13_ini[,-c(1:3)]

ind_901_rF<-which(T_901_rF_ini$v04_D_YN=="1")
ind_012_rF<-which(T_012_rF_ini$v04_D_YN=="1")
T_9to13_rF_ini<-rbind(T_901_rF_ini[ind_901_rF,],T_012_rF_ini[ind_012_rF,],T_123_rF_ini)
T_9to13_rF<-T_9to13_rF_ini[,-c(1:3)]

table(T_9to13$v04_D_YN);table(T_9to13_rF$v04_D_YN)
102/(1660+102) # 5.79 %

save(T_4to8_ini,T_4to8,T_4to8_rF_ini,T_4to8_rF,T_9to13_ini,T_9to13,T_9to13_rF_ini,T_9to13_rF,file="data/3_3yr_bind.rdata")

## (2) Formula

myFormula<-v04_D_YN~.

## (3) 모델링

### (a) party

# install.packages("party")
library(party)

# Train the model
T_4to8_mdl_ctree<-ctree(myFormula,data=T_4to8)
(T_4to8_ct_m_tr<-table(predict(T_4to8_mdl_ctree),T_4to8$v04_D_YN))
T_4to8_ct_m_tr[2,2]/sum(T_4to8_ct_m_tr[2,]) # Precision
T_4to8_ct_m_tr[2,2]/sum(T_4to8_ct_m_tr[,2]) # Detect rate
sum(diag(T_4to8_ct_m_tr))/sum(T_4to8_ct_m_tr) # Accuracy 

# Visualization
plot(T_4to8_mdl_ctree,type="simple")

# Test the model
tPred_p_9to13<-predict(T_4to8_mdl_ctree,newdata=T_9to13)
(T_4to8_ct_m_tt<-table(tPred_p_9to13,newdata=T_9to13$v04_D_YN))
T_4to8_ct_m_tt[2,2]/sum(T_4to8_ct_m_tt[2,]) # Precision
T_4to8_ct_m_tt[2,2]/sum(T_4to8_ct_m_tt[,2]) # Detect rate
sum(diag(T_4to8_ct_m_tt))/sum(T_4to8_ct_m_tt) # Accuracy 

### (b) rpart

# install.packages("rpart")
# install.packages("partykit")
library(rpart)
library(partykit)

# Train the model
T_4to8_mdl_rp<-rpart(myFormula,data=T_4to8,control=rpart.control(minsplit=10))
(T_4to8_rp_m_tr<-table(predict(T_4to8_mdl_rp, newdata=T_4to8,type="class"),T_4to8$v04_D_YN))
T_4to8_rp_m_tr[2,2]/sum(T_4to8_rp_m_tr[2,]) # Precision
T_4to8_rp_m_tr[2,2]/sum(T_4to8_rp_m_tr[,2]) # Detect rate
sum(diag(T_4to8_rp_m_tr))/sum(T_4to8_rp_m_tr) # Accuracy 

# Visualization
# plot rpart
plot(T_4to8_mdl_rp)
text(T_4to8_mdl_rp,use.n=TRUE)
# plot using partykit
plot(as.party(T_4to8_mdl_rp))

attributes(T_4to8_mdl_rp)
T_4to8_mdl_rp$where[1:10]

# Test the model
tPred_rp_9to13<-predict(T_4to8_mdl_rp, newdata=T_9to13,type="class")
(T_4to8_rp_m_tt<-table(tPred_rp_9to13,T_9to13$v04_D_YN))
T_4to8_rp_m_tt[2,2]/sum(T_4to8_rp_m_tt[2,]) # Precision
T_4to8_rp_m_tt[2,2]/sum(T_4to8_rp_m_tt[,2]) # Detect rate
sum(diag(T_4to8_rp_m_tt))/sum(T_4to8_rp_m_tt) # Accuracy

### (c) randomForest

# install.packages("randomForest")
library(randomForest)
set.seed(2020)

# Train the model
(st_rF_4to8<-system.time(T_4to8_mdl_rF<-randomForest(myFormula,data=T_4to8_rF,prox=TRUE)))
# on the MacBook Pro (Core i7, 16 GB memory)

table(predict(T_4to8_mdl_rF),T_4to8_rF$v04_D_YN)
(T_4to8_rF_m_tr<-table(predict(T_4to8_mdl_rF),T_4to8_rF$v04_D_YN))
T_4to8_rF_m_tr[2,2]/sum(T_4to8_rF_m_tr[2,]) # Precision
T_4to8_rF_m_tr[2,2]/sum(T_4to8_rF_m_tr[,2]) # Detect rate
sum(diag(T_4to8_rF_m_tr))/sum(T_4to8_rF_m_tr) # Accuracy

# Visualization
varImpPlot(T_4to8_mdl_rF, n.var=15)
plot(T_4to8_mdl_rF)
legend("topright", colnames(T_4to8_mdl_rF$err.rate),col=1:4,cex=0.8,fill=1:4)

# Test the model
tPred_rF_9to13<-predict(T_4to8_mdl_rF, newdata=T_9to13_rF,type="class")
(T_4to8_rF_m_tt<-table(tPred_rF_9to13,T_9to13$v04_D_YN))
T_4to8_rF_m_tt[2,2]/sum(T_4to8_rF_m_tt[2,]) # Precision
T_4to8_rF_m_tt[2,2]/sum(T_4to8_rF_m_tt[,2]) # Detect rate
sum(diag(T_4to8_rF_m_tt))/sum(T_4to8_rF_m_tt) # Accuracy


## (5) 상장폐지사의 중요 변수별 탐색적 분석

### (a) 중요 변수의 도출

varImpPlot(T_4to8_mdl_rF, n.var=15)
names(T_4to8_rF)

### (b) 상장사 vs. 상장폐지사

ind0<-which(T_4to8_rF$v04_D_YN==0)
ind1<-which(T_4to8_rF$v04_D_YN==1)

# D1_v11_aud (1st important var)
table(T_4to8_rF$D1_v11_aud,T_4to8_rF$v04_D_YN)
barplot(table(T_4to8_rF$D1_v11_aud,T_4to8_rF$v04_D_YN),horiz = T,xlab="# company",ylab="Delist_YN",main="D1_v11_aud (1st important var)",legend.text = c("pred_0", "pred_1"))

# D1_v27_tot_eqt (2nd important var)
(q0<-quantile(T_4to8_rF$D1_v27_tot_eqt[ind0]))
(q1<-quantile(T_4to8_rF$D1_v27_tot_eqt[ind1]))
boxplot(T_4to8_rF$D1_v27_tot_eqt~T_4to8_rF$v04_D_YN, ylim = c(q1[2], q0[4]),main="D1_v27_tot_eqt (1st important var)")

# D1_v54_R_liab_rat(3rd important var)
(q0<-quantile(T_4to8_rF$D1_v54_R_liab_rat[ind0]))
(q1<-quantile(T_4to8_rF$D1_v54_R_liab_rat[ind1]))
boxplot(T_4to8_rF$D1_v54_R_liab_rat~T_4to8_rF$v04_D_YN, ylim = c(0, q1[4]),main="D1_v54_R_liab_rat(2nd important var)")

# D1_v51_R_op_prf_sal(4th important var)
(q0<-quantile(T_4to8_rF$D1_v51_R_op_prf_sal[ind0]))
(q1<-quantile(T_4to8_rF$D1_v51_R_op_prf_sal[ind1]))
boxplot(T_4to8_rF$D1_v51_R_op_prf_sal~T_4to8_rF$v04_D_YN, ylim = c(q1[2], q0[4]),main="D1_v51_R_op_prf_sal(3rd important var)")

# D1_v29_op_prf(5th important var)
(q0<-quantile(T_4to8_rF$D1_v29_op_prf[ind0]))
(q1<-quantile(T_4to8_rF$D1_v29_op_prf[ind1]))
boxplot(T_4to8_rF$D1_v29_op_prf~T_4to8_rF$v04_D_YN, ylim = c(q1[2], q0[4]),main="D1_v29_op_prf(4th important var)")

# D1_v71_R_cur_rat_dv
table(T_4to8_rF$D1_v71_R_cur_rat_dv,T_4to8_rF$v04_D_YN)
barplot(table(T_4to8_rF$D1_v71_R_cur_rat_dv,T_4to8_rF$v04_D_YN),horiz = T,xlab="# company",ylab="Delist_YN",main="D1_v71_R_cur_rat_dv (derived variable)",legend.text = c("dv_1", "dv_-1", "dv_0"))
