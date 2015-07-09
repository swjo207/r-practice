

#===========================================
# 제4강 R 데이터 객체(벡터,행렬,데이터프레임)
#===========================================
#--- 1.데이터의 유형(p141)
a <- c(1,2,3);a
typeof(a)

b <- c(1L,2L,3L);b
typeof(b)

c <- c(1+2i,2,3);c
typeof(c)

d <- c(1,"2","3");d
typeof(d)

e <- c(TRUE,FALSE);e
typeof(e)

3 > 4

f <- c(1+2i,2,'3');f
typeof(f)

#--- 3. 벡터 다루기(p143)
# concatenate 함수 이용하기

c(1,2,3,4,5)
c(1:10)                       # 1에서 10까지
(vec01 <- c(1:10))            # 1에서 10까지 벡터 vec01 만들기

-5:5                          # -5에서 5까지
5:-5                          # 5에서 -5까지
c(1:5,7:10)                   # 1에서 5, 7에서 10까지
c('one','two','three')        # 문자형 벡터만들기
c("'one","two","three")       # 문자형 벡터만들기
c(1,2,'one','two','three')    # 숫자형과 문자형을 합치면
(vec02 <- c(10,20,30,vec01))  # 벡터를 연결하면


# seq 함수 이용하기
seq(1,6)
seq(from=1,to=6)              # seq(from=1,to=6,by=1)   
seq(from=3,to=-3,by=-1)       # 3부터 -3 까지
seq(0.5,4.6)                  # [1] 0.5 1.5 2.5 3.5 4.5 

seq(from=1,to=10,by=2)        # 1,3,5,7,9 만들기
seq(from=1,to=2,by=0.3)       # 1.0 부터 1.9 까지
seq(from=1,to=10,length=4)    # 1부터 10까지 4개의 원소, 1,4,7,10  (10-1)/3 간격
seq(from=1,to=19,length=5)    #  (19-1)/4 즉 4.5 간격으로 5개

# rep 함수 이용하기
rep(3,6)
rep(c(1,2),6)
rep(3,times=6)                # 3,3,3,3,3,3   3을 6번 반복하여 만들기
rep(c(1,2),times=6)           # 1,2 1,2 ... 1,2 1,2  1,2를 6번 반복하여 12개 원소

# 벡터의 속성 살펴보기
vec01 <- c(1:10) ; vec01 # 벡터 v1 을 만들기
class(vec01)          # integer
length(vec01)         # 10
str(vec01)            # 벡터의 구조를 출력
attributes(vec01)     # NULL 
head(vec01)           # 앞 6개 요소를 출력
is.vector(vec01)      # TRUE
mode(vec01)           # "numeric"
is.list(vec01)        # FALSE

vec01_c <- c('one','two','three') # 문자로 구성된 벡터만들기
mode(vec01_c)         # "character"
class(vec01_c)        # "character“ 

# 벡터 결합하기 
# c() 함수 이용하기
vec01 <- c(1,2,3,4,5)
vec100 <- c(100,200,300,400,500)
(vec101 <- c(vec01,vec100))

# 숫자형 벡터와 문자형벡터를 합치기 - 문자열
(vec01 <- c(1,2,3,4,5))
(cvec01 <- c("one","two","three","four","five"))
(cnvec1 <- c(vec01,cvec01))

# 벡터 결합하기(행렬) 
#--- cbind,rbind 이용하기
vec01 <- c(1,2,3,4,5)
vec100 <- c(100,200,300,400,500)
(rvec101 <- rbind(vec01,vec100))
class(rvec101) # matrix
mode(rvec101)  # numeric 

vec01 <- c(1,2,3,4,5)
vec100 <- c(100,200,300,400,500)
(cvec101 <- cbind(vec01,vec100));cvec101
class(cvec101) # matrix
mode(cvec101)  # numeric 
length(cvec101)

