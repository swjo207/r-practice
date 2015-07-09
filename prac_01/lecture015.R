#===========================================
# 제15강 회귀분석
#===========================================
#--- 1. 회귀분석이란?(p278)
hei <- c(171,173,176,174,175,178)
wei <- c(65,66,69,67,68,69)
lm(wei~hei)
lm_out <- lm(wei~hei)
lm_out
summary(lm_out)

#--- 4. 회귀분석의 예(p284~285) 
x <- c(1,2,3,4,6,7)        
y <- c(21,32,43,56,67,76)
plot(x,y)               
lm(y~x)                  
lm(y~x-1)                
reg_out <- lm(y~x)        
reg_out
summary(reg_out)         

#---5 다중회귀분석

(fa <- c(119,120,130,135,140,119,120,130,135,140,119,120,130,135,140))
(ar <- c(40,35,30,25,15,45,40,35,30,25,50,45,40,35,30))
(y <-  c(50,41,32,24,17,60,54,44,36,31,70,62,58,49,42))
(datad01 <- data.frame(fa,ar,y))
reg1 <- lm(y~fa+ar);summary(reg1)
reg2 <- lm(y~ar);summary(reg2)
reg3 <- lm(y~fa);summary(reg3)


#--- 6. 변수선택법
ox <- read.table("d:/r_sample/corr_ox.txt",header=T)
ox
min.model = lm(oxy ~ 1, data=ox)
full.model <- formula(lm(oxy~.,data=ox))
#step(min.model, direction='forward', scope=full.model)
#step(full.model, data=ox, direction="backward")

step(min.model, scope=list(lower=min.model, upper=full.model), direction="forward")
step(min.model, scope=list(upper=full.model), data=ox, direction="both")

#step(full.model,scope=list(upper=min.model,lower=full.model), direction="backward")


