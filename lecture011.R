#===========================================
# 제11강 R 설치와 기본사용법
#===========================================
#--- 1. 카이자승법이란?(p248)

#--- (1) 카이자승법 예제
#           스포츠  음악감상  독서  여행
# 여자(F)   15       35       20    25
# 남자(M)   25       40       30    20 
#
#gender <- c("F","F","F","F","M","M","M","M") 
#hob <- c(1,2,3,4,1,2,3,4)

count <- c(15,35,20,25,25,40,30,20)

#--- (2) 빈도수를 행렬형태로 바꾼다...
x <- matrix(count,byrow=T,ncol=4);x
#[1,]   15   35   20   25
#[2,]   25   40   30   20

chisq.test(x)



#--- 2. 카이자승법 확률계산
pchisq(3.516,3) # [1] 0.6813071
1-pchisq(3.516,3)

#--- 3. 카이자승법 그림그리기
plot.new()
par(mfrow=c(1,1))
x <- seq(0,7,by=0.25)          # x 값 0 ~ 20 까지
plot(x,dchisq(x,3,0),type='l',ylab="p(x)", xlab="x", main="카이자승분포, 자유도 5") 

# 좌편이용
df <- 3
x <- seq(0,3.516,length=100)
x3 <- dchisq(x,df)
polygon(c(0,x,3.516),c(0,x3,0),col="grey")

lines(c(2,4),c(0.16,0.22))  # x 값이 (2.5, 0.1) 에서 (2.1, 0.02) 
text(5,0.23,expression(p==0.3187)) # 알파=0.05 표시

#--- 적합도검정(p250)
chisq.test(c(8,9,10,13),p=c(10,10,10,10)/40)

#--- 3. 설문지(p251) 
s <- read.table("d:/r_sample/survey_h.txt",header=T);s
s1 <- s
s1$nhob <- s1$hob
s1$nhob <- ifelse(s1$hob ==1 | s1$hob ==3 | s1$hob ==6, 1, s1$nhob)
s1$nhob <- ifelse(s1$hob ==2 | s1$hob ==4 | s1$hob ==5 | s1$hob ==7, 2,s1$nhob)
s1$nhob <- ifelse(s1$hob ==8, NA,s1$nhob)
s1
s1_tab  <- table(s1$gender,s1$nhob)
s1_tab
chisq.test(s1_tab)
pchisq(1.2371,1) # [1]  0.7339693
1-pchisq(1.2371,1) # [1] [1] 0.2660307

#---학력별 회사만족도 
s2_tab  <- table(s1$edu,s1$work)
s2_tab
chisq.test(s2_tab)
fisher.test(s2_tab)

#--- 5. 고려사항 --- gmodels 를 이용한 경우
install.packages("gmodels")
library(gmodels)
CrossTable(s1$gender,s1$nhob,digits=3,expected=T,chisq=T,prop.r=T)
CrossTable(s1$gender,s1$nhob,digits=3,expected=T,chisq=T,prop.r=T,format="SAS")
CrossTable(s1$gender,s1$nhob,digits=3,expected=T,chisq=T,prop.r=T,format="SPSS")

CrossTable(s1$edu,s1$work,digits=3,expected=T,chisq=T,prop.r=T)

x <- (c(rep(1,25),rep(2,40),rep(3,30),rep(4,20),
        rep(1,15),rep(2,35),rep(3,20),rep(4,25)))
y <- (c(rep('M',115),rep('F',95)))
#  xy <- data.frame(x,y)
CrossTable(y,x,digits=3,expected=T,chisq=T,prop.r=T)

