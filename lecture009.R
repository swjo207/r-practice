#===========================================
# 제9강 그래픽 다루기
#===========================================
#--- 9.1 그래픽 연습(p220)
plot.new()
par(mfrow=c(1,1))
#demo
#example(demo)
#demo()
demo(graphics)   # A show of some of R's graphics capabilities
demo(persp)      # Extended persp() examples
library(lattice)
demo(lattice)
#demo(image)     # The image-like graphics builtins of R
#demo(plotmath)  # Examples of the use of mathematics annotation
#demo(Hershey)   # Tables of the characters in the Hershey vector fonts
#demo(Japanese)  # Tables of the Japanese characters in the Hershey vector fonts
#methods(plot)

#install.packages("ggplot2")
#library(ggplot2)

#--- 9.2 그래픽(1) - 2차원 그래프 plot() (p221)
par(mfrow=c(1,1))
x <- c(1,2,3,4,5)
y <- c(20,22,23,21,25)
plot(x,y)
plot(x,y,main="plot의 예제",xlab="키",ylab="몸무게")
plot(x,y,main="plpt의 예제",xlab="키",ylab="몸무게",type='l')


# 그래픽(2) 막대그래프 barplot() (p222)
par(mfrow=c(1,1))
barplot(c(15,20,30,15,10))  # 빈도수 막대 그래프

vect01 <- c(1,1,1,2,2,2,2,2,3,3,4,4,4) # 1(3개), 2(5개), 3(2개), 4(3개)
tab01 <- table(vect01); 
tab01
class(tab01) # table
barplot(tab01)
barplot(tab01, horiz=T)     

# 라벨과 타이틀 붙이기
barplot(tab01,main="barplot의 예제",xlab="취미생활",ylab="빈도") 

# legend 추가하기
legend("topright",legend=c("여자","남자"),fill=c("red","blue"))  

# 타이틀 추가하기
text(1,4,"타이틀 붙이기",col="red")  

# 막대에 색깔입히기
barplot(tab01,main="취미생활 응답자 구성비", xlab="취미생활",ylab="빈도",col=c("gray9","grey60"))
barplot(tab01,main="취미생활 응답자 구성비", xlab="취미생활",ylab="빈도",col=c("red","blue"))

# 모자이크 그리기
(s <- read.table(file="d:/r_sample/survey_h.txt",header=T))
barplot(table(s$gender,s$edu))
mosaicplot(table(s$gender,s$edu))

#평균값 막대그래프
s <- read.table("d:/r_sample/survey_h.txt", header=T)
mean <- tapply(s$wage,s$gender,mean)
mean
barplot(mean)


# 그래픽(3) 히스토그램 그리기 hist() p225
hist(c(10,12,15,17,19,21,27,30))            # 빈도수 막대 그래프
hist(c(10,12,15,17,19,21,27,30),main="hist의 예제",xlab="x축",ylab="빈도") 
# 라벨과 타이틀 붙이기
legend("topright",legend=c("여자","남자"),fill=c("red","blue"))            
# legend 추가하기

# 그래픽(4)- 파이차트 pie() 
pie(c(15,20,30,40,50))      # 빈도수 파이차트
vect01 <- c(1,1,1,2,2,2,2,2,3,3,4,4,4) # 1(3개), 2(5개), 3(2개), 4(3개)
tab01 <- table(vect01); class(tab01) # table
pie(tab01)
pie(tab01,main="파이차트",labels=c("그룹A","그룹B","그룹C","그룹D","그룹E","그룹F"))

# 그래픽(5)- 함수식 그리기 curve()
curve(sin,-3,3)
xsquare <- function(x) {3*x^2-4*x+5}
curve(xsquare,-15,30)

curve(dnorm,-3,3)

par(mfrow=c(2,3))
curve(sin,-3,3,main="sin 곡선")
curve(cos,-3,3,main="cos 곡선")
curve(tan,-3,3,main="tan 곡선")
curve(dnorm,-3,3,main="정규분포 1")
curve(dnorm,-3,3,main="정규분포 2")
curve(dnorm,-3,3,main="정규분포 3")


# 그래픽(6)- 줄기-잎 그리기 stem()
age    <- c(18,19,24,21,22,23,32,24,25,26)
stem(age)

# 그래픽(7) 상자그림 그리기 - boxplot() p230
plot.new()
par(mfrow=c(1,1))
age    <- c(18,19,24,21,22,23,32,24,25,26)
boxplot(age)
boxplot(age,main="Box 플롯",sub="연령별 Box Pot 분석")
boxplot(age,main="Box 플롯",sub="연령별 Box Pot 분석",horizontal=T)

