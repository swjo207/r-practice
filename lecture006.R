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
