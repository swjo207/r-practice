
## section 1 
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

# section 2 
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

# section 3
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

knit("statistics001.Rmd")
markdownToHTML("statistics001.md","statistics001.html",options=c("use_html"))
system("pandoc -s statistics001.html -o statistics001.pdf")