# 크기가 다른 벡터를 결합하기
vec02 <- c(1,2,3,4,5,6)
vec300 <- c(100,200,300)
rvec302 <- rbind(vec02,vec300); rvec302
cvec302 <- cbind(vec02,vec300); cvec302

# 위치번호로 요소 접근하기 -- [ ](p146)
vec01 <- c(10,20,30,40,50,60,70)
vec01[3]           # 3 번째 요소
vec01[c(3,5)]      # 3 번째 요소
vec01[(3,5)]       # 에러

vec01[3:5]         # 3~5 째 요소
vec01[c(3:5)]      # 3~5 째 요소

vec01[-3]          # 3 번째 요소 제외하기
vec01[-c(3,5)]     # 3 번째, 5번째 요소 제외하기
vec01[-(2:3)]      # 2~3 번째 요소 제외하기

vec01 <- c(10,20,30,40,50,60,70)
vec01[3] <- 5;vec01      # 벡터 3번째 요소에 3을 할당
vec01[7] <- 77; vec01


# 이름으로 접근하기

#요소에 이름 붙이기
vec01 <- c(10,20,30,40,50,60,70); vec01
names(vec01) <- c("sun","mon","tue","wed","thu","fri","sat")
vec01

# 이름으로 접근하기
vec01["wed"]
vec01[c("tue","thu")]

# 벡터 연산하기(p147)
vec01 <- c(1,2,3,4,5) 
vec100 <- c(100,200,300,400,500)
vec01+3    
vec01*3    
vec100+vec01  
vec100-vec01  
vec100*vec01  
vec01/vec100  

# 벡터의 차수가 다른 경우
vec01 <- c(1,2,3,4,5,6) 
v200 <- c(100,200,300)

(v201 <- vec01+v200) # 길이가 다른 벡터 더하기

# 기술통계량 구하기(p148)
vec01 <- c(1:10)     # 벡터 v1 을 만들기
sum(vec01)             # 합계구하기
mean(vec01)            # 평균구하기
vec01-mean(vec01)         # 평균과의 차이구하기
median(vec01)          # 중앙값 구하기
min(vec01)             # 최소값 구하기
max(vec01)             # 최대값 구하기
sd(vec01)              # 표준편차 구하기
var(vec01)             # 분산 구하기
range(vec01)           # 최소값과 최대값 구하기
diff(range(vec01))     # 범위구하기
quantile(vec01)        # 4분위수 구하기
IQR(vec01)             # 4분위수 범위 Q3-Q1
summary(vec01)         # 요약통계 구하기

# NA(Not Available)와 NULL 처리하기
mean(c(1,2,3,4,5))               # 평균값 3
mean(c(1,2,NA,3,4,5))            # NA Not Available
mean(c(1,2,NA,3,4,5),na.rm=TRUE) # 평균값 3

#--- 4. 행렬다루기(p149)

# 벡터에서 cbind 또는 rbind 하기

vec01 <- c(1,2,3,4,5)
vec02 <- c(10,20,30,40,50)
vec03 <- c(100,200,300,400,500)
(mat01 <- cbind(vec01,vec02,vec03))
(mat02 <- rbind(vec01,vec02,vec03))

# matrix 이용하기

(mat01 <- matrix(c(1,2,3,4,5,6),2,3))
vec01 <- c(1,2,3,4,5,6); 
(mat01 <- matrix(vec01,2,3)) 
(mat01 <- matrix(c(1,2,3,4,5,6),ncol=3))
(mat01 <- matrix(c(1,2,3,4,5,6),nrow=3))
(mat01 <- matrix(c(1,2,3,4,5,6),ncol=3,byrow=T))
(mat01 <- matrix(c(1,2,3,4,5,6),2,3,byrow=T))
summary(mat01)

(mat0 <- matrix(0,2,3))  # 0 행렬만들기
(mat5 <- matrix(5,2,3))


# 행렬의 속성 살펴보기

