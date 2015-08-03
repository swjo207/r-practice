library(gdata);library(WriteXLS);library(sqldf)

#############
# Data Load #
#############
martStartDate<-'2011-01-01'

load("rdt/result.rdata")
load("rdt/h_pt.rdata")
load("rdt/h_rec.rdata")
load("rdt/sql_hr.rdata")
load("rdt/hpt_mart.rdata")

#################################################
# result + sql_hr + kra mart (part of hpt_mart) #
#################################################
hr_2011<-hr_s[hr_s$date > martStartDate,] 
names(sql_hr)
names(hr_2011)
hr_m_t<-sqldf("select a.date, a.round, a.id, a.horse, a.origin, a.sex, a.age, a.weight, a.length, a.type, a.player, a.teacher, a.owner, a.targ, a.o_targ, b.cnt_t, b.avg_rank, b.var_rank, b.max_value, b.p_avg_rnk, b.p_var_rnk, b.p_max_value, b.kurt_rank, b.skew_rank, b.cv_rank, b.min1_rank, b.lh_rank, b.md_rank, b.hl_rank, b.max1_rank, b.mad, b.p_kurt_rank, b.p_skew_rank, b.p_cv_rank, b.p_min1_rank, b.p_lh_rank, b.p_md_rank, b.p_hl_rank, b.p_max1_rank, b.p_mad, b.win_t, b.win_o1, b.win_o2, b.win_o3, b.r_win, b.r_win_o1, b.r_win_o2, b.r_win_o3,b.min_d,b.max_d,b.run,b.period,b.cycle from hr_2011 a left join sql_hr b on (a.horse=b.horse and a.sex=b.sex and a.date=b.sql_hr_dt)")
ind<-which(is.na(hr_m_t$cnt_t))
names(hr_m_t)
if(length(ind)>0) hr_m_t[ind,c(16:48,51:53)]<-0
ind<-which(is.na(hr_m_t$kurt_rank))
if(length(ind)>0) hr_m_t[ind,c(23:25,32:34)]<-0
hr_m_t[ind,]

h_m_org_p<-sqldf("select a.*, b.horses, b.player_rank from hr_m_t a left outer join plyr b on (a.player=b.player and a.date=b.p_dt)")
ind<-which(is.na(h_m_org_p$horses))
if(length(ind)>0) h_m_org_p<-h_m_org_p[-ind,]

h_m_org_t<-sqldf("select a.*, b.players, b.teacher_rank from h_m_org_p a left join tchr b on a.teacher=b.teacher and a.date=b.t_dt")
ind<-which(is.na(h_m_org_t$players))
if(length(ind)>0) h_m_org_t<-h_m_org_t[-ind,]

h_m_org_o<-sqldf("select a.*, b.teachers, b.owner_rank from h_m_org_t a left join ownr b on a.owner=b.owner and a.date=b.o_dt")
ind<-which(is.na(h_m_org_o$teachers))
if(length(ind)>0) h_m_org_o<-h_m_org_o[-ind,]

# kra_mart
h_m_org1 <- sqldf("select a.*,b.tt_game, b.tt_win1, b.tt_win2, b.yr_game, b.yr_win1, b.yr_win2, b.tt_prize_money, b.tt_winning_score, b.tt_win1_rate, b.yr_win1_rate from h_m_org_o a left outer join kra_mart b on (a.date=b.date and a.horse=b.horse and a.sex=b.sex)")
ind <- which(is.na(h_m_org1$tt_game))
names(h_m_org1)
if(length(ind)>0) h_m_org1[ind,c(93:102)] <- 0

# recent hot 
h_mart_90 <- sqldf("select a.*, b.recent_hot hot_90 from h_m_org1 a left outer join hot_90 b on (a.horse=b.horse and a.sex=b.sex and a.date=b.hot_dt_90)")

h_mart_60 <- sqldf("select a.*, b.recent_hot hot_60 from h_mart_90 a left outer join hot_60 b on (a.horse=b.horse and a.sex=b.sex and a.date=b.hot_dt_60)")

