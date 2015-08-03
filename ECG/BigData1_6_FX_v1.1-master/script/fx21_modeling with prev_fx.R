load("data/mart.rdata")
summary(mart$Date)

diff<-rep(0,nrow(mart));flag<-0
if(flag==0) for (i in 2:nrow(mart)) diff[i]<-mart$f_krw_usd[i]-mart$f_krw_usd[i-1];flag<-1
if(flag==1) for (i in 2:nrow(mart)) mart$f_krw_usd_prv[i]<-mart$f_krw_usd[i-1];flag<-2
names(mart)

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
lm_fx_prv<-lm(f_krw_usd~.,train_data[,-1])
summary(lm_fx_prv)
