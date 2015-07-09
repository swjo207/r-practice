#===========================================
# 제1강 R 설치와 기본사용법
#===========================================
#--- 2.3 R프로그램 - 회귀분석(p102)
(hei <- c(171,173,176,174,175,178))
(wei <- c( 65, 66, 69, 67, 68, 69))
lm(wei~hei)
lm_out <- lm(wei~hei)
lm_out
summary(lm_out)


#--- 4.2 실습(p106) 
#(1) 연산자 및 함수 실습하기
1+3
2^3
8/3
(4-2)*3; 12-2*5
sqrt(2)
sqrt(-2)
log(10)
exp(2)
pi
date()
max(1,3,4,7)

#(2) 변수할당 실습하기
x <-3
x
y <- 3; y <- y+2
y

#(3) 비교연산자
x <- 1
y <- 2
if (x > y) c <- 1 else  c<-2
c

#(4) | , &&연산자
x <- 1
y <- 2
if (x == 1 | y== 1) c <- "둘중 하나가 1" else c <- "모두 1이 아님"
c

#(5) 벡터 실습하기(p107)
2:7
x <- 2:7; x
(x <-2:7)
x <- c(1,3,5);x
xc <- c("one","two","three"); xc
x <- c(1,2,3,"one","two"); x

seq(2,7,by=2)
seq(from=2,to=7,by=2)

#(6) 통계함수 실습하기
x <- c(3,4,5,7)
mean(x)
sum(x) 
length(x)
sum(x)/length(x)
min(x)
range(x)
cumsum(x)

#(7) 기타 

ls()
rm(list=ls())
getwd()  #  "C:/Users/joinos/Documents"
setwd("d:/r_sample")
dir.create("d:/r_sample2")

#-- 참고: DB 진흥원 R 온라인 강좌 



