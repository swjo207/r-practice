library(gdata);library(sqldf)

##############
# Horse mart #
##############
cls_kra<-c(rep("character",18))
kra_mart <- read.xls("../HR100_Data_Crawling/data/sl_01_horse.xlsx", colClasses=cls_kra)

kra_mart$age<-as.numeric(kra_mart$age)
kra_mart$group<-as.numeric(kra_mart$group)
kra_mart$tt_game<-as.numeric(kra_mart$tt_game)
kra_mart$tt_win1<-as.numeric(kra_mart$tt_win1)
kra_mart$tt_win2<-as.numeric(kra_mart$tt_win2)
kra_mart$yr_game<-as.numeric(kra_mart$yr_game)
kra_mart$yr_win1<-as.numeric(kra_mart$yr_win1)
kra_mart$yr_win2<-as.numeric(kra_mart$yr_win2)
kra_mart$tt_prize_money<-as.numeric(kra_mart$tt_prize_money)
kra_mart$tt_winning_score<-as.numeric(kra_mart$tt_winning_score)

kra_mart$tt_win1_rate<-0
ind<-which(kra_mart$tt_game>0)
kra_mart$tt_win1_rate[ind]<-kra_mart$tt_win1[ind]/kra_mart$tt_game[ind]
kra_mart$yr_win1_rate<-0
ind<-which(kra_mart$yr_game>0)
kra_mart$yr_win1_rate[ind]<-kra_mart$yr_win1[ind]/kra_mart$yr_game[ind]

head(kra_mart)

###############
# Jockey mart #
###############
cls_plr<-c(rep("character",14))
plr_mart_xls<-read.xls("../HR100_Data_Crawling/data/sl_02_player.xlsx",colClasses=cls_plr)

plr_mart_xls$plr_age<-as.numeric(plr_mart_xls$plr_age)
plr_mart_xls$plr_wght<-as.numeric(plr_mart_xls$plr_wght)
plr_mart_xls$plr_wght_oth<-as.numeric(plr_mart_xls$plr_wght_oth)
plr_mart_xls$plr_tt_cnt<-as.numeric(plr_mart_xls$plr_tt_cnt)
plr_mart_xls$plr_tt_win1<-as.numeric(plr_mart_xls$plr_tt_win1)
plr_mart_xls$plr_tt_win2<-as.numeric(plr_mart_xls$plr_tt_win2)
plr_mart_xls$plr_yr_cnt<-as.numeric(plr_mart_xls$plr_yr_cnt)
plr_mart_xls$plr_yr_win1<-as.numeric(plr_mart_xls$plr_yr_win1)
plr_mart_xls$plr_yr_win2<-as.numeric(plr_mart_xls$plr_yr_win2)

head(plr_mart_xls)

################
# Trainer mart #
################
cls_tcr<-c(rep("character",12))
tcr_mart_xls<-read.xls("../HR100_Data_Crawling/data/sl_03_trainer.xlsx",colClasses=cls_tcr)

tcr_mart_xls$tcr_age<-as.numeric(tcr_mart_xls$tcr_age)
tcr_mart_xls$tcr_tt_cnt<-as.numeric(tcr_mart_xls$tcr_tt_cnt)
tcr_mart_xls$tcr_tt_cnt<-as.numeric(tcr_mart_xls$tcr_tt_cnt)
tcr_mart_xls$tcr_tt_win1<-as.numeric(tcr_mart_xls$tcr_tt_win1)
tcr_mart_xls$tcr_tt_win2<-as.numeric(tcr_mart_xls$tcr_tt_win2)
tcr_mart_xls$tcr_yr_cnt<-as.numeric(tcr_mart_xls$tcr_yr_cnt)
tcr_mart_xls$tcr_yr_win1<-as.numeric(tcr_mart_xls$tcr_yr_win1)
tcr_mart_xls$tcr_yr_win2<-as.numeric(tcr_mart_xls$tcr_yr_win2)

head(tcr_mart_xls)

save(kra_mart,plr_mart_xls,tcr_mart_xls,file="rdt/hpt_mart.rdata")
