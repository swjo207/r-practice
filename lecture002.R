#===========================================
# 제2강 R 과 통계학
#===========================================
#--- 8.1 엑셀로 하는 통계분석 산책(p122)
# 회귀분석
wei <- c(58,60,63,68,70)
hei <- c(155,160,165,170,175)
age <- c(23,24,38,43,40)
dataf01 <- data.frame(wei,hei,age)
lm(wei~hei+age)
lm_out <- lm(wei~hei+age)
summary(lm_out)

# 상관분석(p125)
cor(hei,wei)  # 상관계수 값만
cor.test(wei,hei)  # t 값, 자유도 등
cor.test(wei,hei,age) # 에러 
cor.test(wei,age)
cor.test(hei,age)
cor(dataf01)   # 상관계수 행렬만

cor.test(~wei+hei,data=dataf01)

# 분산분석법(p126)
x=c(74,76,79,80,82,81)
y=c(75,76,77,78,76,82)
z=c(76,74,73,70,78,74)
(gr<-c(rep(1,6),rep(2,6),rep(3,6)))
(score <- c(x,y,z))
(tot <- data.frame(score,gr))

aggregate(score,data.frame(gr),mean)
aov(score~factor(gr),data=tot)  
anova(aov(score~factor(gr),data=tot)) # 분산분석표를 구함 

# t 검정(p128)
x=c(74,76,79,80,82,81)
y=c(75,76,77,78,76,82)
t.test(x,y,var.equal=T)  