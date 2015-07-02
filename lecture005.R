##
##  9강-- 그래픽 다루기 
##


## 1.그래픽 그리기 

## 2. 2차원 그래프 - plot


## 3. 막대그래프 - barplot 


## 4. 히스토그램 - hist


## 5. 파이차트 - pie
pie(c(15,20,30,40,50))



## 6. 함수식 그리기 - curve 
curve(sin,-3,3)
curve(dnorm,-3,3)

par(mfrow=c(2,3))
curve(sin)

## 7. 줄기 잎 그리기 
age <- c(18,19,24,21,22,23,32,24,25,26)
stem(age)

## 8. 박스 그리기 
boxplot(age)
boxplot(age,main="box plot",sub="연령별 box plot 분석")
boxplot(age,horizontal=T,main="box plot",sub="연령별 box plot 분석")

## 9. QQ plot 그리기 
x <- rnorm(30)
hist(x)
qqnorm(x)
qqline(x)