(mat01 <- matrix(c(1,2,3,4,5,6),2,3))
class(mat01)      # matrix
mode(mat01)       # "numeric"
length(mat01)     # 6
head(mat01)       # 앞 6개 요소를 출력
str(mat01)        # 행렬의 구조를 출력
dim(mat01)        # 행렬의 차원 (2 3) 벡터로

# 행렬원소 접근하기
mat01 <- matrix(c(1,2,3,4,5,6),nrow=2,byrow=T);mat01

# 한 원소만 지정하기
mat01[2:5]    # 3~5 째 요소 ( 4 2 5 3)
mat01[1,c(1,3)]  

mat01[2]   # [1] 1
mat01[2:4] # [1] 4 2 5

# 원소의 범위를 지정하기

mat01[,3]     # 열 3  (3 6) 
mat01[1,]     # 행 1  ( 1 2 3)
mat01[2]      # 2 번째 요소 (4)
mat01[2,2:3]  # 2번째 행, 2-3 요소(5,6)


# 특정 원소 제외하기 
mat01[,-3]    # 열 3 제외하기
mat01[,-(2:3)] # 열 2~3 제외하기, 1행만 남음


#--- 행렬에 이름 붙이기
mat01 <- matrix(c(1,2,3,4,5,6),nrow=2,byrow=T);mat01
colnames(mat01) <- c("col01","col02","col03"); mat01
mat01[,"col01"] # [1] 1 4


# 행렬 연산하기
#  행렬 더하기, 빼기

m1 <- matrix(c(1,2,3,4,5,6),nrow=2,byrow=T);m1
m100 <- matrix(c(100,200,300,400,500,600),nrow=2,byrow=T);m100
m1+3       # 
m1*3       # 
m1+m100    # 
m1-m100    #  
m1*m100    # element product 
m1 %*% t(m1) # (2 by 3)  X (3 by 2)
m1/m100 # 

m22 <- matrix(c(100,200,300,400),nrow=2,byrow=T);m22
mp22 <- m1+m22; mp22 # 차원다른 행렬더하기, 당연 에러 

# 전치행렬, 역행렬 구하기

m1 <- matrix(c(1,2,3,4,5,6),nrow=2,byrow=T);m1
mt1 <- t(m1)    ; mt1  # transpose
md1 <- diag(m1) ; md1  # get diagonal element
m1 <- matrix(c(1,2,3,4),nrow=2,byrow=T);m1
minv1 <- solve(m1) ; minv1  

m1 %*% minv1

# apply(x,MARGIN,FUN,...)
m1 <- matrix(c(1,2,3,4,5,6),nrow=2,byrow=T);m1
#apply(x, 1 또는 2, 함수이름)

apply(m1,1,sum)        #   행렬 m1 에 대하여 행단위로 합계를 구한다
apply(m1,2,sum)        #   행렬 m1 에 대하여 열단위로 합계를 구한다
apply(m1,1,min)        #   행렬 m1 에 대하여 열단위로 합계를 구한다
apply(m1,1,max)        #   행렬 m1 에 대하여 열단위로 합계를 구한다
apply(m1,1,mean)       #   행렬 m1 에 대하여 열단위로 합계를 구한다
apply(m1,1,range)      #   행렬 m1 에 대하여 열단위로 합계를 구한다
apply(m1,1,quantile)   #   행렬 m1 에 대하여 열단위로 합계를 구한다
apply(m1,1,prod)       #   행렬 m1 에 대하여 열단위로 합계를 구한다
apply(m1,1,sort,decreasing=TRUE) 
apply(m1,dim=c(2,2,3))


#--- 5. 데이터 프레임 다루기
id  <- c('A001','A002','A003','A004','A005')
gender <- c('F','F','F','M','M')
wei <- c(58,60,63,68,70)
hei <- c(155,160,165,170,175)
age <- c(23,24,38,43,40)
dataf01 <- data.frame(id,gender,wei,hei,age); dataf01
str(dataf01)  # id, gender 가 Factor 로 지정
dataf01$gender

