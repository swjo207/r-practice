########################
# 3.1 데이터 마트 구성 #
########################

## (1) 일반 정보
### (1.1) 기업일반 정보 읽기

# install.packages("xlsx")
library(xlsx)

######################
# (11) read 11_gInfo #
######################

# read excel file
gInfo_xls<-read.xlsx("./Data_org/11_gInfo.xlsx", sheetIndex = 1,header=T)
str(gInfo_xls)

# change the data type
for (i in 2:ncol(gInfo_xls)) gInfo_xls[,i]<-as.character(gInfo_xls[,i])
str(gInfo_xls)

# change the audit opinion from "character" to ("0" or "1")
gInfo_ND<-gInfo_xls
for (i in 2:ncol(gInfo_ND)) {ind<-which(is.na(gInfo_ND[,i]));if (length(ind)>0) gInfo_ND[ind,i]<-""}
f_aud<-function(x) if (x=="적정") x<-0 else x<-1 # define a function
for (i in 2:ncol(gInfo_ND)) gInfo_ND[,i]<-sapply(gInfo_ND[,i],f_aud) # apply the function using "sapply"

head(gInfo_ND)

# comparison the result(gInfo_ND) data with original data(gInfo_xls)
# Be sure it's the same as the orinal excel file.
head(gInfo_ND,1)
head(gInfo_xls,1)
tail(gInfo_ND,1)
tail(gInfo_xls,1)

########################
# (12) read 12_gInfo_D #
########################
gInfo_D_xls<-read.xlsx("./Data_org/12_gInfo_Delisted.xlsx", sheetIndex = 1,header=T)
str(gInfo_D_xls)
for (i in 2:ncol(gInfo_D_xls)) gInfo_D_xls[,i]<-as.character(gInfo_D_xls[,i])
gInfo_D<-gInfo_D_xls
for (i in 3:ncol(gInfo_D)) {ind<-which(is.na(gInfo_D[,i]));if (length(ind)>0) gInfo_D[ind,i]<-""}
for (i in 3:ncol(gInfo_D)) gInfo_D[,i]<-sapply(gInfo_D[,i],f_aud) # apply the function "f_aud" using "sapply"

### (1.2) 기업일반 정보 통합

###########################
# (19) rbind general info #
###########################

# set v02_D_Date variable
names(gInfo_ND)
names(gInfo_D)

gInfo_ND$v02_D_date<-"0"

gInfo<-rbind(gInfo_ND,gInfo_D)
names(gInfo)
table(duplicated(gInfo$v01_Stock))

gInfo<-gInfo[order(gInfo$v01_Stock),order(colnames(gInfo))]
rownames(gInfo)<-NULL
head(gInfo,3)

gInfo[c(1,3),]
gInfo_D[c(1,2),]

gInfo[c(2,4),]
gInfo_ND[c(2,4),]

## (2) 재무제표 정보

### (2.1) 재무제표 정보 읽기

####################
# (21) read 21_fin #
####################

# read xlsx file
cls<-rep("numeric",101)
fin_xls<-read.xlsx("./Data_org/21_fin.xlsx", sheetIndex = 1,header=T,colClasses=cls)
str(fin_xls[,1:10])

# reorder the columns if needed
fin_ND<-fin_xls[,order(colnames(fin_xls))]

# comparison the result data with backup data
# Be sure it's the same as the orinal excel file.
names(fin_ND)[1:12]
ind_ND<-grep("v21",names(fin_ND))
fin_ND[1,c(1,ind_ND)]
ind_xls<-grep("v21",names(fin_xls))
fin_xls[1,c(1,ind_xls)]
table(fin_ND[1,c(1,ind_ND)]==fin_xls[1,c(1,ind_xls)])

ind_ND<-grep("v30",names(fin_ND))
fin_ND[nrow(fin_ND),c(1,ind_ND)]
ind_xls<-grep("v30",names(fin_xls))
fin_xls[nrow(fin_xls),c(1,ind_xls)]
table(fin_ND[nrow(fin_ND),c(1,ind_ND)]==fin_xls[nrow(fin_xls),c(1,ind_xls)])

