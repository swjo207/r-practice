library(gdata);library(WriteXLS);library(sqldf);library(doMC);library(foreach)
registerDoMC(6)

martStartDate<-'2011-01-01'

# load past result
# load("rdt/result.rdata")

h_pt_t<-sqldf("select horse, sex, date, weight, rank from m_res_xls order by horse, sex, date desc")
h_pt_t$weight<-as.numeric(h_pt_t$weight)
ind<-which(h_pt_t$rank>0&h_pt_t$rank<4)
h_pt_t$t_123<-0
h_pt_t$t_123[ind]<-1
head(h_pt_t)

# date 
dtSql<-paste("select distinct(date) from h_pt_t where date >",martStartDate,"order by date desc")
dt<-sqldf(dtSql)

# create pattern
system.time(
  h_pt_res<-foreach(i=1:nrow(dt), .combine='rbind') %dopar% {
    ind<-which(h_pt_t$date<=dt$date[i])
    h_pt_dt<-h_pt_t[ind,]  
    s_hr<-paste("select horse, sex from h_pt_t where date = '",dt$date[i],"' order by horse, sex",sep="")
    hr<-sqldf(s_hr)  
    for(n in 1:nrow(hr)){
      ind<-which(h_pt_dt$horse==hr$horse[n] & h_pt_dt$sex==hr$sex[n])
      if (n==1){
        h_pt_tmp<-h_pt_dt[ind,]
      } else{
        h_pt_tmp<-rbind(h_pt_tmp,h_pt_dt[ind,])
      }
    }
    h_pt_tmp$no<-1
    if(nrow(h_pt_tmp)>1){
      for (j in 2:nrow(h_pt_tmp)) {
        if (h_pt_tmp$horse[j-1]==h_pt_tmp$horse[j]&h_pt_tmp$sex[j-1]==h_pt_tmp$sex[j]) {
          h_pt_tmp$no[j]<-h_pt_tmp$no[j-1]+1
        }
      }
      h_pt_cnt<-sqldf("select horse, sex, max(no) cnt from h_pt_tmp group by horse, sex")
      h_pt_cnt$pt4<-""
      h_pt_cnt$w_diff<-0
      h_pt_cnt$wd_2<-0
      h_pt_cnt$date<-dt$date[i]
      head(hr)
      for (k in 1:length(h_pt_cnt$horse)){
        if(h_pt_cnt$cnt[k]>4){
          ind_1<-which(h_pt_tmp$horse==h_pt_cnt$horse[k] & h_pt_tmp$sex==h_pt_cnt$sex[k] & h_pt_tmp$no == 1)
          ind_2<-which(h_pt_tmp$horse==h_pt_cnt$horse[k] & h_pt_tmp$sex==h_pt_cnt$sex[k] & h_pt_tmp$no == 2)
          ind_3<-which(h_pt_tmp$horse==h_pt_cnt$horse[k] & h_pt_tmp$sex==h_pt_cnt$sex[k] & h_pt_tmp$no == 3)
          ind_4<-which(h_pt_tmp$horse==h_pt_cnt$horse[k] & h_pt_tmp$sex==h_pt_cnt$sex[k] & h_pt_tmp$no == 4)
          ind_5<-which(h_pt_tmp$horse==h_pt_cnt$horse[k] & h_pt_tmp$sex==h_pt_cnt$sex[k] & h_pt_tmp$no == 5)
          h_pt_cnt$pt4[k]<-paste(h_pt_tmp$t_123[ind_2],h_pt_tmp$t_123[ind_3],h_pt_tmp$t_123[ind_4],h_pt_tmp$t_123[ind_5],sep="")
          h_pt_cnt$w_diff[k]<-h_pt_tmp$weight[ind_1]-h_pt_tmp$weight[ind_2]
          if (h_pt_cnt$w_diff[k]>=2) {
            h_pt_cnt$wd_2[k]<-1
          }else if (h_pt_cnt$w_diff[k]<=(-2)){
            h_pt_cnt$wd_2[k]<-(-1)
          }
        }else if (h_pt_cnt$cnt[k]>3){
          ind_1<-which(h_pt_tmp$horse==h_pt_cnt$horse[k] & h_pt_tmp$sex==h_pt_cnt$sex[k] & h_pt_tmp$no == 1)
          ind_2<-which(h_pt_tmp$horse==h_pt_cnt$horse[k] & h_pt_tmp$sex==h_pt_cnt$sex[k] & h_pt_tmp$no == 2)
          ind_3<-which(h_pt_tmp$horse==h_pt_cnt$horse[k] & h_pt_tmp$sex==h_pt_cnt$sex[k] & h_pt_tmp$no == 3)
          ind_4<-which(h_pt_tmp$horse==h_pt_cnt$horse[k] & h_pt_tmp$sex==h_pt_cnt$sex[k] & h_pt_tmp$no == 4)
          h_pt_cnt$pt4[k]<-paste(h_pt_tmp$t_123[ind_2],h_pt_tmp$t_123[ind_3],h_pt_tmp$t_123[ind_4],sep="")
          h_pt_cnt$w_diff[k]<-h_pt_tmp$weight[ind_1]-h_pt_tmp$weight[ind_2]
          if (h_pt_cnt$w_diff[k]>=2) {
            h_pt_cnt$wd_2[k]<-1
          }else if (h_pt_cnt$w_diff[k]<=(-2)){
            h_pt_cnt$wd_2[k]<-(-1)
          }
        } else if(h_pt_cnt$cnt[k]>2){
          ind_1<-which(h_pt_tmp$horse==h_pt_cnt$horse[k] & h_pt_tmp$sex==h_pt_cnt$sex[k] & h_pt_tmp$no == 1)
          ind_2<-which(h_pt_tmp$horse==h_pt_cnt$horse[k] & h_pt_tmp$sex==h_pt_cnt$sex[k] & h_pt_tmp$no == 2)
          ind_3<-which(h_pt_tmp$horse==h_pt_cnt$horse[k] & h_pt_tmp$sex==h_pt_cnt$sex[k] & h_pt_tmp$no == 3)
          h_pt_cnt$pt4[k]<-paste(h_pt_tmp$t_123[ind_2],h_pt_tmp$t_123[ind_3],sep="")
          h_pt_cnt$w_diff[k]<-h_pt_tmp$weight[ind_1]-h_pt_tmp$weight[ind_2]
          if (h_pt_cnt$w_diff[k]>=2) {
            h_pt_cnt$wd_2[k]<-1
          }else if (h_pt_cnt$w_diff[k]<=(-2)){
            h_pt_cnt$wd_2[k]<-(-1)
          }
        } else if(h_pt_cnt$cnt[k]>1){
          ind_1<-which(h_pt_tmp$horse==h_pt_cnt$horse[k] & h_pt_tmp$sex==h_pt_cnt$sex[k] & h_pt_tmp$no == 1)
          ind_2<-which(h_pt_tmp$horse==h_pt_cnt$horse[k] & h_pt_tmp$sex==h_pt_cnt$sex[k] & h_pt_tmp$no == 2)
          h_pt_cnt$pt4[k]<-h_pt_tmp$t_123[ind_2]
          h_pt_cnt$w_diff[k]<-h_pt_tmp$weight[ind_1]-h_pt_tmp$weight[ind_2]
          if (h_pt_cnt$w_diff[k]>=2) {
            h_pt_cnt$wd_2[k]<-1
          }else if (h_pt_cnt$w_diff[k]<=(-2)){
            h_pt_cnt$wd_2[k]<-(-1)
          }
        }
      }
    }
    return(h_pt_cnt)
  })

names(h_pt_res)
h_pt_res<-h_pt_res[order(h_pt_res$horse,h_pt_res$sex),]
head(h_pt_res)
ind<-which(h_pt_res$pt4=="")
h_pt_res$pt4[ind]<-"A"

h_pt<-sqldf("select a.*, b.cnt, b.pt4,b.w_diff,b.wd_2 from h_pt_t a left outer join h_pt_res b on (a.horse=b.horse and a.sex=b.sex and a.date=b.date)")

# verification
ind<-which(h_pt$date>'2014-03-24')
table(h_pt[ind,"date"])

save(m_res_xls,h_pt_res,h_pt,file="rdt/h_pt.rdata")

head(h_pt)
