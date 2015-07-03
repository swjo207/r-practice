##
## 1. 통계적 확률분포 
## 2. 정규분포 
## 3. 정규분포 확률 구하기 
## 4. t 분포 
## 5. 카이자승 분포 
## 6. F 분포 


## section 1 
##
## 이항분포/ binom / size,prob
## 기하분포 / geom / prob
## 초기하분포 / hyper / m,n,k
## 포아송분포 / pois / lamda
## 균일분포 / unif / min, max
## 지수분포 / exp / rate
## 정규분포 / norm / mean, sd
## t 분포 / t / df
## 카이자승분포 / chisq / df
## F 분포 / f / df1, df2 
## 감마분포 / gamma / shape, scale
## 베타 분포  / beta / shape1, shape2
## 코쉬분포 / causy / location, scale 
#===========================================
# 제5강 통계적 확률분포패키지(p162)
#===========================================
#--- 5.1 일량분포 난수 발생과 그림 그리기
plot.new()
# 균일분포 난수와 히스토그램 그리기
runif(100)
vec01 <- runif(100)
hist(vec01)
hist(runif(100))

set.seed(100)
vec01 <- runif(100)
hist(vec01)

?pbinom
pbinom(3,5,0.5)
1-pbinom(3,5,0.5)
pbinom(3,5,0.5,lower.tail=T)
pbinom(3,5,0.5,lower.tail=F)

#--- 정규분포 그리기(dnorm)
x <- seq(-5,5,by=0.1)
plot(x,dnorm(x))
plot(x,dnorm(x),type='l')
plot(x,dnorm(x),type='l',main='제5강 정규분포 그림그리기',ylab="정규분포 확률",xlab='X 축')

#--- 정규분포 난수 발생(rnorm) 
vec01 <- rnorm(100)
hist(vec01)
summary(vec01)

#--- 정규분포 확률구하기(pnorm)
p2 <- pnorm(54,mean=50,sd=10);p2   # 0.6554217
p2 <- pnorm(54,mean=50,sd=10,lower.tail=T);p2 
p1 <- pnorm(48,mean=50,sd=10);p1   # 0.4207403
p1 <- pnorm(48,mean=50,sd=10,lower.tail=T);p1
p2-p1             #[1]  0.2346815

p2 <- pnorm(0.4,mean=0,sd=1,lower.tail=T);p2   #[1] 0.6554217
p1 <- pnorm(-0.2,mean=0,sd=1,lower.tail=T);p1  # [1] 0.4207403
p2-p1  #[1] 0.2346815

#--- 정규분포 값 구하기
qnorm(0.95)  # [1] 1.644854
qnorm(0.975)  # [1] 1.959964

qnorm(0.6554217)  # 0.4
qnorm(0.4207403)  #-0.2


#--- t분포 그리기
plot.new()
par(mfrow=c(1,3))
x <- seq(-5,5,by=0.1)
dt(x,df=5)
?plot
plot(x,dt(x,df=2),type='l',xlim=c(-5,5),ylim=c(0,0.4))
plot(x,dt(x,df=5),type='l',xlim=c(-5,5),ylim=c(0,0.4))
plot(x,dt(x,df=10),type='l',xlim=c(-5,5),ylim=c(0,0.4))
plot.new()
par(mfrow=c(1,1))
par(new=T)
plot(x,dt(x,df=2),type='l',xlim=c(-5,5),ylim=c(0,0.4),ylab="")
par(new=T)
plot(x,dt(x,df=5),type='l',xlim=c(-5,5),ylim=c(0,0.4),ylab="")
par(new=T)
plot(x,dt(x,df=10),type='l',xlim=c(-5,5),ylim=c(0,0.4),ylab="")     
