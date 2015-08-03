library(gdata);library(WriteXLS);library(sqldf);library(e1071);library(doBy);library(fBasics);library(timeDate);library(raster);library(doMC);library(foreach)
registerDoMC(6)

martStartDate<-'2011-01-01'
t_rnk = 7 # target rank + 1

load("rdt/result.rdata")

hr_s_xls_all<-m_res_xls[,c("date","round","length","type","rank","id","horse","origin","sex","age","weight","player","teacher","owner")]

str(hr_s_xls_all)
max_id<-sqldf("select date, round, max(id) m_id from hr_s_xls_all group by date, round")

hr_s<-sqldf("select a.*, b.m_id from hr_s_xls_all a, max_id b where a.date=b.date and a.round=b.round")

dt_hrsSql<-paste("select distinct(date) from hr_s where date>'",martStartDate,"' order by date desc",sep="")
dt_hrs<-sqldf(dt_hrsSql)
head(dt_hrs);tail(dt_hrs)

##############
# Set target #
##############
hr_s$targ<-NULL
hr_s$o_targ<-NULL
hr_s$targ<-0
hr_s$o_targ<-0
ind <- which(hr_s$rank < t_rnk & hr_s$rank > 0)
hr_s[ind,"targ"] <- 1
hr_s[ind,"o_targ"] <- hr_s[ind,"rank"]
names(hr_s)
hr_ss<-hr_s[,c(1,3,5,7:17)]
hr_ss$pro_rank<-hr_ss$rank/hr_ss$m_id

head(hr_ss)

############################################
# average rank w.r.t jockey, trainer, ownr #
############################################

system.time(
  plyr<-foreach(i=1:nrow(dt_hrs), .combine='rbind') %dopar% {
    ind<-which(hr_s$date<dt_hrs$date[i]&hr_s$date>as.character(as.Date(dt_hrs$date[i])-360))
    hr_s_tmp<-hr_s[ind,]
    p_tmp <- sqldf("select player, count(distinct horse) horses, avg(rank) player_rank from hr_s_tmp group by player");p_dt<-rep(dt_hrs$date[i],nrow(p_tmp))
    return(cbind(p_dt,p_tmp))
  }) # 8~9 sec

system.time(
  tchr<-foreach(i=1:nrow(dt_hrs), .combine='rbind') %dopar% {
    ind<-which(hr_s$date<dt_hrs$date[i]&hr_s$date>as.character(as.Date(dt_hrs$date[i])-360))
    hr_s_tmp<-hr_s[ind,]
    t_tmp <- sqldf("select teacher, count(distinct player) players, avg(rank) teacher_rank from hr_s_tmp group by teacher");t_dt<-rep(dt_hrs$date[i],nrow(t_tmp))
    return(cbind(t_dt,t_tmp))
  })

system.time(
  ownr<-foreach(i=1:nrow(dt_hrs), .combine='rbind') %dopar% {
    ind<-which(hr_s$date<dt_hrs$date[i]&hr_s$date>as.character(as.Date(dt_hrs$date[i])-360))
    hr_s_tmp<-hr_s[ind,]
    o_tmp <- sqldf("select owner, count(distinct teacher) teachers, avg(rank) owner_rank from hr_s_tmp group by owner");o_dt<-rep(dt_hrs$date[i],nrow(o_tmp))
    return(cbind(o_dt,o_tmp))
  })

head(plyr);head(tchr);head(ownr)

