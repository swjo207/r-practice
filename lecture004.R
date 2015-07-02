##
##  7강-- R 프로그래밍 (2)
##
## 1. 조건문과 반복문 
## 2. 정렬하기와 순위구하기 
## 3. table 함수 
## 4. margin.table 함수와 prop.table 함수 
## 5. sample 함수 
## 6. 문자열 다루기 
## 7. 날짜 다루기 
## 8. 함수 만들기 

##=== 1. 조건문과 반복문 

## 1.1 조건문 
x<- 4
if(x>0) y <- sqrt(x)
print(x)
print(y)

x<- -9 
if(x>0) y<-sqrt(x) else {y<-sqrt(-x)}
print(x); print(y)

x<- c(3,5,7)
y<- c(4,4,4)
ifelse(x>y,x,y) 

## 1.2 반복문 
sum <- 0
for(i in seq(1,10)) {
  sum <- sum+i 
}
sum

sum <- 0
i <- 1
while(i<=10) {
  sum <- sum+i
  i <i+1
}
sum



word01 <- '12/345/5689'
sp <- strsplit(word01,'/')
class(sp)
sp[[1]][1]
nchar(sp)
 
Sys.Date()
date()
class(Sys.Date())

format (Sys.time(), "%y, %m %d")


std_cal <- function(x) {
  var <- sum((x-mean(x))^2)/(length(x)-1)
  std <- sqrt(var)
  return (std)
}
std_cal (rnorm(1000))
