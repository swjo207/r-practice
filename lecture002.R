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

##
# 1. 정규 분포 
##
x <- seq(-5,5,by=0.1)
plot(x,dnorm(x))
plot(x,dnorm(x),type='l')
plot(x,dnorm(x),type='l',main='plotting normal distribution',ylab='probability',xlab='-5:5')

dnorm(0) == 1/sqrt(2*pi)
dnorm(1) == exp(-1/2)/sqrt(2*pi)
dnorm(1) == 1/sqrt(2*pi*exp(1))

## Using "log = TRUE" for an extended range :
par(mfrow = c(2,1))
plot(function(x) dnorm(x, log = TRUE), -60, 50,
     main = "log { Normal density }")
curve(log(dnorm(x)), add = TRUE, col = "red", lwd = 2)
mtext("dnorm(x, log=TRUE)", adj = 0)
mtext("log(dnorm(x))", col = "red", adj = 1)

plot(function(x) pnorm(x, log.p = TRUE), -50, 10,
     main = "log { Normal Cumulative }")
curve(log(pnorm(x)), add = TRUE, col = "red", lwd = 2)
mtext("pnorm(x, log=TRUE)", adj = 0)
mtext("log(pnorm(x))", col = "red", adj = 1)

## if you want the so-called 'error function'
erf <- function(x) 2 * pnorm(x * sqrt(2)) - 1
## (see Abramowitz and Stegun 29.2.29)
## and the so-called 'complementary error function'
erfc <- function(x) 2 * pnorm(x * sqrt(2), lower = FALSE)
## and the inverses
erfinv <- function (x) qnorm((1 + x)/2)/sqrt(2)
erfcinv <- function (x) qnorm(x/2, lower = FALSE)/sqrt(2)


# 2)  Binomial Distribution 

require(graphics)
# Compute P(45 < X < 55) for X Binomial(100,0.5)
sum(dbinom(46:54, 100, 0.5))

## Using "log = TRUE" for an extended range :
n <- 2000
k <- seq(0, n, by = 20)
plot (k, dbinom(k, n, pi/10, log = TRUE), type = "l", ylab = "log density",
      main = "dbinom(*, log=TRUE) is better than  log(dbinom(*))")
lines(k, log(dbinom(k, n, pi/10)), col = "red", lwd = 2)
## extreme points are omitted since dbinom gives 0.
mtext("dbinom(k, log=TRUE)", adj = 0)
mtext("extended range", adj = 0, line = -1, font = 4)
mtext("log(dbinom(k))", col = "red", adj = 1)



##
## 3. 정규분포 확률 구하기 
##

p2 <- pnorm(54,mean=50,sd=10,lower.tail = T)
p2
p1 <- pnorm(48,mean=50,sd=10,lower.tail = T)
p1
p2-p1

p2 <- pnorm(0.4,mean=0,sd=1,lower.tail = T); p2
p1 <- pnorm(-0.2,mean=0,sd=1,lower.tail = T);p1
x<- seq(20,80,by=0.1);
plot(x,dnorm(x,mean=50,sd=10))

##
## 4. t 분포 확률 구하기 
##


par(mfrow=c(1,3))
x <- seq(-3,3,by=0.1)
dt(x,df=5)
plot(x,dt(x,df=2),type='l')
plot(x,dt(x,df=10),type='l')
plot(x,dt(x,df=2),type='l',ylim=c(0,0.4))
