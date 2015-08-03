library(sqldf);library(gdata);library(party);library(rpart);library(randomForest);library(caret);library(gbm);library(plyr);library(C50);library(class);library(pROC);library(doMC);
registerDoMC(cores=6);

load("../HR200_Data_Mart/rdt/m_sl_f2011.rdata")
load("model/model.rdata")

ind<-which(major$o_targ>=1&major$o_targ<=3)
major$f_targ<-0
major$f_targ[ind]<-1

major$rpp<-predict(mdl_rpartp,newdata=major,type="class")
tr_rpp<-as.numeric(as.character(predict(mdl_rpartp,newdata=major,type="class")))
tr_knn<-as.numeric(as.character(predict(mdl_knn,newdata=major,type="raw")))
tr_c50<-as.numeric(as.character(predict(mdl_C50,newdata=major,type="raw")))
tr_rf<-as.numeric(as.character(predict(mdl_rf,newdata=major,type="raw")))
tr_svm<-as.numeric(as.character(predict(mdl_svmradial,newdata=major,type="raw")))
tr_result<-cbind(tr_rpp, tr_knn, tr_c50, tr_rf, tr_svm, major)

tr_result[1:3,c(1:8,222:223)]

# , count(*), sum(targ)*100/count(*)
sqldf("select rpp, tr_knn, tr_c50, tr_rf, tr_svm, avg(f_targ), count(*) from tr_result group by rpp, tr_knn, tr_c50, tr_rf, tr_svm order by avg(f_targ) desc")

test<-m_sl_f2011[m_sl_f2011$date>=tt_s & m_sl_f2011$date<=tt_e,]
test$rpp<-predict(mdl_rpartp,newdata=test,type="class")

ind<-which(test$o_targ>=1&test$o_targ<=3)
test$f_targ<-0
test$f_targ[ind]<-1

pr_rpp<-as.numeric(as.character(predict(mdl_rpartp,newdata=test,type="class")))
pr_knn<-as.numeric(as.character(predict(mdl_knn,newdata=test,type="raw")))
pr_c50<-as.numeric(as.character(predict(mdl_C50,newdata=test,type="raw")))
pr_rf<-as.numeric(as.character(predict(mdl_rf,newdata=test,type="raw")))
pr_svm<-as.numeric(as.character(predict(mdl_svmradial,newdata=test,type="raw")))

result_1<-cbind(pr_rpp, pr_knn, pr_c50, pr_rf, pr_svm, test)
result_2 <- sqldf("select * from result_1 order by date, round, id")

# accuracy limited by predicted between 4 and 6
accurateByday <- sqldf("select date, count(round) rounds from (select date, round, sum(f_targ) from result_2 where pr_rpp='1' and pr_c50='1' and pr_rf='1' and pr_svm='1' group by date, round having sum(f_targ)=3 and sum(pr_rpp) >= 4 and sum(pr_rpp) <= 6) group by date") 
accurateByround <- sqldf("select date, round from (select date, round, sum(f_targ) targs, sum(pr_rf) predicteds from result_2 where pr_rpp='1' and pr_c50='1' and pr_rf='1' and pr_svm='1' group by date, round having sum(f_targ)=3 and sum(pr_rf) >= 4 and sum(pr_rf) <= 6)") 
hist(accurateByday$rounds)

# money automatically limited by accuracy predicted between 4 and 6
sambokWin<-read.xls("../HR100_Data_Crawling/data/sl_05_dr.xlsx")
str(sambokWin)
sambokWin$date<-as.character(sambokWin$date)
accurateByround$round <- as.integer(accurateByround$round)
sqldf("select * from accurateByround")
moneyByround <- sqldf("select a.date,a.round, sum(Tr_dv) revenue from accurateByround a, sambokWin b where a.date=b.date and a.round=b.round group by a.date, a.round")
moneyByday <- sqldf("select a.date,sum(Tr_dv) revenue from accurateByround a, sambokWin b where a.date=b.date and a.round=b.round group by a.date")

# cost limited by predicted between 4 and 6
result_3<-sqldf("select a.*, b.Tr_dv from result_2 a, sambokWin b where a.date=b.date and a.round=b.round")
costByround <- sqldf("select date, round, count(*) targets, sum(f_targ), Tr_dv from result_3 where pr_rpp='1' and pr_c50='1' and pr_rf='1' and pr_svm='1' group by date, round having targets >= 4 and targets <= 6")
costByround_1 <- sqldf("select date, round, count(*) targets, sum(f_targ), Tr_dv from result_3 where pr_rpp='1' group by date, round")
costMaster <- data.frame(targets=c(3,4,5,6,7),costs=c(1,4,10,20,35))

costByrounds <- sqldf("select a.*, b.costs totalCost from costByround a, costMaster b where a.targets=b.targets")
head(costByrounds)

costByday <- sqldf("select date, sum(totalCost) totalCost from costByrounds group by date")
head(costByday)

Balance <- sqldf("select a.date, b.revenue, a.totalCost from costByday a left outer join moneyByday b on a.date=b.date")
ind<-which(is.na(Balance$revenue))
Balance[ind,2]<-0
Balance$profit<-Balance$revenue-Balance$totalCost
(BalanceByMonth <- sqldf("select substr(date,1,7) month, count(distinct date) bet_days, sum(revenue) revenue, sum(totalCost) cost, sum(profit) profit , sum(profit)/count(distinct date) profitByday, sum(profit)/sum(totalCost)*100 ROI, sum(profit)*count(distinct date)/sum(totalCost)*100 dailyROI from Balance group by substr(date,1,7)"))