# 그래픽(8) Q-Q Plot 그리기

par(mfcol=c(1,1))
x <-  rnorm(30)
hist(x)
qqnorm(x)
qqline(x)

# 정규분포그리기
par(mfcol=c(1,1))
curve(dnorm,-3,3)
x <- seq(-3,3,length=100)
plot(x,dnorm(x))
plot(x,dnorm(x),type='l')

#--- 카이자승 분포 그리기
plot.new()
par(mfrow=c(1,3))
x <- seq(0,10,by=0.1)
dchisq(x,df=3)
plot(x,dchisq(x,df=2),type='l',xlim=c(0,10),ylim=c(0,0.25))
plot(x,dchisq(x,df=4),type='l',xlim=c(0,10),ylim=c(0,0.25))
plot(x,dchisq(x,df=6),type='l',xlim=c(0,10),ylim=c(0,0.25))

#--- F 분포 그리기
plot.new()
par(mfrow=c(1,1))
x <- seq(0,4,by=0.1)
df(x,df1=2,df2=4)
#par(mfrow=c(1,1))
par(new=T)
plot(x,df(x,df1=2,df2=4),type='l',xlim=c(0,4),ylim=c(0,1.0))
par(new=T)
plot(x,df(x,df1=4,df2=6),type='l',xlim=c(0,4),ylim=c(0,1.0))
par(new=T)
plot(x,df(x,df1=12,df2=12),type='l',xlim=c(0,4),ylim=c(0,1.0))

### 정규분포 polygon

# 상한 색칠하기
plot.new()
x <- seq(-4,4,length=250)
y <- dnorm(x)
plot(x,y,ylab='dnorm',type='l')   # y 값이 최대값이 0.4 정도
x3 <- seq(1.645,3,length=50)      # qnorm(0.95) = 1.645
y3 <- dnorm(x3)
polygon(c(1.645,x3,3),c(0,y3,0), col='grey')
qnorm(0.95)  #  1.644854  누적치의 확률이 0.95 인 경우의 x 값

# 하한 색칠하기
plot.new()
x <- seq(-4,4,length=250)
y <- dnorm(x)
plot(x,y,ylab='dnorm',type='l')   # y 값이 최대값이 0.4 정도
x3 <- seq(-3,-1,length=50); # qnorm(0.95) = 1.645
y3 <- dnorm(x3)
polygon(c(-3,x3,-1),c(0,y3,0), col='grey')
lines(c(-2.5,-1.5),c(0.1,0.02))  # x 값이 (2.5, 0.1) 에서 (2.1, 0.02) 
text(-2.5,0.115,expression(p==0.15866)) # 알파=0.05 표시

# 중간 확률 색칠하기
plot.new()
x <- seq(-4,4,length=250)
y <- dnorm(x)
plot(x,y,ylab='dnorm',type='l')   # y 값이 최대값이 0.4 정도
x3 <- seq(-1.5,1,length=50); # qnorm(0.95) = 1.645
y3 <- dnorm(x3)
polygon(c(-1.5,x3,1),c(0,y3,0), col='grey')
lines(c(-2,-3),c(0.02,0.1))  # x 값이 (2.5, 0.1) 에서 (2.1, 0.02) 
text(-3,0.115,expression(p==0.066807)) # 알파=0.05 표시

lines(c(-2,0),c(0.3,0.2))  # x 값이 (2.5, 0.1) 에서 (2.1, 0.02) 
text(-2.5,0.3,expression(p==0.77454)) # 알파=0.05 표시

### 카이자승 polygon
plot.new()
#par(mfrow=c(1,2))
x <- seq(0,20,by=0.25)          # x 값 0 ~ 20 까지
plot(x,dchisq(x,5,0),type='l',ylab="p(x)", xlab="x", main="카이자승분포, 자유도 5") 

# 좌편이용
df <- 5
x <- seq(0,1,length=100)
px <- dchisq(x,df)
polygon(c(x,1),c(px,0),col="grey")

# 우편이용
df <- 5
x <- seq(13,20,length=100)
px <- dchisq(x,df)
polygon(c(13,x,20),c(0,px,0),col="grey")

# 라인과 텍스트 넣기
text(0,0.05,expression(over(alpha,2)))  
text(4,0.10,expression(1-alpha))  
text(15,0.03,expression(over(alpha,2)))  
mtext(expression(chi[(list(1-over(alpha,2),n))]^2),side=1, adj=0.5,at=1) 
# 1 지점에 31.25 를 외부에 표시
mtext(expression(chi[(list(over(alpha,2),n))]^2),side=1, adj=0.5,at=13) 
# 1 지점에 31.25 를 외부에 표시
