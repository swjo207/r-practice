#####################################
# 3.5  caret 패키지를 이용한 모델링 #
#####################################

## (1) 패키지 설치 및 load

# install.packages("caret", dependencies = c("Depends", "Suggests"))

## (2) 모델링

# for MAC
# install.packages("doMC")
library(doMC)
registerDoMC(cores=6)

# for Windows
# install.packages("doParallel")
# library(doParallel)
# registerDoParallel(6)

load("data/3yr_data_04to13.rdata")
myFormula<-v04_D_YN~.

library(caret)
set.seed(2020)

# Train the Model

(system.time(ctreeFit_901 <- train(myFormula,data=T_901_rF, method="ctree")))
# on the MacBook Pro (Core i7, 16 GB memory)

ctreeFit_901
confusionMatrix(ctreeFit_901)

# Visualization
names(ctreeFit_901)
plot(ctreeFit_901$finalModel)

# Predict the Model
pred_ctree<-predict(ctreeFit_901,newdata=T_012_rF)
confusionMatrix(pred_ctree,T_012_rF$v04_D_YN,positive="1")

impVar_ctree<-varImp(ctreeFit_901)
plot(impVar_ctree,top=15,cex=2)

## (3) 2014년 예측 모델링

set.seed(2020)
# Train the Model
(system.time(ctreeFit_012 <- train(myFormula,data=T_012_rF, method="ctree")))
ctreeFit_012
confusionMatrix(ctreeFit_012)

# Predict the Model
pred_ctree<-predict(ctreeFit_012,newdata=T_123_rF)
confusionMatrix(pred_ctree,T_123_rF$v04_D_YN,positive="1")

impVar_ctree<-varImp(ctreeFit_012)
plot(impVar_ctree,top=15,cex=2)