#########################################
# mart sql_hr (game_master w.r.t horse) #
#########################################
system.time(
  sql_hr<-foreach(i=1:nrow(dt_hrs), .combine='rbind') %dopar% {
    hr_ss_tmp<-hr_ss[ind,]
    s_hr<-paste("select horse, sex from hr_ss where date = '",dt_hrs$date[i],"' order by horse,sex",sep="")
    hr<-sqldf(s_hr)
    k<-0
    for(j in 1:nrow(hr)){
      ind_hr<-which(hr_ss_tmp$horse==hr$horse[j]&hr_ss_tmp$sex==hr$sex[j])
      if(length(ind_hr)>0){
        k<-k+1
        if (k==1){
          hr_ss_tmp_dt<-hr_ss_tmp[ind_hr,]
        }else{
          hr_ss_tmp_dt<-rbind(hr_ss_tmp_dt,hr_ss_tmp[ind_hr,])
        }
      }
    }
    sql_hr_01<-sqldf("select horse, sex, count(distinct length) length_kind, count(distinct player) player_kind, max(age) age, count(targ) cnt_t, sum(targ) win_t, avg(rank) avg_rank, variance(rank) var_rank, avg(rank)-stdev(rank) max_value, avg(pro_rank) p_avg_rnk, variance(pro_rank) p_var_rnk, avg(pro_rank)-stdev(pro_rank) p_max_value from hr_ss_tmp_dt group by horse, sex order by horse, sex")
    sql_hr_02<-summaryBy(rank~horse+sex,data=hr_ss_tmp_dt,FUN=c(kurtosis,skewness,cv,fivenum,mad))
    colnames(sql_hr_02) <- c('horse','sex','kurt_rank','skew_rank','cv_rank','min1_rank','lh_rank','md_rank','hl_rank','max1_rank','mad')
    sql_hr_03<-summaryBy(pro_rank~horse+sex,data=hr_ss_tmp_dt,FUN=c(kurtosis,skewness,cv,fivenum,mad))
    colnames(sql_hr_03) <- c('horse','sex','p_kurt_rank','p_skew_rank','p_cv_rank','p_min1_rank','p_lh_rank','p_md_rank','p_hl_rank','p_max1_rank','p_mad')
    sql_hr_012<-merge(sql_hr_01,sql_hr_02,by=c("horse","sex"))
    sql_hr_1<-merge(sql_hr_012,sql_hr_03,by=c("horse","sex"))
    sql_hr_o1<-sqldf("select horse, sex, count(o_targ) win_o1 from hr_ss_tmp_dt where o_targ=1 group by horse, sex")
    sql_hr_o2<-sqldf("select horse, sex, count(o_targ) win_o2 from hr_ss_tmp_dt where o_targ=2 group by horse, sex")
    sql_hr_o3<-sqldf("select horse, sex, count(o_targ) win_o3 from hr_ss_tmp_dt where o_targ=3 group by horse, sex")
    sql_hr_1o1<-sqldf("select a.*, b.win_o1 from sql_hr_1 a left outer join sql_hr_o1 b on (a.horse=b.horse and a.sex=b.sex)")
    sql_hr_1o2<-sqldf("select a.*, b.win_o2 from sql_hr_1o1 a left outer join sql_hr_o2 b on (a.horse=b.horse and  a.sex=b.sex)")
    sql_hr_1o3<-sqldf("select a.*, b.win_o3 from sql_hr_1o2 a left outer join sql_hr_o3 b on (a.horse=b.horse and  a.sex=b.sex)")
    horse_d <- sqldf("select horse, sex, min(date) min_d, max(date) max_d, count(*) run from hr_ss_tmp_dt group by horse, sex") # where date<'2014-03-31' 
    horse_d$period <- as.Date(horse_d$max_d) - as.Date(horse_d$min_d)
    horse_d$period <- as.numeric(horse_d$period)
    horse_d$cycle <- horse_d$period / (horse_d$run - 1)
    sql_hr_tmp <- sqldf("select a.*, b.min_d,b.max_d,b.run,b.period,b.cycle from sql_hr_1o3 a left outer join horse_d b on (a.horse=b.horse and a.sex=b.sex)")
    sql_hr_dt<-rep(dt_hrs$date[i],nrow(sql_hr_tmp))
    return(cbind(sql_hr_dt,sql_hr_tmp))
  }) # 1 min 10 sec

head(sql_hr)

