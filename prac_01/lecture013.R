#===========================================
# 제13강 분산분석법(ANOVA)
#===========================================
#--- 1. 분산분석법이란?(p263)
x=c(74,76,79,80,82,81)
y=c(75,76,77,78,76,82)
z=c(76,74,73,70,78,74)
(gr<-c(rep(1,6),rep(2,6),rep(3,6)))
(score <- c(x,y,z))
(agg <- data.frame(score,gr))

#--- aggregate 
aggregate(score,data.frame(gr),mean)
aggregate(score,data.frame(gr),var)

#--- aov
aov(score~factor(gr),data=agg)  # 분산분석표 안 보임

#--- 분산분석표 결과 보기
out <- aov(score~factor(gr),data=agg)  
summary(out)

#--- 사후비교
TukeyHSD(out)

#--- boxplot
boxplot(score~gr)

