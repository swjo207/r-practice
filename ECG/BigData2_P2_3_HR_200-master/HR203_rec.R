library(gdata);library(WriteXLS);library(sqldf);library(e1071);library(doBy);library(fBasics);library(timeDate);library(raster);library(doMC);library(foreach)
registerDoMC(6)

martStartDate<-'2011-01-01'
thisMonday<-'2014-05-26'

################
# rec by horse #
################

load("rdt/result.rdata")
head(m_res_xls)

# read past result
max_id<-sqldf("select date, round, max(id) m_id from m_res_xls group by date, round")
m_res_xls_pr<-sqldf("select a.*, b.m_id from m_res_xls a, max_id b where a.date=b.date and a.round=b.round")

# create percentage rank
m_res_xls_pr$pr_rnk<-m_res_xls_pr$rank/m_res_xls_pr$m_id
m_res_xls_pr$s_pr_rnk<-m_res_xls_pr$S1F_rnk/m_res_xls_pr$m_id
m_res_xls_pr$g1_pr_rnk<-m_res_xls_pr$G1F_rnk/m_res_xls_pr$m_id
m_res_xls_pr$c4_pr_rnk<-m_res_xls_pr$C4_rnk/m_res_xls_pr$m_id

head(m_res_xls_pr)

# create time difference w.r.t the 1ist
min_velocity<-sqldf("select date, round, min(h_rec) min_vc from m_res_xls group by date, round")
h_rec_dl<-sqldf("select a.*, b.min_vc from m_res_xls_pr a left outer join min_velocity b on (a.date=b.date and a.round=b.round)")

h_rec_dl$delay<-h_rec_dl$h_rec-h_rec_dl$min_vc
head(h_rec_dl)

names(h_rec_dl)
h_rec_res<-h_rec_dl[,-c(2:6,8,10:14,25:27)]
# h_rec_res<-h_rec_dl[,c("horse","sex","date","h_rec","S1F","G1F","C4","S1F_rnk","G1F_rnk","C4_rnk","h_w","h_wd","pr_rnk","s_pr_rnk","g1_pr_rnk","c4_pr_rnk","min_vc","delay")]
h_rec_t<-h_rec_res
h_rec_wo<-sqldf("select * from h_rec_t order by horse, sex, date desc")

head(h_rec_wo)

# create derived variables
dtSql<-paste("select distinct(date) from h_rec_wo where date > '",martStartDate,"' order by date desc",sep="")
dt<-sqldf(dtSql)
head(dt);tail(dt)