#############################
# (22) read 22_fin_Delisted #
#############################
cls<-c(rep("numeric",101))
fin_D_xls<-read.xlsx("./Data_org/22_fin_Delisted.xlsx", sheetIndex = 1, header=T, colClasses=cls)
str(fin_D_xls[,1:10])
fin_D<-fin_D_xls[,order(colnames(fin_D_xls))]

### (2.2) 재무제표 정보 통합

##################
# (29) rbind fin #
##################

# column comparison
names(fin_ND)[1:10]
names(fin_D)[1:10]
table(names(fin_ND)==names(fin_D))

# rbind
fin<-rbind(fin_ND,fin_D)

# reorder
fin<-fin[order(fin$v01_Stock),order(colnames(fin))]
rownames(fin)<-NULL

# duplacation check
table(duplicated(fin$v01_Stock))

# check
ind<-grep("Y04",colnames(fin))
fin[2,c(1,ind)]
ind_ND<-grep("Y04",colnames(fin_ND))
fin_ND[1,c(1,ind_ND)]
table(fin[2,c(1,ind)]==fin_ND[1,c(1,ind_ND)])

ind<-grep("v21",colnames(fin))
fin[nrow(fin),c(1,ind)]
ind_D<-grep("v21",colnames(fin_D))
fin_D[nrow(fin_D),c(1,ind_D)]
table(fin[nrow(fin),c(1,ind)]==fin_D[nrow(fin_D),c(1,ind_D)])

## (3) 재무비율 정보

### (3.1) 재무비율 정보 읽기

#####################
# (31) read 31_rate #
#####################

# read xlsx file
cls<-rep("numeric",51)
rate_xls<-read.xlsx("./Data_org/31_rate.xlsx",sheetIndex = 1,header=T,colClasses=cls)
str(rate_xls[,1:10])

# reorder
rate_ND<-rate_xls[,order(colnames(rate_xls))]
rate_ND[1:3,1:10]

# comparison the result data with backup data
# Be sure it's the same as the orinal excel file.
names(rate_xls)[1:7]
ind_ND<-grep("Y04",names(rate_ND))
rate_ND[1,c(1,ind_ND)]
ind_xls<-grep("Y04",names(rate_xls))
rate_xls[1,c(1,ind_xls)]
table(rate_ND[1,c(1,ind_ND)]==rate_xls[1,c(1,ind_xls)])

ind_ND<-grep("Y13",names(rate_ND))
rate_ND[nrow(rate_ND),c(1,ind_ND)]
ind_xls<-grep("Y13",names(rate_xls))
rate_xls[nrow(rate_xls),c(1,ind_xls)]
table(rate_ND[nrow(rate_ND),c(1,ind_ND)]==rate_xls[nrow(rate_xls),c(1,ind_xls)])

##############################
# (32) read 32_rate_Delisted #
##############################
cls<-rep("numeric",51)
rate_D_xls<-read.xlsx("./Data_org/32_rate_Delisted.xlsx", sheetIndex = 1, header=T, colClasses=cls)
str(rate_D_xls[,1:10])
rate_D<-rate_D_xls[,order(colnames(rate_D_xls))]

### (3.2) 재무비율 정보 bind

###################
# (39) merge rate #
###################

# rbind
table(names(rate_ND)==names(rate_D))
rate<-rbind(rate_ND,rate_D)

# duplication check
table(duplicated(rate$v01_Stock))

# reorder
rate<-rate[order(rate$v01_Stock),order(colnames(rate))]
rownames(rate)<-NULL

# Confirm the result
ind<-grep("Y04",names(rate))
rate[2,c(1,ind)]
ind_ND<-grep("Y04",names(rate_ND))
rate_ND[1,c(1,ind_ND)]
table(rate[2,c(1,ind)]==rate_ND[1,c(1,ind_ND)])