h_mart <- sqldf("select a.*, b.recent_hot hot_30 from h_mart_60 a left outer join hot_30 b on (a.horse=b.horse and a.sex=b.sex and a.date=b.hot_dt_30)")

ind <- which(is.na(h_mart$hot_90))
if(length(ind)>0) h_mart[ind,"hot_90"] <- 0
ind <- which(is.na(h_mart$hot_60))
if(length(ind)>0) h_mart[ind,"hot_60"] <- 0
ind <- which(is.na(h_mart$hot_30))
if(length(ind)>0) h_mart[ind,"hot_30"] <- 0

head(h_mart,2)

#############
# + pattern #
#############
names(h_pt)
h_m_wp<-sqldf("select a.*, b.cnt, b.pt4, b.w_diff wd, b.wd_2 wd2 from h_mart a left outer join h_pt b on a.date=b.date and a.horse=b.horse and a.sex=b.sex")

head(h_m_wp,2)

###########
# + h_rec #
###########
names(h_rec[,c(5:106)])
hr_m_wps<-sqldf("select a.*, b.cnt v_cnt, b.v_avg, b.v_med, b.v_min, b.v_max, b.v_std, b.v_max_value, b.v_avg1, b.v_avg2, b.v_avg3, b.v_avg5, b.v_avg7, b.pr_1, b.pr_2, b.pr_3, b.pr_5, b.pr_7, b.s_avg, b.s_med, b.s_min, b.s_max, b.s_std, b.s_max_value, b.s_avg_1, b.s_avg_2, b.s_avg_3, b.s_avg_5, b.s_avg_7, b.s_pr_1, b.s_pr_2, b.s_pr_3, b.s_pr_5, b.s_pr_7, b.g1_avg, b.g1_med, b.g1_min, b.g1_max, b.g1_std, b.g1_max_value, b.g1_avg_1, b.g1_avg_2, b.g1_avg_3, b.g1_avg_5, b.g1_avg_7, b.g1_pr_1, b.g1_pr_2, b.g1_pr_3, b.g1_pr_5, b.g1_pr_7, b.c4_avg, b.c4_med, b.c4_min, b.c4_max, b.c4_std, b.c4_max_value, b.c4_avg_1, b.c4_avg_2, b.c4_avg_3, b.c4_avg_5, b.c4_avg_7, b.c4_pr_1, b.c4_pr_2, b.c4_pr_3, b.c4_pr_5, b.c4_pr_7, b.g3_avg, b.g3_med, b.g3_min, b.g3_max, b.g3_std, b.g3_max_value, b.g3_avg_1, b.g3_avg_2, b.g3_avg_3, b.g3_avg_5, b.g3_avg_7, b.dl_avg, b.dl_med, b.dl_min, b.dl_max, b.dl_std, b.dl_max_value, b.dl_1, b.dl_2, b.dl_3, b.dl_5, b.dl_7, b.h_w_avg, b.h_w_med, b.h_w_min, b.h_w_max, b.h_w_std, b.h_w_max_value, b.h_w_1, b.h_w_2, b.h_w_3, b.h_w_5, b.h_w_7, b.wdf_1, b.wdf_2, b.wdf_3, b.wdf_5, b.wdf_7 from h_m_wp a left outer join h_rec b on a.date=b.date and a.horse=b.horse and a.sex=b.sex")
ind<-which(is.na(hr_m_wps$v_avg))
if(length(ind)>0) hr_m_wps<-hr_m_wps[-ind,]

head(hr_m_wps,2)

ind<-which(hr_m_wps$date > '2014-03-01')
table(hr_m_wps[ind,"date"])

dim(hr_m_wps)

hr_m_wps_p<-sqldf("select a.*, b.plr_dl_avg, b.plr_dl_med, b.plr_dl_min, b.plr_dl_max, b.plr_dl_std, b.plr_dl_max_val from hr_m_wps a left outer join dl_plr b on (a.date=b.plr_dt and a.player=b.player)")
ind<-which(is.na(hr_m_wps_p$plr_dl_avg))
if(length(ind)>0)  hr_m_wps_p<-hr_m_wps_p[-ind,]
ind<-which(hr_m_wps_p$date > '2014-03-01')
table(hr_m_wps_p[ind,"date"])

