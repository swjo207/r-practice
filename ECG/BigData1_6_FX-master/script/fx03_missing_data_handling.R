# 3. Missing Data Handling

load("data/mart_mrg.rdata")

# =============================================================== #
# 01. One day shift to use the available data at the predict time #
# =============================================================== #

mart_shft<-mart_mrg;flag<-0
str(mart_shft$Date)
mart_shft[1:15,1:4]

if (flag==0) {
  mart_shft$Date<-mart_shft$Date+1;flag<-1
  for (i in 1:(nrow(mart_shft)-1)) mart_shft$f_krw_usd[i]<-mart_shft$f_krw_usd[i+1]
  flag2<-0
} # Date Shift: 중복 실행을 회피하기 위해 flag를 설정함.
mart_shft[1:15,1:4]
(m<-nrow(mart_shft))
mart_shft[1:7,1:4];mart_shft[(m-6):m,1:4]

if(mart_shft$Date[m]==mart_mrg$Date[m]+1 & flag2==0) {mart_shft<-mart_shft[-m,];flag2<-1}
mart_shft[1:7,1:4];mart_shft[(m-6):m,1:4]
m;nrow(mart_shft)

# ============================================ #
# 02. Fill the missing with the previous value #
# ============================================ #

ind<-rep("",ncol(mart_shft)-2)
col_nm<-rep("",ncol(mart_shft)-2)
st_dt<-rep("",ncol(mart_shft)-2)
ind_first<-data.frame(ind,col_nm,st_dt)
for (i in 1:3) ind_first[,i]<-as.character(ind_first[,i])

for (i in 3:ncol(mart_mrg)){
  ind<-which(!is.na(mart_mrg[,i]))
  ind_first[i-2,1]<-i
  ind_first[i-2,2]<-names(mart_mrg)[i]
  ind_first[i-2,3]<-as.character(mart_mrg[ind[1],1])
}

ind_first
head(mart_shft,2)

mart_na<-mart_shft
mart_na$y_fr_5yr<-NULL

head(mart_na,2)

mart_na[1:15,1:4]

for (i in 3:ncol(mart_na)){
  ind<-which(is.na(mart_na[,i]))
  if(length(ind)>0){
    if(ind[1]==1) ind<-ind[-1]
    for (j in 1:length(ind)){
      mart_na[ind[j],i]<-mart_na[ind[j]-1,i]
    }
  }
}

mart_na[1:15,1:4]
summary(mart_na)

mart<-na.omit(mart_na)
summary(mart)

load("data/mart_raw.rdata")
fx_krw_usd_tmp<-fx_krw_usd[fx_krw_usd$Date>="2010-08-03",]
table(fx_krw_usd_tmp$Date==mart$Date)
head(fx_krw_usd_tmp,3);head(mart[,c("Date","f_krw_usd")],3)
tail(fx_krw_usd_tmp,3);tail(mart[,c("Date","f_krw_usd")],3)

############################
# variable order rearrange #
############################
names(mart)
mart_bkup<-mart
mart<-mart_bkup[,c(1,2,22:28,67:73,36:66,29:35,21,17:20,3:16)]
save(mart,mart_bkup,file="data/mart.rdata")
