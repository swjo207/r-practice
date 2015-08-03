# 4. Modeling

load("data/mart.rdata")

names(mart)[c(1,2)] # 일자와 원 달러 환율(목표변수)
names(mart)[c(3:9)] # 국제 원자재 가격 (c_)
names(mart)[c(10:16)] # 주요국 대미달러 환율(f_)
names(mart)[c(17:47)] # 주요국 정부 장단기 채권 금리(y_)
names(mart)[c(48:54)] # 주요국 주가지수(s_)
names(mart)[c(55)] # 달러지수(u_index)
names(mart)[c(56:59)] # 주요국 대원화 환율(f_krw_)
names(mart)[c(60:64)] # 우리나라 채권 금리 지수(y_krx_)
names(mart)[c(65:73)] # 우리나라 산업별 주가 지수(s_kospi, s_krx)


ind_mdl<-which(mart$Date>="2011-01-01" & mart$Date<="2013-12-31")
model_data<-mart[ind_mdl,]

set.seed(2020)
ind<-sample(2,nrow(model_data),prob=c(0.7,0.3),replace=T)
train_data<-model_data[ind==1,]
test_data<-model_data[ind==2,]

lm_fx<-lm(f_krw_usd~.,train_data[,-1])
summary(lm_fx)

# Modeling without a kind of the variables
lm_fx<-lm(f_krw_usd~.,train_data[,-c(1,3:9)]) # 원자재 제외
summary(lm_fx) # 0.9932

lm_fx<-lm(f_krw_usd~.,train_data[,-c(1,10:16,55,56:59)]) # FX 제외
summary(lm_fx) # 0.9348

lm_fx<-lm(f_krw_usd~.,train_data[,-c(1,17:47,60:64)]) # 금리 제외
summary(lm_fx) # 0.992

lm_fx<-lm(f_krw_usd~.,train_data[,-c(1,48:54,65:73)]) # 주가지수 제외
summary(lm_fx) # 0.9924

# Modeling without some kinds of the variables
lm_fx<-lm(f_krw_usd~.,train_data[,-c(1,3:9,10:16,55,56:59)]) # 원자재, FX 제외
summary(lm_fx) # 0.9299

lm_fx<-lm(f_krw_usd~.,train_data[,-c(1,10:16,55,56:59,17:47,60:64)]) # FX, 금리 제외
summary(lm_fx) # 0.8371

lm_fx<-lm(f_krw_usd~.,train_data[,-c(1,17:47,60:64,48:54,65:73)]) # 금리, 주가지수 제외
summary(lm_fx) # 0.9907

lm_fx<-lm(f_krw_usd~.,train_data[,-c(1,3:9,48:54,65:73)]) # 원자재, 주가지수 제외
summary(lm_fx) # 0.9923
