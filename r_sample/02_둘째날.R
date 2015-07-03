#===========================================
# 제6강 R 프로그래밍(1)
#===========================================
#--- 1 외부파일 읽어오기
#--- 2 조건에 맞는 요소추출하기
#--- 3 데이터 추출하기 - subset, which
#--- 4 merge
#--- 5 aggregate
#--- 6 apply 함수 이용, lapply, sapply, tapply

#=== 1 외부파일 읽어오기(p173)
#--- 1.1 텍스트파일 읽어오기 - read.table() 

#--- header 있는 경우
s1 <- read.table("d:/r_sample/survey_h.txt",header=T);
s1

#--- header 없는 경우(Default)
s2 <- read.table("d:/r_sample/survey_n.txt"); 
s2   
names(s2) <- c("id","gender","mar","age","edu","his","work","pay","wage","hob")
s2

(s2 <- read.table("d:/r_sample/survey_n.txt",
  col.names=c("id","gender","mar","age","edu","his","work","pay","wage","hob")))

#--- 구분자가 | 인 경우 - Default(header=FALSE) p174
s3 <- read.table(file="d:/r_sample/survey_s.txt",sep="|",header=T);
s3

#--- 구분자가 Tab 인 경우 - Default(header=FALSE)
s4 <- read.table(file="d:/r_sample/survey_t.txt",sep="\t",header=T);
s4


#--- 1.2 csv 파일 읽어오기 - read.csv()
s3 <- read.csv(file="d:/r_sample/survey_h.csv") ;
s3
s4 <- read.csv(file="d:/r_sample/survey_n.csv",header=FALSE);
s4

#--- csv 파일로 쓰기 - write.csv()
s3 <- read.csv(file="d:/r_sample/survey_h.csv") 
s3
s4 <- s3
s4$sat <- s4$work + s4$pay
s4
write.csv(s4,"d:/r_sample/survey_write.csv")  # 행번호가 생김
write.csv(s4,"d:/r_sample/survey_write_01.csv",row.names=F) # 행번호가 없도록


#--- 1.3 엑셀파일읽어오기
install.packages("xlsx")
library(xlsx)
s5 <- read.xlsx("d:/r_sample/survey_h.xlsx",1);
s5
s6 <- read.xlsx("d:/r_sample/survey_h.xlsx",sheetIndex=1);
s6
s7 <- read.xlsx("d:/r_sample/survey_h.xlsx",sheetName="survey_h");
s7

#--- 1.4 sas 데이터셋 읽어오기
install.packages("sas7bdat")
library(sas7bdat)
sasr <- read.sas7bdat("d:/r_sample/survey.sas7bdat")
sasr

#--- 1.5 spss 에러가 남
install.packages("foreign")
library(foreign)
?read.spss

spssr <- read.spss("d:/r_sample/survey7_0.sav")

#=== 2. 조건에 맞는 요소추출하기(p177)
vec01 <- c(100,200,300,400,500)
vec01[vec01<=300]

vec01[c(T,T,T,F,F)] 

cond <- vec01 <=300
cond
vec01[cond]

# 문자열을 이용한 원소추출
gender <- c('F','F','M','M','F')
gender=='F'         # [1]  TRUE  TRUE FALSE FALSE  TRUE
gender[gender=='F'] # [1] "F" "F" "F"


# 조건에 따라 벡터 값 변경하기(p178)
vec01 <- -2:5; vec01
vec02 <- ifelse(vec01>3,0,vec01)
vec02

# 정규분포를 따르는 0 보다 큰 난수 추출하기
set.seed(100)
x=rnorm(20); x        # 난수 발생
id <- x>0             # 난수 중에서 0보다 크면 TRUE, 아니면 FALSE
id
x[id]                   # 0 보다 큰 난수 발생 


#=== 3 데이터 추출하기 - subset, which (p179)

s1 <- read.table("d:/r_sample/survey_h.txt",header=T)
s1
#     id gender mar age edu his work pay wage hob
#1  A001      M   1  18   2   1    4   5   42   1
#2  A002      F   1  19   2   1    5   5   42   3
#3......

#--- 3.1 변수 선택
s1[c("age","wage")] # 데이터프레임에서 변수명만 지정
subset(s1,select=age)
subset(s1,select=c("age","wage"))