ind_o1<-which(is.na(sql_hr$win_o1))
if (length(ind_o1)>0) sql_hr[ind_o1,"win_o1"]<-0
ind_o2<-which(is.na(sql_hr$win_o2))
if (length(ind_o2)>0) sql_hr[ind_o2,"win_o2"]<-0
ind_o3<-which(is.na(sql_hr$win_o3))
if (length(ind_o3)>0) sql_hr[ind_o3,"win_o3"]<-0
ind <- which(is.na(sql_hr$avg_rank))
if (length(ind)>0) sql_hr[ind,"avg_rank"]<-0
sql_hr_bkup<-sql_hr
sql_hr<-na.omit(sql_hr_bkup)
summary(sql_hr)

sql_hr$r_win<-0
sql_hr$r_win<-sql_hr$win_t/sql_hr$cnt_t
sql_hr$r_win_o1<-0
sql_hr$r_win_o1<-sql_hr$win_o1/sql_hr$cnt_t
sql_hr$r_win_o2<-0
sql_hr$r_win_o2<-sql_hr$win_o2/sql_hr$cnt_t
sql_hr$r_win_o3<-0
sql_hr$r_win_o3<-sql_hr$win_o3/sql_hr$cnt_t
sql_hr$sql_hr_dt<-as.character(sql_hr$sql_hr_dt)

head(sql_hr)

########################
# recent hot (3 min)
########################
str(dt_hrs)
system.time(
  hot_90<-foreach(i=1:nrow(dt_hrs), .combine='rbind') %dopar% {
    ind<-which(hr_s$date<dt_hrs$date[i])
    hr_s_tmp<-hr_s[ind,]
    s_dt_90<-as.character(as.Date(dt_hrs$date[i])-90)
    s_hot_90<-paste("select horse, sex, count(rank) recent_hot from hr_s_tmp where date > '",s_dt_90,"' and rank<",t_rnk," group by horse, sex",sep="")
    hot_tmp_90 <- sqldf(s_hot_90)
    hot_dt_90<-rep(dt_hrs$date[i],nrow(hot_tmp_90))
    return(cbind(hot_dt_90,hot_tmp_90))
  })

system.time(
  hot_60<-foreach(i=1:nrow(dt_hrs), .combine='rbind') %dopar% {
    ind<-which(hr_s$date<dt_hrs$date[i])
    hr_s_tmp<-hr_s[ind,]
    s_dt_60<-as.character(as.Date(dt_hrs$date[i])-60)
    s_hot_60<-paste("select horse, sex, count(rank) recent_hot from hr_s_tmp where date > '",s_dt_60,"' and rank<",t_rnk," group by horse, sex",sep="")
    hot_tmp_60 <- sqldf(s_hot_60)
    hot_dt_60<-rep(dt_hrs$date[i],nrow(hot_tmp_60))
    return(cbind(hot_dt_60,hot_tmp_60))
  })

system.time(
  hot_30<-foreach(i=1:nrow(dt_hrs), .combine='rbind') %dopar% {
    ind<-which(hr_s$date<dt_hrs$date[i])
    hr_s_tmp<-hr_s[ind,]
    s_dt_30<-as.character(as.Date(dt_hrs$date[i])-30)
    s_hot_30<-paste("select horse, sex, count(rank) recent_hot from hr_s_tmp where date > '",s_dt_30,"' and rank<",t_rnk," group by horse, sex",sep="")
    hot_tmp_30 <- sqldf(s_hot_30)
    hot_dt_30<-rep(dt_hrs$date[i],nrow(hot_tmp_30))
    return(cbind(hot_dt_30,hot_tmp_30))
  })

hot_90$hot_dt_90<-as.character(hot_90$hot_dt_90)
hot_60$hot_dt_60<-as.character(hot_60$hot_dt_60)
hot_30$hot_dt_30<-as.character(hot_30$hot_dt_30)

head(hot_90);head(hot_60);head(hot_30)

save(hr_s,plyr,tchr,ownr,hr_ss,sql_hr,hot_90,hot_60,hot_30,file="rdt/sql_hr.rdata")
