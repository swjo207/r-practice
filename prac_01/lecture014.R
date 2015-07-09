
#=======================================================
# 제14강 상관분석
#=======================================================
#--- 1 간단한 상관분석 예
#--- 2 설문지 상관분석
#--- 3 산소소모량 데이터 상관분석
#--- 4 OUTPUT 다루기
#--- 5 난수 만들기

?cor  
?cor.test 

#--- 1 상관분석이란?(p272)
hei <- c(155,160,165,170,175)
wei <- c(58,60,63,68,70)
age <- c(21,23,26,34,32)
cor(hei,wei)                    # 0.9884833
cov(hei,wei)                    #  40
cor(hei,wei,method="pearson")   # 0.9884833

cor(hei,wei,age) # 에러
cor(cbind(hei,wei,age))

cor.test(hei,wei)    
cor.test(~hei+wei) # cor.test(hei,wei) 같은 결과
cor.test(~hei+wei+age) # 에러
cor.test(hei~wei)      # 에러

#--- 비모수 상관계수 등
cor.test(hei,wei,method="pearson")
cor.test(hei,wei,method="spearman")
cor.test(hei,wei,method="kendall")


#--- 2 산소소모량 분석
ox <- read.table("d:/r_sample/corr_ox.txt",header=T)
ox
cor(ox)
pairs(ox)

data(iris)
pairs(~Sepal.Length+Sepal.Width+Petal.Length+Petal.Width, data=iris)

#--- 3 설문지 분석
s1  <- read.table(file="d:/r_sample/survey_h.txt",header=TRUE)
s1
plot(sv$age,sv$wage)
cor(sv$age,sv$wage)
cor.test(sv$age,sv$wage)