hr_m_wps_pt<-sqldf("select a.*, b.tcr_dl_avg, b.tcr_dl_med, b.tcr_dl_min, b.tcr_dl_max, b.tcr_dl_std, b.tcr_dl_max_val from hr_m_wps_p a left outer join dl_tcr b on (a.date=b.tcr_dt and a.teacher=b.teacher)")
ind<-which(is.na(hr_m_wps_pt$tcr_dl_avg))
if(length(ind)>0) hr_m_wps_pt<-hr_m_wps_pt[-ind,]

hr_m_wps_pto<-sqldf("select a.*, b.owr_dl_avg, b.owr_dl_med, b.owr_dl_min, b.owr_dl_max, b.owr_dl_std, b.owr_dl_max_val from hr_m_wps_pt a left outer join dl_owr b on (a.date=b.owr_dt and a.owner=b.owner)")
ind<-which(is.na(hr_m_wps_pto$owr_dl_avg))
if(length(ind)>0) hr_m_wps_pto<-hr_m_wps_pto[-ind,]

ind<-which(hr_m_wps_pto$date > '2014-03-01')
table(hr_m_wps_pto[ind,"date"])

dim(hr_m_wps_pto)

##############
# + hpt_mart #
##############
hr_m_wps_r_p<-sqldf("select a.*, b.plr_age, b.plr_wght, b.plr_wght_oth, b.plr_tt_cnt, b.plr_tt_win1, b.plr_tt_win2, b.plr_yr_cnt, b.plr_yr_win1, b.plr_yr_win2 from hr_m_wps_pto a left outer join plr_mart_xls b on (a.date=b.date and a.player=b.player)")
ind<-which(is.na(hr_m_wps_r_p$plr_age))
if(length(ind)>0) hr_m_wps_r_p<-hr_m_wps_r_p[-ind,]

ind<-which(hr_m_wps_r_p$date > '2014-03-01')
table(hr_m_wps_r_p[ind,"date"])

hr_m_wps_r_ps<-sqldf(" select a.*, b.tcr_age, b.tcr_tt_cnt, b.tcr_tt_win1, b.tcr_tt_win2, b.tcr_yr_cnt, b.tcr_yr_win1, b.tcr_yr_win2 from hr_m_wps_r_p a left outer join tcr_mart_xls b on (a.date=b.date and a.teacher=b.teacher)")
ind<-which(is.na(hr_m_wps_r_ps$tcr_age))
if(length(ind)>0) hr_m_wps_r_ps<-hr_m_wps_r_ps[-ind,]

ind<-which(hr_m_wps_r_ps$date > '2014-03-01')
table(hr_m_wps_r_ps[ind,"date"])

dim(hr_m_wps_r_ps)

#####################
# Read and merge dr #
#####################
m_sl_f2011_kr_dr<-sqldf("select a.*, b.dr_s, b.dr_st from hr_m_wps_r_ps a left outer join m_res_xls b on (a.date=b.date and a.round=b.round and a.id=b.id)")

ind<-which(m_sl_f2011_kr_dr$date > '2014-03-01')
table(m_sl_f2011_kr_dr[ind,"date"])

sl_dr<-read.xls("../HR100_Data_Crawling/data/sl_05_dr.xlsx")
str(sl_dr)
sl_dr$date<-as.character(sl_dr$date)

m_sl_f2011_kr<-merge(m_sl_f2011_kr_dr,sl_dr[,c(1,2,6)],by=c("date","round"))
names(m_sl_f2011_kr)
m_sl_f2011_kr[1:20,c(1,2,216)]

###############
# type change #
###############
names(m_sl_f2011_kr)
str(m_sl_f2011_kr[,c("round","origin","sex","type","targ","pt4","wd2")])

m_sl_f2011_kr$targ<-factor(m_sl_f2011_kr$targ)
m_sl_f2011_kr$wd2<-factor(m_sl_f2011_kr$wd2)

