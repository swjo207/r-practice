#===========================================
# 제3강 패키지
#===========================================
#---1~3 패키지 살펴보기(p131)
library() # 설치된 패키지 보기
search()  # 메모리에 로드된 패키지 보기
library(MASS)  # 패키지 로드하기
search()
detach(package:MASS) # 패키지 언로드하기
search()
library(ggplot2)
install.packages("ggplot2") # 패키지 설치하기
library(ggplot2)
#detach(package:ggplot2)        
#library()
remove.packages("ggplot2") # 패키 지제거하기

#--- 4 패키지내 데이터셋 살펴보기(p135)
data()  # datasets 패키지에 Nile, Titanic
data(package="MASS")
library(MASS)
#--- iris 구조살펴보기(p136)
data(iris)
class(iris)
dim(iris)
length(iris)
names(iris)
colnames(iris)
str(iris)
head(iris)
tail(iris)
head(iris,n=10)
iris[3]  #세번째 변수
iris[1:5,]
iris[1:5,"Sepal.Length"]
iris$Sepal.Length[1:5]
summary(iris)
help(iris)
var(iris$Sepal.Length)  #(p138)
hist(iris$Sepal.Length)
plot(iris$Sepal.Length,iris$Sepal.Width)
table(iris$Species)
tab01 <- table(iris$Species)
class(tab01)


example(lm) # 샘플프로그램 실행하기
lm # 소스보기