ind<-grep("Y13",names(rate))
rate[nrow(rate),c(1,ind)]
ind_D<-grep("Y13",names(rate_D))
rate_D[nrow(rate_D),c(1,ind_D)]
table(rate[nrow(rate),c(1,ind)]==rate_D[nrow(rate_D),c(1,ind_D)])

## (4) 파생변수 생성

# Define the function to be used by the sapply
names(rate)[1:8]
f_dv<-function(x) if (is.na(x)) 0 else if (x<100) -1 else if (x>100) 1 else 0

# Generate the derived variable
rate$Y04_v71_R_cur_rat_dv <- sapply(rate$Y04_v53_R_cur_rat,f_dv)
rate$Y05_v71_R_cur_rat_dv <- sapply(rate$Y05_v53_R_cur_rat,f_dv)
rate$Y06_v71_R_cur_rat_dv <- sapply(rate$Y06_v53_R_cur_rat,f_dv)
rate$Y07_v71_R_cur_rat_dv <- sapply(rate$Y07_v53_R_cur_rat,f_dv)
rate$Y08_v71_R_cur_rat_dv <- sapply(rate$Y08_v53_R_cur_rat,f_dv)
rate$Y09_v71_R_cur_rat_dv <- sapply(rate$Y09_v53_R_cur_rat,f_dv)
rate$Y10_v71_R_cur_rat_dv <- sapply(rate$Y10_v53_R_cur_rat,f_dv)
rate$Y11_v71_R_cur_rat_dv <- sapply(rate$Y11_v53_R_cur_rat,f_dv)
rate$Y12_v71_R_cur_rat_dv <- sapply(rate$Y12_v53_R_cur_rat,f_dv)
rate$Y13_v71_R_cur_rat_dv <- sapply(rate$Y13_v53_R_cur_rat,f_dv)

# order the rate data
rate<-rate[,order(colnames(rate))]

## (5) 최종 Mart 생성

###############################
# (89) merge gInfo, fin, rate #
###############################

# merge gInfo, fin, rate
dim(gInfo);dim(fin);dim(rate)
mart_tmp<-merge(gInfo, fin, by="v01_Stock", all=T)
mart_org<-merge(mart_tmp,rate, by="v01_Stock", all=T)
names(mart_org)[1:13]
dim(mart_org)[2]==dim(gInfo)[2]+dim(fin)[2]+dim(rate)[2]-2

# reorder
mart<-mart_org[order(mart_org$v01_Stock),order(colnames(mart_org))]
ind<-which(is.na(mart$v02_D_date));length(ind)

# Delete delisted data before 2007
ind<-which(mart$v02_D_date<"20070101" & mart$v02_D_date!="0");length(ind)
if (length(ind)>0) mart<-mart_org[-ind,]

# Set the Delisted Year(D_yr) & Delisted Flag(D_YN)
f_D_yr<-function(x) substr(x,1,4)
mart$v03_D_yr<-sapply(mart$v02_D_date,f_D_yr)
table(mart$v03_D_yr)
mart$v04_D_YN<-0

# reorder mart
mart<-mart[,order(colnames(mart))]

# Delete sparse rows
col_cnt<-ncol(mart)
ABS_mart<-rep(0,nrow(mart))
for (i in 1:nrow(mart)) ABS_mart[i]<-sum(abs(mart[i,6:col_cnt]),na.rm=T)
ABS_mart_TF<-(ABS_mart>100)
table(ABS_mart_TF)
ind<-which(ABS_mart_TF==F);length(ind)
ind_c<-grep("v21",names(mart)) # current asset
mart[ind[1:5],c(1:4,ind_c)]

mart<-mart[ABS_mart_TF,]
rownames(mart)<-NULL

summary(mart[,1:6])

## (6) rdata로 저장

save(mart,mart_org,gInfo,gInfo_ND,gInfo_D,gInfo_xls,gInfo_D_xls,fin,fin_ND,fin_D,fin_xls,fin_D_xls,rate,rate_ND,rate_D,rate_xls,rate_D_xls,file="data/mart_all.rdata")

save(mart,file="data/mart.rdata")