mat01 <- matrix(7,2,3); mat01
dataf02 <- as.data.frame(mat01) ; dataf02 

# 외부파일 불러오기    
dataf03 <- read.table("d:/r_sample/survey_h.txt",header=T)
dataf03
class(dataf03)    # dataframe           #  데이터프레임의 속성 살펴보기
mode(dataf03)     # list
length(dataf03)   # 10
dim(dataf03)
str(dataf03) 

head(dataf03)     # gender hei wei 앞 6개 요소를 출력
head(dataf03,n=7)
head(dataf03,7)

# 리스트 만들기      
(vec01 <- 3:8)
(mat01 <- matrix(1:6,2,3))
(list01 <- as.list(vec01))
(list02 <- as.list(mat01))
(list03 <- as.list(dataf03))

vec01 <- c(1,2,3)
vec10 <- c(10,20,30,40)
vec100 <- c(100,200,300,400,500)
(list01 <- list(vec01,vec10,vec100))

is.list(list01)        # TRUE
is.vector(list01)      # TRUE
is.data.frame(list01)  # FALSE

list01
list01[2]
list01[[2]]


dataf02 <- data.frame(id,gender,hei,stringsAsFactors=FALSE); dataf02
str(dataf02)  # id, gender 가 chr 로 지정
dataf02$gender

dataf02$gender <- factor(dataf02$gender)  # gender를 factor 로 지정
str(dataf02)  
dataf02$gender

#dataf02$gender <- as.character(dataf02$gender)  # gender를 factor 로 지정
#dataf02$gender


#---  벡터에서 행렬 만들기(matrix, as.matrix)
(vec12 <- 1:12); (vec24 <- 1:24)
(mat12 <- as.matrix(vec12))          # 12 by 1 행렬로 만들기 

#--- 배열이나 데이터프레임에서도 as.matrix 이용 가능
(vec06 <- 1:6); (vec60 <- seq(10,60,by=10))
(mat34 <- matrix(1:12,3,4, byrow=T))



#--- 타입 변환 확인하기 
is.matrix(mat12)    # TRUE
is.array(mat12)     # TRUE

#--- 배열로 변환하기(array, as.array) - 배열을 벡터와 행렬과 모양이 같은데...
(arr12 <- as.array(vec12))
(arr34 <- as.array(mat34))
(arr46 <- array(vec24,c(4,6)))
(arr234 <- array(vec24,c(2,3,4)))

is.vector(arr12)   # FALSE    # 모양은 vector 과 같은데 vector 는 아니라고...
is.array(arr12)    # TRUE
is.matrix(arr12)   # FALSE

is.array(arr34)    # TRUE
is.matrix(arr34)   # TRUE
is.array(arr234)   # TRUE
is.matrix(arr234)  # FALSE

#--- 데이터프레임 변환하기(as.data.frame)
(dataf01 <- as.data.frame(vec12))
(dataf0 <-  as.data.frame(mat34))


# 행렬에서 하나를 추출했을때 벡터이다...
(mat01 <- matrix(1:6,2,3,byrow=T))
mat01_1 <- mat01[1,]; mat01_1   
is.vector(mat01_1)  # TRUE
is.matrix(mat01_1)  # FALSE

mat01_d <- mat01[1,,drop=FALSE]  # 
mat01_d
is.vector(mat01_d)  # FALSE
is.matrix(mat01_d)  # TRUE


#-데이터프레임에서 하나를 추출했을때 벡터이다...
hei <- c(155,160,165,170,175,170,169)
wei <- c(58,60,63,68,70,66,67)
age <- c(30,32,25,29,50,34,43)
(dataf01 <- data.frame(hei,wei,age))
dataf02 <- dataf01[,1]
dataf02

is.vector(dataf02)      # TRUE
is.data.frame(dataf02)  # FALSE

dataf03 <- dataf01[,1,drop=F]
is.vector(dataf03)      # FALSE
is.data.frame(dataf03)  # TRUE
