# 4. Modeling

load("data/mart.rdata")
summary(mart$Date)

diff<-rep(0,nrow(mart))
for (i in 2:nrow(mart)) diff[i]<-mart$f_krw_usd[i]-mart$f_krw_usd[i-1]

ind_mdl<-which(mart$Date>="2011-01-01" & mart$Date<="2013-12-31")
model_data<-mart[ind_mdl,]
model_diff<-diff[ind_mdl]
summary(model_data$Date)

ind_val<-which(mart$Date>="2014-01-01")
val_data<-mart[ind_val,]
val_diff<-diff[ind_val]
summary(val_data$Date)

set.seed(2020)
ind<-sample(2,nrow(model_data),prob=c(0.7,0.3),replace=T)
train_data<-model_data[ind==1,]
train_diff<-model_diff[ind==1]
test_data<-model_data[ind==2,]
test_diff<-model_diff[ind==2]

summary(train_data)
lm_fx<-lm(f_krw_usd~.,train_data[,-1])
summary(lm_fx)
par(mfrow=c(2,2))
plot(lm_fx)
par(mfrow=c(1,1))

train_pred<-predict(lm_fx,train_data)
train_res<-train_pred-train_data$f_krw_usd
summary(train_res)
summary(train_diff)
par(mfrow=c(2,2))
plot(train_res,ylim=c(-20,27.5))
plot(train_diff,ylim=c(-20,27.5))
brks<-seq(from=-20,to=27.5,by=2.5)
hist(train_res,breaks=brks,ylim=c(0,200))
hist(train_diff,breaks=brks,ylim=c(0,200))
par(mfrow=c(1,1))

test_pred<-predict(lm_fx,test_data)
test_res<-test_pred-test_data$f_krw_usd
summary(test_res)
summary(test_diff)
par(mfrow=c(2,2))
plot(test_res,ylim=c(-20,20))
plot(test_diff,ylim=c(-20,20))
brks<-seq(from=-20,to=20,by=2.5)
hist(test_res,breaks=brks,ylim=c(0,100))
hist(test_diff,breaks=brks,ylim=c(0,100))
par(mfrow=c(1,1))

val_pred<-predict(lm_fx,val_data)
val_res<-val_pred-val_data$f_krw_usd
summary(val_res)
summary(val_diff)
par(mfrow=c(2,2))
plot(val_res,ylim=c(-15,20))
plot(val_diff,ylim=c(-15,20))
hist(val_res,breaks=brks,ylim=c(0,80))
hist(val_diff,breaks=brks,ylim=c(0,80))
par(mfrow=c(1,1))

names(train_data)
tr_data<-train_data[,c("f_krw_usd","f_cad_usd","f_gbp_usd","y_jp_10yr","s_dax","u_index","f_krw_gbp","f_krw_eur","s_krx_autos")]
lm_fx_selVar<-lm(f_krw_usd~.,tr_data)
summary(lm_fx_selVar)

par(mfrow=c(2,2))
plot(lm_fx_selVar)
par(mfrow=c(1,1))

train_pred_selVar<-predict(lm_fx_selVar,train_data)
train_res_selVar<-train_pred_selVar-train_data$f_krw_usd
summary(train_res_selVar)
summary(train_diff)
par(mfrow=c(2,2))
plot(train_res_selVar,ylim=c(-20,27.5))
plot(train_diff,ylim=c(-20,27.5))
brks<-seq(from=-20,to=27.5,by=2.5)
hist(train_res_selVar,breaks=brks,ylim=c(0,250))
hist(train_diff,breaks=brks,ylim=c(0,250))
par(mfrow=c(1,1))

test_pred_selVar<-predict(lm_fx_selVar,test_data)
test_res_selVar<-test_pred_selVar-test_data$f_krw_usd
summary(test_res_selVar)
summary(test_diff)
par(mfrow=c(2,2))
plot(test_res_selVar,ylim=c(-20,20))
plot(test_diff,ylim=c(-20,20))
brks<-seq(from=-20,to=20,by=2.5)
hist(test_res_selVar,breaks=brks,ylim=c(0,100))
hist(test_diff,breaks=brks,ylim=c(0,100))
par(mfrow=c(1,1))

val_pred_selVar<-predict(lm_fx_selVar,val_data)
val_res_selVar<-val_pred_selVar-val_data$f_krw_usd
summary(val_res_selVar)
summary(val_diff)
par(mfrow=c(2,2))
plot(val_res_selVar,ylim=c(-20,10))
plot(val_diff,ylim=c(-20,10))
hist(val_res_selVar,breaks=brks,ylim=c(0,80))
hist(val_diff,breaks=brks,ylim=c(0,80))
par(mfrow=c(1,1))

save(model_data,model_diff,val_data,val_diff,train_data,train_diff,test_data,test_diff,lm_fx,tr_data,lm_fx_selVar,file="data/lm_model.rdata")