#--- 3.2 조건을 이용하기 (p180)
s1[s1$wage>50,]   
s1[s1$gender == "M",]

subset(s1,wage >50)               # subset 함수 이용하기
subset(s1,wage >50, select=c("id","gender","wage"))  

#--- 3.3 조건을 이용하기- which 
v1 <- c(2,4,6,5,1)
which(v1 == max(v1))    # 최대값의 위치 3번째
which.max(v1)           # 최대값 위치

#=== 4 Merge
#--- (1) 양쪽 id 가 동일한 경우

# (1) dataf.A 만들기
(dataf.A <- data.frame(
  id = c("A01","A02","A03","A04"),
  hei=c(161,162,163,164)))

# (1) dataf.B 만들기
(dataf.B <- data.frame(
   id = c("A01","A02","A04","A03"),
   wei= c(71,72,74,73)))

#=====================================
merge(dataf.A,dataf.B) 
# 공통으로 들어있는 변수 id 순으로 정렬... 변수명 id, hei, wei
merge(dataf.B,dataf.A) # 되지 않았는데도... 변수명은 id, wei, hei
#=====================================

merge(dataf.A,dataf.B,by="id")  # # merge(dataf.A,dataf.B) 와 같은 결과 
merge(dataf.B,dataf.A,by="id")


#--- (2) 양쪽 데이터 갯수가 다른 경우
# (2) dataf.AC 만들기 - A 에 관측치 하나 추가(5개)
(dataf.AC <- data.frame(
  id = c("A01","A02","A03","A04","C01"),
  hei=c(161,162,163,164,181)))

# (2) dataf.B_3 만들기
id <- c("A01","A02","A04","D01")
wei <- c(71,72,74,81)
(dataf.B_3 <- data.frame(id,wei))

#=====================================
merge(dataf.AC,dataf.B_3) 
# A 5개, B 4개 인 경우, 공통 3개로 ... id 순으로 정렬... 변수명 id, hei, wei
#=====================================

# (3) merge, all=T 옵션 사용 : 6개 전부
merge(dataf.AC,dataf.B_3,all=T) 

merge(dataf.AC,dataf.B_3,all.x=T) # 5개 dataf.AC 중심

merge(dataf.AC,dataf.B_3,all.y=T) # 4개 dataf.B_3 중심

# (4) 다른 변수명으로 Merge

# (4) dataf.A 만들기
(dataf.A <- data.frame(
  id = c("A01","A02","A03","A04"),
  hei=c(161,162,163,164)))

# (4) dataf.Bid 만들기
(dataf.Bid <- data.frame(
  id_new = c("A01","A02","A04","A03"),
  wei = c(71,72,74,73)))

=====================================
merge(dataf.A,dataf.Bid,by.x="id",by.y="id_new")  
merge(dataf.Bid,dataf.A,by.x="id_new",by.y="id")  
#=====================================

# (5) 동일 id 중복 Merge
# (5) dataf.A 만들기
(dataf.A <- data.frame(
  id = c("A01","A02","A03","A04"),
  hei=c(161,162,163,164)))

# (5) dataf.B33 만들기
id <- c("A01","A02","A04","A03","A03")
wei <- c(71,72,74,73,83)
(dataf.B33 <- data.frame(id,wei))

merge(dataf.A,dataf.B33)  

# (6) 공통변수가 없는 경우
(dataf.A <- data.frame(
  id = c("A01","A02","A03","A04"),
  hei=c(161,162,163,164)))

(dataf.Bid <- data.frame(
  id_new = c("A01","A02","A04","A03"),
  wei = c(71,72,74,73)))

merge(dataf.A,dataf.Bid) 

#=== 5 aggreate (p188)
s1 <- read.table("d:/r_sample/survey_h.txt",header=T);s1
s2 <- s1
#(s_mean <-aggregate(s2$wage,list(s2$gender),mean))
(s_mean <-aggregate(s2$wage,list(gender=s2$gender),mean))


merge(s2,s_mean,by="gender")
#s2$id <- s2$gender <- NULL


