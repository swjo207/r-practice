#===========================================
# 제7강 R 프로그래밍(2)
#===========================================
#--- 1 조건문과 반복
#--- 2 정렬하기와 순위구하기
#--- 3. table, margin.table,prop.table 함수
#--- 4 sample
#--- 5 날짜다루기
#--- 6 문자다루기
#--- 7 함수다루기

#=== 1. 조건문과 반복문
#--- if 문
x<- 4
if(x >0) y <- sqrt(x)
print(x)
print(y)

x<- -9 
if(x >0) y <- sqrt(x) else { y <- sqrt(-x)}
print(x)
print(y)

x <- -9
ifelse(x >= 0, y <= sqrt(x), y <- sqrt(-x))
print(x)
print(y)

x <- c(3,5,7)
y <- c(4,4,4)
ifelse(x > y, x, y)  # 4,5,7

#--- for 문
sum <- 0
for(i in seq(1,10)) {
  sum <- sum+i
}
print(sum)   # 55

#--- while 문
sum <- 0
i <- 1
while(i <=10) {
  sum <- sum+i
  i <- i+1 
}
print(sum)

sum <- 0
i <- 1
while (i <=30) {
  sum <-sum + i
  if ( i >19) break
  i <- i+1
}
print(sum)  # 210


#=== 2 정렬하기와 순위구하기(p195)
vect01 <- c(11,31,21,41,61,51)
vect01
sort(vect01)
sort(vect01,decreasing=TRUE)
rank(vect01)

vect02 <- c(1,3,3,4,6,5)
rank(vect02)
rank(vect02,ties.method="average")
rank(vect02,ties.method="max")
rank(vect02,ties.method="min")

#=== 3  table, margin.table,prop.table 함수
#--- table
s1 <- read.table("d:/r_sample/survey_h.txt",header=T);s1
(t1 <- table(s1$gender))
class(t1)

(t2 <- table(s1$gender,s1$mar))
class(t2)

(t3 <- table(s1$gender,s1$mar,s1$edu))
class(t3)

#--- margin.table 함수
(mat01 <- matrix(1:6,2,3,byrow=T))
prop.table(mat01,1)
prop.table(mat01,2)

#=== 4 sample (p198)
sample(10)    # 샘플 10개
sample(20)    # 샘플 20개

sample(10,replace=T)  # 복원 허용
set.seed(100)
sample(10,replace=T)
sample(10,3,replace=T)
sample(20,3,replace=T)

#=== 5 문자다루기(p199)
#--- (1) nchar 문자열의 길이
word01 <- 'abcde'
nchar(word01)   # 5
word02 <- c('abc','defg','hihkl')
nchar(word02)   # [1] 3 4 5
length(word02)  # [1] 3

#--- (2) paste 문자열 연결하기
word01 <- 'abc'
word02 <- '123'
paste(word01,word02)          # "abc 123"
paste(word01,word02,sep="-")  # "abc-123"
paste(word01,word02,sep="")   # "abc123"

num01 <- 123
paste(word01,num01)

word12 <- c('abc','def')
word03 <- '456'
paste(word12,word03)   # "abc 456" "def 456"

#--- (3) 문자열 추출하기 substr(문자열,시작위치,끝위치)
word01 <- '12345678'
substr(word01,1,5) # [1] "12345"
substr(word01,2,5) # [1] "2345"
substr(word01,6,2) # [1] ""

#--- (4) 문자열 분할하기 strsplit(문자열, 구분자)
word01 <- '12/345/6789'
strsplit(word01,'/')
#[[1]]
#[1] "12"   "345"  "6789"
class(strsplit(word01,'/')) # list

word01 <- 'a001/123/456'
word02 <- 'b001/12/34/56/78'
strsplit(c(word01,word02),'/')


#--- (4) 문자열 대체하기 sub(기존 문자열, 새문자열, 문자열)
word01 <- '1234512345'
sub("1","a",word01)   # [1] "a234512345" 첫번째 1을 a 로 변환
sub("2","b",word01)   # [1] "1b34512345" 첫번째 2를 b 로 변환
gsub("1","a",word01)  # 1을 전부 a로 변환... [1] "a2345a2345"

sub("1","",word01)    # [1] "234512345" 첫번째 1 제거
gsub("1","",word01)   # [1] "23452345"  1을 전부 제거

#=== 6 날짜다루기(p201)
Sys.Date()          # [1] "2015-06-21"    오늘의 날짜 알아내기 CookBook  
date()              # [1] "Sun Jun 21 14:58:05 2015"
class(Sys.Date())   #  "Date"


format(Sys.time(),"%y년 %m월 %d일") # [1] "15년 06월 21일"
format(Sys.time(),"%Y년 %m월 %d일") # [1] "2015년 06월 21일""

#--- (1) as.Date 함수 이용하기
d1 <- "2013-07-15"
as.Date(d1)        #  [1] "2013-07-15"  Date 개체를 반환했는데, 프린트시 문자형로 변환
as.Date(d1,format="%Y-%m-%d") # [1] "2013-07-15"

d1 <- "2014/07/25"
as.Date(d1)        #  [1] "2014-07-25"

d1 <- "07/25/2014"
as.Date(d1)   # 에러 발생
as.Date(d1,format="%m/%d/%Y") # [1] "2014-07-25"

d1 <-  "130715"
as.Date(d1) # 에러 - 형식이 다름
as.Date(d1,format="%y%m%d") # [1] "2013-07-15"

d1 <-  "20130715"
as.Date(d1) # 에러 - 형식이 다름
as.Date(d1,format="%Y%m%d") # [1] "2013-07-15"

d1 <-  "2013년 7월 15일"
as.Date(d1,format="%Y년 %m월 %d일")  # "2013-07-15"
as.Date(d1,format="%y년 %m월 %d일")  #  소문자 -> NA

as.Date(0,origin="1970-01-01")   # "1970-01-01"
as.Date(1,origin="1970-01-01")   # "1970-01-02"
as.Date(2,origin="1980-01-01")   # "1980-01-03"

#--- (2) as.POSIXct 함수 이용하기
Sys.time()          # [1] "2015-06-21 14:59:28 KST"
class(Sys.time())   # [1] "POSIXct" "POSIXt" 

date01 <- as.POSIXct("2014-07-25 09:05:12")
date01         # [1] "2014-07-25 09:05:12 KST"
# is.list(date01) # FALSE
class(date01) #  "POSIXct" "POSIXt"
str(date01)   #  POSIXct[1:1], format: "2014-07-25 09:05:12"

#--- (3) difftime 함수 이용하기
difftime("2014-07-25","2014-07-30") # Time difference of -5 days
difftime("2014-07-30","2014-07-25") # Time difference of 5 days


#=== 7 함수만들기 (p203)                                 
std_cal <- function(x) {
  var <- sum((x-mean(x))^2)/(length(x)-1)
  std <- sqrt(var)
  return(std)
}

std_cal(c(1,2,3,4,5)) # 1.581139