# approx. 2 min from 2011
system.time(
h_rec<-foreach(i=1:nrow(dt), .combine='rbind') %dopar% {
  ind<-which(h_rec_wo$date<dt$date[i])
  h_rec_dt<-h_rec_wo[ind,]
  s_hr<-paste("select horse, sex from h_rec_wo where date = '",dt$date[i],"' order by horse,sex",sep="")
  hr<-sqldf(s_hr)
  k<-0
  for(j in 1:nrow(hr)){
    ind_hr<-which(h_rec_dt$horse==hr$horse[j]&h_rec_dt$sex==hr$sex[j])
    if(length(ind_hr)>0){
      k<-k+1
      if (k==1){
        h_rec_tmp<-h_rec_dt[ind_hr,]
      }else{
        h_rec_tmp_j<-rbind(h_rec_tmp,h_rec_dt[ind_hr,])
        h_rec_tmp<-h_rec_tmp_j
      }
    }
  }
  h_rec_tmp$no<-1
  if(nrow(h_rec_tmp)>1){
    for (j in 2:nrow(h_rec_tmp)) {
      if (h_rec_tmp$horse[j-1]==h_rec_tmp$horse[j]&h_rec_tmp$sex[j-1]==h_rec_tmp$sex[j]) {
        h_rec_tmp$no[j]<-h_rec_tmp$no[j-1]+1
      }
    }
  }
  h_spd_avg_1<-sqldf("select horse, sex, max(no) cnt, avg(h_rec) v_avg, median(h_rec) v_med, min(h_rec) v_min, max(h_rec) v_max, stdev(h_rec) v_std, avg(h_rec)-stdev(h_rec) v_max_value, avg(S1F) s_avg, median(S1F) s_med, min(S1F) s_min, max(S1F) s_max, stdev(S1F) s_std, avg(S1F)-stdev(S1F) s_max_value, avg(G1F) g1_avg, median(G1F) g1_med, min(G1F) g1_min, max(G1F) g1_max, stdev(G1F) g1_std, avg(G1F)-stdev(G1F) g1_max_value, avg(C4) c4_avg, median(C4) c4_med, min(C4) c4_min, max(C4) c4_max, stdev(C4) c4_std, avg(C4)-stdev(C4) c4_max_value, avg(G3F) g3_avg, median(G3F) g3_med, min(G3F) g3_min, max(G3F) g3_max, stdev(G3F) g3_std, avg(G3F)-stdev(G3F) g3_max_value, avg(h_w) h_w_avg, median(h_w) h_w_med, min(h_w) h_w_min, max(h_w) h_w_max, stdev(h_w) h_w_std, avg(h_w)-stdev(h_w) h_w_max_value, avg(delay) dl_avg, median(delay) dl_med, min(delay) dl_min, max(delay) dl_max, stdev(delay) dl_std, avg(delay)-stdev(delay) dl_max_value from h_rec_tmp group by horse, sex")
#   head(h_spd_avg_1,1) # verif
  h_spd_avg_v<-summaryBy(h_rec~horse+sex,data=h_rec_tmp,FUN=c(kurtosis,skewness,cv,fivenum,mad))
  colnames(h_spd_avg_v) <- c('horse','sex','v_kurt','v_skew','v_cv','v_min1','v_lh','v_md','v_hl','v_max1','v_mad')
  h_spd_avg_s<-summaryBy(S1F~horse+sex,data=h_rec_tmp,FUN=c(kurtosis,skewness,cv,fivenum,mad))
  colnames(h_spd_avg_s) <- c('horse','sex','s_kurt','s_skew','s_cv','s_min1','s_lh','s_md','s_hl','s_max1','s_mad')
  h_spd_avg_g1<-summaryBy(G1F~horse+sex,data=h_rec_tmp,FUN=c(kurtosis,skewness,cv,fivenum,mad))
  colnames(h_spd_avg_g1) <- c('horse','sex','g1_kurt','g1_skew','g1_cv','g1_min1','g1_lh','g1_md','g1_hl','g1_max1','g1_mad')
  h_spd_avg_c4<-summaryBy(C4~horse+sex,data=h_rec_tmp,FUN=c(kurtosis,skewness,cv,fivenum,mad))
  colnames(h_spd_avg_c4) <- c('horse','sex','c4_kurt','c4_skew','c4_cv','c4_min1','c4_lh','c4_md','c4_hl','c4_max1','c4_mad')
  h_spd_avg_g3<-summaryBy(G3F~horse+sex,data=h_rec_tmp,FUN=c(kurtosis,skewness,cv,fivenum,mad))
  colnames(h_spd_avg_g3) <- c('horse','sex','g3_kurt','g3_skew','g3_cv','g3_min1','g3_lh','g3_md','g3_hl','g3_max1','g3_mad')
  h_spd_avg_1v<-merge(h_spd_avg_1,h_spd_avg_v,by=c("horse","sex"))
  h_spd_avg_1vs<-merge(h_spd_avg_1v,h_spd_avg_s,by=c("horse","sex"))
  h_spd_avg_1vsg1<-merge(h_spd_avg_1vs,h_spd_avg_g1,by=c("horse","sex"))
  h_spd_avg_1vsg1c4<-merge(h_spd_avg_1vsg1,h_spd_avg_c4,by=c("horse","sex"))
  h_rec_avg<-merge(h_spd_avg_1vsg1c4,h_spd_avg_g3,by=c("horse","sex"))
  ind<-which(h_rec_tmp$no<8)
  h_rec_a7<-h_rec_tmp[ind,]
  h_rec_avg7<-sqldf("select horse h7, sex, avg(h_rec) avg_7, avg(S1F) s_avg_7, avg(G1F) g1_avg_7, avg(C4) c4_avg_7, avg(G3F) g3_avg_7, avg(delay) dl_7, avg(h_w) h_w_7, sum(h_wd) wdf_7, avg(pr_rnk) pr_7, avg(s_pr_rnk) s_pr_7, avg(g1_pr_rnk) g1_pr_7, avg(c4_pr_rnk) c4_pr_7 from h_rec_a7 group by horse, sex")
  ind<-which(h_rec_tmp$no<6)
  h_rec_a5<-h_rec_tmp[ind,]
  h_rec_avg5<-sqldf("select horse h5, sex, avg(h_rec) avg_5, avg(S1F) s_avg_5, avg(G1F) g1_avg_5, avg(C4) c4_avg_5, avg(G3F) g3_avg_5, avg(delay) dl_5, avg(h_w) h_w_5, sum(h_wd) wdf_5, avg(pr_rnk) pr_5, avg(s_pr_rnk) s_pr_5, avg(g1_pr_rnk) g1_pr_5, avg(c4_pr_rnk) c4_pr_5 from h_rec_a5 group by horse, sex")
  ind<-which(h_rec_tmp$no<4)
  h_rec_a3<-h_rec_tmp[ind,]
  h_rec_avg3<-sqldf("select horse h3, sex, avg(h_rec) avg_3, avg(S1F) s_avg_3, avg(G1F) g1_avg_3, avg(C4) c4_avg_3, avg(G3F) g3_avg_3, avg(delay) dl_3, avg(h_w) h_w_3, sum(h_wd) wdf_3, avg(pr_rnk) pr_3, avg(s_pr_rnk) s_pr_3, avg(g1_pr_rnk) g1_pr_3, avg(c4_pr_rnk) c4_pr_3 from h_rec_a3 group by horse, sex")
  ind<-which(h_rec_tmp$no<3)
  h_rec_a2<-h_rec_tmp[ind,]
  h_rec_avg2<-sqldf("select horse h2, sex, avg(h_rec) avg_2, avg(S1F) s_avg_2, avg(G1F) g1_avg_2, avg(C4) c4_avg_2, avg(G3F) g3_avg_2, avg(delay) dl_2, avg(h_w) h_w_2, sum(h_wd) wdf_2, avg(pr_rnk) pr_2, avg(s_pr_rnk) s_pr_2, avg(g1_pr_rnk) g1_pr_2, avg(c4_pr_rnk) c4_pr_2 from h_rec_a2 group by horse, sex")
  ind<-which(h_rec_tmp$no<2)
  h_rec_a1<-h_rec_tmp[ind,]
  h_rec_avg1<-sqldf("select horse h1, sex, avg(h_rec) avg_1, avg(S1F) s_avg_1, avg(G1F) g1_avg_1, avg(C4) c4_avg_1, avg(G3F) g3_avg_1, avg(delay) dl_1, avg(h_w) h_w_1, sum(h_wd) wdf_1, avg(pr_rnk) pr_1, avg(s_pr_rnk) s_pr_1, avg(g1_pr_rnk) g1_pr_1, avg(c4_pr_rnk) c4_pr_1 from h_rec_a1 group by horse, sex")
#   head(h_rec_avg1,1) # verif
  
  h_rec_res1<-sqldf("select a.*, b.avg_1 v_avg1, b.s_avg_1, b.g1_avg_1, b.c4_avg_1, b.g3_avg_1, b.dl_1, b.h_w_1, b.wdf_1, b.pr_1, b.s_pr_1, b.g1_pr_1, b.c4_pr_1 from h_rec_avg a left outer join h_rec_avg1 b on (a.horse=b.h1 and a.sex=b.sex)")
  h_rec_res12<-sqldf("select a.*, b.avg_2 v_avg2, b.s_avg_2, b.g1_avg_2, b.c4_avg_2, b.g3_avg_2, b.dl_2, b.h_w_2, b.wdf_2, b.pr_2, b.s_pr_2, b.g1_pr_2, b.c4_pr_2 from h_rec_res1 a left outer join h_rec_avg2 b on (a.horse=b.h2 and a.sex=b.sex)")
  h_rec_res123<-sqldf("select a.*, b.avg_3 v_avg3, b.s_avg_3, b.g1_avg_3, b.c4_avg_3, b.g3_avg_3, b.dl_3, b.h_w_3, b.wdf_3, b.pr_3, b.s_pr_3, b.g1_pr_3, b.c4_pr_3 from h_rec_res12 a left outer join h_rec_avg3 b on (a.horse=b.h3 and a.sex=b.sex)")
  h_rec_res1235<-sqldf("select a.*, b.avg_5 v_avg5, b.s_avg_5, b.g1_avg_5, b.c4_avg_5, b.g3_avg_5, b.dl_5, b.h_w_5, b.wdf_5, b.pr_5, b.s_pr_5, b.g1_pr_5, b.c4_pr_5 from h_rec_res123 a left outer join h_rec_avg5 b on (a.horse=b.h5 and a.sex=b.sex)")
  h_rec_res12357<-sqldf("select a.*, b.avg_7 v_avg7, b.s_avg_7, b.g1_avg_7, b.c4_avg_7, b.g3_avg_7, b.dl_7, b.h_w_7, b.wdf_7, b.pr_7, b.s_pr_7, b.g1_pr_7, b.c4_pr_7 from h_rec_res1235 a left outer join h_rec_avg7 b on (a.horse=b.h7 and a.sex=b.sex)")
#   head(h_rec_res1235,1) # verif
  date<-rep(dt$date[i],nrow(h_rec_res12357))
  return(cbind(date,h_rec_res12357))
})

