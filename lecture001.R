##
## section 1 
##
# packages
require(knitr)
require(markdown)

# list installed packages
library()
# list packages loaded on memory
search()
# install package
install('package name')
# load a package
library('package name')
# remove a package
remove.packages('package name')
# unload from a memory
detach(package:'package name')
# help 
help(package='package name')

##
## section 2 
##
# data-set
data()
data(package='MASS')
data("iris")  # iris loading
class(iris) # data type
dim(iris)   # data dimension
length(iris)  # length of variables
names(iris)   # names of variables
colnames(iris)
str(iris)   # structure of data 
attributes(iris)  # attributes of data
head(iris)
tail(iris)
head(iris,n=15)
iris[1:5,]  # 5 items with a row-index from 1 to 5
iris[1:5,"Sepal.Length"]
iris$Sepal.Length[1:5]

# 2.1 iris 구조 살펴보기 
summary(iris)

# 2.2 iris 분석하기  
var(iris$Sepal.Length)  
table(iris$Species)

hist(iris$Sepal.Length)
plot(iris$Sepal.Length,iris$Sepal.Width)

##
## section 3
##
# 샘플 프로그램 실행, 소스보기 

example(lm) # 샘플 프로그램 실행하기 
lm          # 프로그램 소스보기 

# ex
hei <- c(171,173,176,174,175,178)
wei <- c(65,66,69,67,68,69)
lm(wei~hei)
lm_out <- lm(wei~hei)
lm_out
summary(lm_out)

#knit("statistics001.Rmd")
#markdownToHTML("statistics001.md","statistics001.html",options=c("use_html"))
#system("pandoc -s statistics001.html -o statistics001.pdf")

##
## section 4 
##

# 4.1 데이터를 이루는 데이터형 

# 수치형, 논리형, 복소수형, 문자형 
a <- c(1,2,3)
typeof(a)
b <- c(1L,2L,3L)
typeof(b)
c <- c(1+2i,2,3)
typeof(c)
d <- c("1","2","3")
typeof(d)
e <- c(TRUE,FALSE)
typeof(e)
3 > 4
f <- c(1+2i,2,"3")
typeof(f)

# 4.2 데이터 객체 

# 4.3 벡터 다루기 

# 1) 벡터 만들기와 속성 살펴보기 
# concatenate
c(1:5)
(vec01 <- c(1:10))
-5:5
c(1:5,7:10)
c('one','two','three')
c(1,2,'one','two','three')
vec02 <- c(10,20,30,vec01)
vec02
# seq function
seq(1,6)
seq(from=1,to=6)
seq(from=1,to=2,by=0.3)
seq(from=1,to=10,length=4)
seq(from=1,to=19,length=5)
# rep function
rep(3,6)
rep(c(1,2),6)
rep(3,times=6)
rep(c(1,2),times=6)
# attribute
vec01 <- c(1:10)
class(vec01)
length(vec01)
str(vec01)
head(vec01)
is.vector(vec01)
mode(vec01)
is.list(vec01)
vec01_c <- c('one','two','three')
mode(vec01_c)
class(vec01_c)

# 2) 벡터 결합하기 
# vector join
vec01 <- c(1:5)
vec100 <- seq(100,500,length=5)
(vec101 <- c(vec01,vec100))
# 숫자형과 문자형 결합 
vec01 <- c(1:5)
cvec01 <- c('one','two','three','four','five')
cnvec01 <- c(vec01, cvec01)
cnvec01
# vector join with matrix
rvec101 <- rbind(vec01,vec100)
rvec101
class(rvec101)
mode(rvec101)
# different size 
vec02 <- c(1:6)
vec300 <- c(100,200,300)
rvec302 <- cbind(vec02,vec300)
rvec302

# 3) 벡터 원소 접근하기 [] 
vec01 <- seq(10,70,by=10)
vec01[3]
vec01[c(3,5)]
vec01[3:5]
vec01[c(3:5)]
vec01[-3]
vec01[-c(3,5)]
vec01[-(2:4)]
vec01[3] <- 5
vec01[7] <- 77
vec01

# 4) 벡터 연산하기 - recycling 
# 위치번호로 요소 접근하기 
vec01+3
vec01*3
vec01+vec100
vec100-vec01
vec100*vec01
vec100/vec01
#different dimmension
vec01 <- c(1:5)
vec200 <- c(100,200,300)
vec201 <- vec01+vec200
vec201
# 이름으로 접근하기 
vec01 <- seq(10,70,by=10); vec01
names(vec01) <- c('sum','mon','tue','wed','thu','fri','sat')
vec01
vec01['wed']
vec01[c('mon','sat')]

# 5) 벡터 기초통계량 구하기 
sum(vec01)
mean(vec01)
vec01 - mean(vec01)
median(vec01)
min(vec01)
max(vec01)
sd(vec01)
var(vec01)
range(vec01)
diff(range(vec01))
quantile(vec01)
IQR(vec01)
summary(vec01)
mean(c(1,2,3,4,5))
t_na <- c(1,2,NA,3,4,5)
mean(t_na)
mean(t_na,na.rm=T)

# 4.4 행렬 다루기 
# 1) 행렬 만들기, 속성 살펴보기 
# cbind, rbind from vector 
vec01 <- c(1:6)
vec02 <- seq(10,60,by=10)
vec03 <- seq(100,600,by=100)
mat01 <- cbind(vec01,vec02,vec03)
# matrix 
(mat01 <- matrix(c(1:6),2,3))

# 2) 행렬 원소 접근하기 

# 3) 행렬 연산하기 
m1 <- matrix(c(1:6), nrow=2,byrow=T); m1
m100 <- matrix(seq(100,600,by=100),nrow=2,byrow=T); m100
m1 +3 
m1 *3
m1 + m100
m1 %*% t(m1)
m1 / m100
m1 * m100

mt1 <- t(m1); mt1
md1 <- diag(m1); md1
ms1 <- matrix(c(1:9), nrow=3); ms1
m_inv <- solve(ms1); m_inv

apply(m1,1,sum)
apply(m1,2,sum)
apply(m1,1,quantile)
apply(m1,1,prod)



# 4.5 데이터프레임

# 4.6 리스트 
(vec01 <- 3:8)
mat01 <- matrix(1:6,2,3); mat01
list01 <- as.list(vec01)
list01 <- as.list(mat01)

is.list(list01)
is.vector(vec01)



# 4.7 팩터 

# 4.8 