str(m_sl_f2011_kr[,c("round","origin","sex","type","targ","pt4","wd2")])

names(m_sl_f2011_kr)

m_sl_f2011<-m_sl_f2011_kr
min(m_sl_f2011$date)
table(m_sl_f2011$origin)
ind<-which(m_sl_f2011$origin=="뉴")
m_sl_f2011$origin[ind]<-"NZ"
ind<-which(m_sl_f2011$origin=="미")
m_sl_f2011$origin[ind]<-"US"
ind<-which(m_sl_f2011$origin=="일")
m_sl_f2011$origin[ind]<-"JP"
ind<-which(m_sl_f2011$origin=="캐")
m_sl_f2011$origin[ind]<-"CA"
ind<-which(m_sl_f2011$origin=="한")
m_sl_f2011$origin[ind]<-"K1"
ind<-which(m_sl_f2011$origin=="한(포)")
m_sl_f2011$origin[ind]<-"K2"
ind<-which(m_sl_f2011$origin=="호")
m_sl_f2011$origin[ind]<-"AU"
m_sl_f2011$origin<-factor(m_sl_f2011$origin,levels=c("NZ","US","JP","CA","K1","K2","AU"))
table(m_sl_f2011$origin)

table(m_sl_f2011$sex)
ind<-which(m_sl_f2011$sex=="거")
m_sl_f2011$sex[ind]<-"NE"
ind<-which(m_sl_f2011$sex=="수")
m_sl_f2011$sex[ind]<-"MA"
ind<-which(m_sl_f2011$sex=="암")
m_sl_f2011$sex[ind]<-"FE"
m_sl_f2011$sex<-factor(m_sl_f2011$sex,levels=c("NE","MA","FE"))
table(m_sl_f2011$sex)

table(m_sl_f2011$type)
ind<-which(m_sl_f2011$type=="국1")
m_sl_f2011$type[ind]<-"K1"
ind<-which(m_sl_f2011$type=="국2")
m_sl_f2011$type[ind]<-"K2"
ind<-which(m_sl_f2011$type=="국3")
m_sl_f2011$type[ind]<-"K3"
ind<-which(m_sl_f2011$type=="국4")
m_sl_f2011$type[ind]<-"K4"
ind<-which(m_sl_f2011$type=="국5")
m_sl_f2011$type[ind]<-"K5"
ind<-which(m_sl_f2011$type=="국6")
m_sl_f2011$type[ind]<-"K6"
ind<-which(m_sl_f2011$type=="혼1")
m_sl_f2011$type[ind]<-"M1"
ind<-which(m_sl_f2011$type=="혼2")
m_sl_f2011$type[ind]<-"M2"
ind<-which(m_sl_f2011$type=="혼3")
m_sl_f2011$type[ind]<-"M3"
ind<-which(m_sl_f2011$type=="혼4")
m_sl_f2011$type[ind]<-"M4"
m_sl_f2011$type<-factor(m_sl_f2011$type,levels=c("K1","K2","K3","K4","K5","K6","M1","M2","M3","M4"))
table(m_sl_f2011$type)

table(m_sl_f2011$pt4)
lvl_pt4<-c("0","00","000","0000","0001","001","0010","0011","01","010","0100","0101","011","0110","0111","1","10","100","1000","1001","101","1010","1011","11","110","1100","1101","111","1110","1111")
m_sl_f2011$pt4<-factor(m_sl_f2011$pt4,levels=lvl_pt4)
table(m_sl_f2011$pt4)

summary(m_sl_f2011[,c("round","origin","sex","type","targ","pt4","wd2")])
str(m_sl_f2011[,c("round","origin","sex","type","targ","pt4","wd2")])

summary(m_sl_f2011)
ind<-which(m_sl_f2011$date > '2014-03-01')
table(m_sl_f2011[ind,"date"])

dim(m_sl_f2011)

##################
# Save data mart #
##################
save(hr_m_wps_r_ps,m_sl_f2011_kr, m_sl_f2011, file="rdt/m_sl_f2011.rdata")