h_rec$date<-as.character(h_rec$date)
head(h_rec,1)
names(h_rec)

# verification
ind<-which(h_rec$date>'2014-03-24')
table(h_rec[ind,"date"])

######################################################
# delay master w.r.t player, teacher, owner # 2 min 20
######################################################

head(h_rec_dl)

system.time(
  dl_plr<-foreach(i=1:nrow(dt), .combine='rbind') %dopar% {
    ind<-which(h_rec_dl$date<dt$date[i]&h_rec_dl$date>as.character(as.Date(dt$date[i])-365))
    h_rec_dl_tmp<-h_rec_dl[ind,]
    plr_tmp <- sqldf("select player, count(distinct horse) horses, avg(delay) plr_dl_avg, median(delay) plr_dl_med, min(delay) plr_dl_min, max(delay) plr_dl_max, stdev(delay) plr_dl_std, avg(delay)-stdev(delay) plr_dl_max_val from h_rec_dl_tmp group by player");plr_dt<-rep(dt$date[i],nrow(plr_tmp))
    return(cbind(plr_dt,plr_tmp))
  }) # 11 seconds

system.time(
  dl_tcr<-foreach(i=1:nrow(dt), .combine='rbind') %dopar% {
    ind<-which(h_rec_dl$date<dt$date[i]&h_rec_dl$date>as.character(as.Date(dt$date[i])-365))
    h_rec_dl_tmp<-h_rec_dl[ind,]
    tcr_tmp <- sqldf("select teacher, count(distinct player) players, avg(delay) tcr_dl_avg, median(delay) tcr_dl_med, min(delay) tcr_dl_min, max(delay) tcr_dl_max, stdev(delay) tcr_dl_std, avg(delay)-stdev(delay) tcr_dl_max_val from h_rec_dl_tmp group by teacher");tcr_dt<-rep(dt$date[i],nrow(tcr_tmp))
    return(cbind(tcr_dt,tcr_tmp))
  }) # 11 seconds

system.time(
  dl_owr<-foreach(i=1:nrow(dt), .combine='rbind') %dopar% {
    ind<-which(h_rec_dl$date<dt$date[i]&h_rec_dl$date>as.character(as.Date(dt$date[i])-365))
    h_rec_dl_tmp<-h_rec_dl[ind,]
    owr_tmp <- sqldf("select owner, count(distinct teacher) teachers, avg(delay) owr_dl_avg, median(delay) owr_dl_med, min(delay) owr_dl_min, max(delay) owr_dl_max, stdev(delay) owr_dl_std, avg(delay)-stdev(delay) owr_dl_max_val from h_rec_dl_tmp group by owner");owr_dt<-rep(dt$date[i],nrow(owr_tmp))
    return(cbind(owr_dt,owr_tmp))
  }) # 11 seconds

save(m_res_xls,h_rec_dl,h_rec,dl_plr,dl_tcr,dl_owr,file="rdt/h_rec.rdata")
head(dl_plr);head(dl_tcr);head(dl_owr)