#=== 6 apply 함수 이용(p189)
#--- apply 함수 적용
mat01 <- matrix(c(1,2,3,4,5,6),nrow=2,byrow=T);mat01
apply(mat01,1,sum)        # 6 15   행렬 m1 에 대하여 행단위로 합계를 구한다
apply(mat01,2,sum)        # 5 7 9  행렬 m1 에 대하여 열단위로 합계를 구한다
apply(mat01,1,min)        # 1 4  
apply(mat01,1,max)        # 3 6  
apply(mat01,1,mean)       #   
apply(mat01,1,range)      #   
apply(mat01,1,quantile)   #   

#--- colSums, rowSums(p190)
(mat01 <- matrix(c(1,2,3,4,5,6),nrow=2,byrow=T))
colSums(mat01)
rowSums(mat01)
colMeans(mat01)
rowMeans(mat01)

#--- 데이터프레임 요소가 모두 숫자인 경우(p191)
(s1 <- read.table(file="d:/r_sample/survey_h.txt",header=T))
apply(s1,1,sum)  # 에러
apply(s1,2,sum)  # 에러

s2 <- s1
s2$id <- s2$gender <- NULL
s2
apply(s2,1,sum)
apply(s2,2,sum)

# 배열에 apply 적용
names(s2) <- NULL

arr01 <- as.array(s2)
apply(arr01,1,sum)   
apply(arr01,2,sum)  

#--- lapply, sapply, tapply 함수 이용
# 데이터프레임에 lapply 적용
(s1 <- read.table(file="d:/r_sample/survey_h.txt",header=T))
s2 <- s1
s2$id <- s2$gender <- NULL
lapply(s2,sum,na.rm=T)  # 리스트 형태
sapply(s2,sum,na.rm=T)  # 벡터 형태
tapply(s2$wage,as.factor(s2$mar),sum,na.rm=T)  

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


#===========================================
# 8강 SQL (p206)
#===========================================
install.packages("sqldf")
library(sqldf)
?sqldf

s <- read.table("d:/r_sample/survey_h.txt", header=TRUE); s
#class(sqldf("select * from s")) # data.frame 
#mode(sqldf("select * from s"))  # list 

sqldf("select * from s")  # p206
sqldf("select id,gender,wage from s")
sqldf("select id,gender,wage from s limit 5")
sqldf("select id,gender,wage from s order by age") # p206 데이터정렬
sqldf("select id,gender,wage from s order by gender,age") # 변수2개 정렬
sqldf("select id,gender,wage from s order by 2,3")  # p207 변수gender,age
sqldf("select id,gender,wage from s order by gender,age desc ") #p208 남여별, 연령 내림차순

# SQL – where
sqldf("select * from s where gender = 'F'")  #p209
sqldf("select * from s where gender <> 'F'")
sqldf("select * from s where wage >= 60") #p210
sqldf("select * from s where id >= 'A036' AND wage >= 60")
sqldf("select * from s where id >= 'A036' OR wage >= 60")
sqldf("select * from s where wage between 50 and 60")  # p211

# SQL - in 연산자
sqldf("select * from s where id in('A001','A036')") #p212
sqldf("select * from s where id in(select id from s where wage>60)")
sqldf("select * from s where  wage>60")

# 와일드카드 % p213
sqldf("select * from s where id like 'A%'")  # A로 시작하는 전부
sqldf("select * from s where id like 'A01%'")
sqldf("select * from s where id like '%3%'")
sqldf("select * from s where id like 'A%7'")

# SQL – where, order by  필터링 후, 정렬 p215
sqldf("select * from s where id >= 'A036' AND wage >= 60 order by age")

sqldf("select id,his,work,pay,his+work+pay from s") # 계산식
sqldf("select id,his,work,pay,his+work+pay as sat from s")

sqldf("select sum(wage), avg(wage) as m_wge from s") # 기술통계 구하기 P216
sqldf("select count(wage) from s")  # 빈도수 구하기

sqldf("select sum(wage), avg(wage) as m_wge from s group by gender") # group by p219

sqldf("select sum(wage), avg(wage)  from s group by gender having sum(wage) > 900")
# where 절은 그룹화하기전.... having 절은 데이터를 그룹화한 뒤에 
# where 절에 제외된 것은 그룹에 포함되지 않음
# where 절로 대상을 먼저 제외하고, group by 로 대상에 한해 그룹화한 다음
# having 절로 각 그룹을 필터링한다


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
