###############################
# 3.2 3년 단위 분할 마트 생성 #
###############################

## (1) randomForest용 mart 생성
load("data/mart.rdata")
names(mart)[1:10]
table(mart$v03_D_yr)

###################################
# change NA to 0 for randomForest #
###################################
mart_rF<-mart
names(mart_rF)[1:7]
for (i in 5:ncol(mart_rF)){
  ind<-which(is.na(mart_rF[,i]))
  if (length(ind)>0) mart_rF[ind,i]<-0
}

## (2) 3개년 data 생성

#############################
# T_456, T_456_rF (Y04~Y06) #
#############################
names(mart)[1:10]
ind_04<-grep("Y04",names(mart))
ind_05<-grep("Y05",names(mart))
ind_06<-grep("Y06",names(mart))
ind<-c(1:4,ind_04,ind_05,ind_06)

T_456_ini<-mart[,ind]
T_456_rF_ini<-mart_rF[,ind]

m<-ncol(T_456_ini)
names(T_456_ini)[c(1:10,(m-9):m)]
names(T_456_rF_ini)[c(1:10,(m-9):m)]

# (456) Eliminate blank rows
ABS_456<-rep(0,nrow(T_456_rF_ini))
col_cnt<-ncol(T_456_rF_ini)

for (i in (1:nrow(T_456_rF_ini))) ABS_456[i]<-sum(abs(T_456_rF_ini[i,5:col_cnt]))
ABS_456_TF<-(ABS_456>100)
table(ABS_456_TF)

T_456_ini<-T_456_ini[ABS_456_TF,]
T_456_rF_ini<-T_456_rF_ini[ABS_456_TF,]

table(T_456_ini$v03_D_yr);which(is.na(T_456_ini$v03_D_yr))
table(T_456_rF_ini$v03_D_yr);which(is.na(T_456_rF_ini$v03_D_yr))

# (456) eliminate delisted rows prior years and set delisted flag
str(T_456_ini$v03_D_yr)
ind<-which((T_456_ini$v03_D_yr>="2007") | (T_456_ini$v03_D_yr=="0"))
T_456_ini<-T_456_ini[ind,]
ind<-which(T_456_ini$v03_D_yr=="2007")
T_456_ini[ind,"v04_D_YN"]<-"1"
table(T_456_ini$v04_D_YN) # 15/(1900+15)

ind<-which((T_456_rF_ini$v03_D_yr>="2007") | (T_456_rF_ini$v03_D_yr=="0"))
T_456_rF_ini<-T_456_rF_ini[ind,]
ind<-which(T_456_rF_ini$v03_D_yr=="2007")
T_456_rF_ini[ind,"v04_D_YN"]<-1
table(T_456_rF_ini$v04_D_YN) # 15/(1900+15)

# (456) change colnames
for (i in (1:nrow(T_456_ini))){
  names(T_456_ini)<-sub("Y04","D3",names(T_456_ini))
  names(T_456_ini)<-sub("Y05","D2",names(T_456_ini))
  names(T_456_ini)<-sub("Y06","D1",names(T_456_ini))
}

col_nm<-names(T_456_ini)
names(T_456_rF_ini)<-col_nm

# (456) fatorize T var & cut the inf col
T_456_ini$v04_D_YN<-factor(T_456_ini$v04_D_YN)
names(T_456_ini)[c(1:10,(m-9):m)]
T_456<-T_456_ini[,-c(1:3)]

T_456_rF_ini$v04_D_YN<-factor(T_456_rF_ini$v04_D_YN)
T_456_rF<-T_456_rF_ini[,-c(1:3)]

#############################
# T_567, T_567_rF (Y05~Y07) #
#############################
ind_07<-grep("Y07",names(mart))
ind<-c(1:4,ind_05,ind_06,ind_07)
T_567_ini<-mart[,ind]
T_567_rF_ini<-mart_rF[,ind]

# (567) Eliminate blank rows
ABS_567<-rep(0,nrow(T_567_rF_ini))
col_cnt<-ncol(T_567_rF_ini)
for (i in (1:nrow(T_567_rF_ini))) ABS_567[i]<-sum(abs(T_567_rF_ini[i,4:col_cnt]))
ABS_567_TF<-(ABS_567>100)
T_567_ini<-T_567_ini[ABS_567_TF,]
T_567_rF_ini<-T_567_rF_ini[ABS_567_TF,]

# (567) eliminate delisted rows prior years and set delisted flag
ind<-which((T_567_ini$v03_D_yr>="2008") | (T_567_ini$v03_D_yr=="0"))
T_567_ini<-T_567_ini[ind,]
ind<-which(T_567_ini$v03_D_yr=="2008")
T_567_ini[ind,"v04_D_YN"]<-1
table(T_567_ini$v04_D_YN) # 24/(1888+24)

ind<-which((T_567_rF_ini$v03_D_yr>="2008") | (T_567_rF_ini$v03_D_yr=="0"))
T_567_rF_ini<-T_567_rF_ini[ind,]
ind<-which(T_567_rF_ini$v03_D_yr=="2008")
T_567_rF_ini[ind,"v04_D_YN"]<-1
table(T_567_rF_ini$v04_D_YN) # 24/(1888+24)

# (567) change colnames
names(T_567_ini)<-col_nm
names(T_567_rF_ini)<-col_nm

# (567) fatorize T var & cut the inf col
T_567_ini$v04_D_YN<-factor(T_567_ini$v04_D_YN)
T_567<-T_567_ini[,-c(1:3)]

T_567_rF_ini$v04_D_YN<-factor(T_567_rF_ini$v04_D_YN)
T_567_rF<-T_567_rF_ini[,-c(1:3)]

#############################
# T_678, T_678_rF (Y06~Y08) #
#############################
ind_08<-grep("Y08",names(mart))
ind<-c(1:4,ind_06,ind_07,ind_08)
T_678_ini<-mart[,ind]
T_678_rF_ini<-mart_rF[,ind]

# (678) Eliminate blank rows
ABS_678<-rep(0,nrow(T_678_rF_ini))
col_cnt<-ncol(T_678_rF_ini)
for (i in (1:nrow(T_678_rF_ini))) ABS_678[i]<-sum(abs(T_678_rF_ini[i,5:col_cnt]))
ABS_678_TF<-(ABS_678>100)
T_678_ini<-T_678_ini[ABS_678_TF,]
T_678_rF_ini<-T_678_rF_ini[ABS_678_TF,]

# (678) eliminate delisted rows prior years and set delisted flag
ind<-which((T_678_ini$v03_D_yr>="2009") | (T_678_ini$v03_D_yr=="0"))
T_678_ini<-T_678_ini[ind,]
ind<-which(T_678_ini$v03_D_yr=="2009")
T_678_ini[ind,"v04_D_YN"]<-1
table(T_678_ini$v04_D_YN) # 81/(1827+81)

ind<-which((T_678_rF_ini$v03_D_yr>="2009") | (T_678_rF_ini$v03_D_yr=="0"))
T_678_rF_ini<-T_678_rF_ini[ind,]
ind<-which(T_678_rF_ini$v03_D_yr=="2009")
T_678_rF_ini[ind,"v04_D_YN"]<-1
table(T_678_rF_ini$v04_D_YN) # 81/(1827+81)

# (678) change colnames
names(T_678_ini)<-col_nm
names(T_678_rF_ini)<-col_nm

# (678) fatorize T var & cut the inf col
T_678_ini$v04_D_YN<-factor(T_678_ini$v04_D_YN)
T_678<-T_678_ini[,-c(1:3)]

T_678_rF_ini$v04_D_YN<-factor(T_678_rF_ini$v04_D_YN)
T_678_rF<-T_678_rF_ini[,-c(1:3)]

#############################
# T_789, T_789_rF (Y07~Y09) #
#############################
ind_09<-grep("Y09",names(mart))
ind<-c(1:4,ind_07,ind_08,ind_09)
T_789_ini<-mart[,ind]
T_789_rF_ini<-mart_rF[,ind]

# (789) Eliminate blank rows
ABS_789<-rep(0,nrow(T_789_rF_ini))
col_cnt<-ncol(T_789_rF_ini)
for (i in (1:nrow(T_789_rF_ini))) ABS_789[i]<-sum(abs(T_789_rF_ini[i,5:col_cnt]))
ABS_789_TF<-(ABS_789>100)

T_789_ini<-T_789_ini[ABS_789_TF,]
T_789_rF_ini<-T_789_rF_ini[ABS_789_TF,]

# (789) eliminate delisted rows prior years and set delisted flag
ind<-which((T_789_ini$v03_D_yr>="2010") | (T_789_ini$v03_D_yr=="0"))
T_789_ini<-T_789_ini[ind,]
ind<-which(T_789_ini$v03_D_yr=="2010")
T_789_ini[ind,"v04_D_YN"]<-1
table(T_789_ini$v04_D_YN) # 90/(1750+90)

ind<-which((T_789_rF_ini$v03_D_yr>="2010") | (T_789_rF_ini$v03_D_yr=="0"))
T_789_rF_ini<-T_789_rF_ini[ind,]
ind<-which(T_789_rF_ini$v03_D_yr=="2010")
T_789_rF_ini[ind,"v04_D_YN"]<-1
table(T_789_rF_ini$v04_D_YN) # 90/(1750+90)

# (789) change colnames
names(T_789_ini)<-col_nm
names(T_789_rF_ini)<-col_nm

# (789) fatorize T var & cut the inf col
T_789_ini$v04_D_YN<-factor(T_789_ini$v04_D_YN)
T_789<-T_789_ini[,-c(1:3)]

T_789_rF_ini$v04_D_YN<-factor(T_789_rF_ini$v04_D_YN)
T_789_rF<-T_789_rF_ini[,-c(1:3)]

#############################
# T_890, T_890_rF (Y08~Y10) #
#############################
ind_10<-grep("Y10",names(mart))
ind<-c(1:4,ind_08,ind_09,ind_10)
T_890_ini<-mart[,ind]
T_890_rF_ini<-mart_rF[,ind]

# (890) Eliminate blank rows
ABS_890<-rep(0,nrow(T_890_rF_ini))
col_cnt<-ncol(T_890_rF_ini)
for (i in (1:nrow(T_890_rF_ini))) ABS_890[i]<-sum(abs(T_890_rF_ini[i,5:col_cnt]))
ABS_890_TF<-(ABS_890>100)

T_890_ini<-T_890_ini[ABS_890_TF,]
T_890_rF_ini<-T_890_rF_ini[ABS_890_TF,]

# (890) eliminate delisted rows prior years and set delisted flag
ind<-which((T_890_ini$v03_D_yr>="2011") | (T_890_ini$v03_D_yr=="0"))
T_890_ini<-T_890_ini[ind,]
ind<-which(T_890_ini$v03_D_yr=="2011")
T_890_ini[ind,"v04_D_YN"]<-1
table(T_890_ini$v04_D_YN) # 62/(1706+62)

ind<-which((T_890_rF_ini$v03_D_yr>="2011") | (T_890_rF_ini$v03_D_yr=="0"))
T_890_rF_ini<-T_890_rF_ini[ind,]
ind<-which(T_890_rF_ini$v03_D_yr=="2011")
T_890_rF_ini[ind,"v04_D_YN"]<-1
table(T_890_rF_ini$v04_D_YN) # 62/(1706+62)

# (890) change colnames
names(T_890_ini)<-col_nm
names(T_890_rF_ini)<-col_nm

# (890) fatorize T var & cut the inf col
T_890_ini$v04_D_YN<-factor(T_890_ini$v04_D_YN)
T_890<-T_890_ini[,-c(1:3)]

T_890_rF_ini$v04_D_YN<-factor(T_890_rF_ini$v04_D_YN)
T_890_rF<-T_890_rF_ini[,-c(1:3)]

#############################
# T_901, T_901_rF (Y09~Y11) #
#############################
ind_11<-grep("Y11",names(mart))
ind<-c(1:4,ind_09,ind_10,ind_11)
T_901_ini<-mart[,ind]
T_901_rF_ini<-mart_rF[,ind]

# (901) Eliminate blank rows
ABS_901<-rep(0,nrow(T_901_rF_ini))
col_cnt<-ncol(T_901_rF_ini)
for (i in (1:nrow(T_901_rF_ini))) ABS_901[i]<-sum(abs(T_901_rF_ini[i,5:col_cnt]))
ABS_901_TF<-(ABS_901>100)

T_901_ini<-T_901_ini[ABS_901_TF,]
T_901_rF_ini<-T_901_rF_ini[ABS_901_TF,]

# (901) eliminate delisted rows prior years and set delisted flag
ind<-which((T_901_ini$v03_D_yr>="2012") | (T_901_ini$v03_D_yr=="0"))
T_901_ini<-T_901_ini[ind,]
ind<-which(T_901_ini$v03_D_yr=="2012")
T_901_ini[ind,"v04_D_YN"]<-1
table(T_901_ini$v04_D_YN) # 53/(1695+53)

ind<-which((T_901_rF_ini$v03_D_yr>="2012") | (T_901_rF_ini$v03_D_yr=="0"))
T_901_rF_ini<-T_901_rF_ini[ind,]
ind<-which(T_901_rF_ini$v03_D_yr=="2012")
T_901_rF_ini[ind,"v04_D_YN"]<-1
table(T_901_rF_ini$v04_D_YN) # 53/(1695+53)

# (901) change colnames
names(T_901_ini)<-col_nm
names(T_901_rF_ini)<-col_nm

# (901) fatorize T var & cut the inf col
T_901_ini$v04_D_YN<-factor(T_901_ini$v04_D_YN)
T_901<-T_901_ini[,-c(1:3)]

T_901_rF_ini$v04_D_YN<-factor(T_901_rF_ini$v04_D_YN)
T_901_rF<-T_901_rF_ini[,-c(1:3)]

#############################
# T_012, T_012_rF (Y10~Y12) #
#############################
ind_12<-grep("Y12",names(mart))
ind<-c(1:4,ind_10,ind_11,ind_12)
T_012_ini<-mart[,ind]
T_012_rF_ini<-mart_rF[,ind]

# (012) Eliminate blank rows
ABS_012<-rep(0,nrow(T_012_rF_ini))
col_cnt<-ncol(T_012_rF_ini)
for (i in (1:nrow(T_012_rF_ini))) ABS_012[i]<-sum(abs(T_012_rF_ini[i,5:col_cnt]))
ABS_012_TF<-(ABS_012>100)

T_012_ini<-T_012_ini[ABS_012_TF,]
T_012_rF_ini<-T_012_rF_ini[ABS_012_TF,]

# (012) eliminate delisted rows prior years and set delisted flag
ind<-which((T_012_ini$v03_D_yr>="2013") | (T_012_ini$v03_D_yr=="0"))
T_012_ini<-T_012_ini[ind,]
ind<-which(T_012_ini$v03_D_yr=="2013")
T_012_ini[ind,"v04_D_YN"]<-1
table(T_012_ini$v04_D_YN) # 33/(1667+33)

ind<-which((T_012_rF_ini$v03_D_yr>="2013") | (T_012_rF_ini$v03_D_yr=="0"))
T_012_rF_ini<-T_012_rF_ini[ind,]
ind<-which(T_012_rF_ini$v03_D_yr=="2013")
T_012_rF_ini[ind,"v04_D_YN"]<-1
table(T_012_rF_ini$v04_D_YN) # 33/(1667+33)

# (012) change colnames
names(T_012_ini)<-col_nm
names(T_012_rF_ini)<-col_nm

# (012) fatorize T var & cut the inf col
T_012_ini$v04_D_YN<-factor(T_012_ini$v04_D_YN)
T_012<-T_012_ini[,-c(1:3)]

T_012_rF_ini$v04_D_YN<-factor(T_012_rF_ini$v04_D_YN)
T_012_rF<-T_012_rF_ini[,-c(1:3)]

#############################
# T_123, T_123_rF (Y11~Y13) #
#############################
ind_13<-grep("Y13",names(mart))
ind<-c(1:4,ind_11,ind_12,ind_13)
T_123_ini<-mart[,ind]
T_123_rF_ini<-mart_rF[,ind]

# (123) Eliminate blank rows
ABS_123<-rep(0,nrow(T_123_rF_ini))
col_cnt<-ncol(T_123_rF_ini)
for (i in (1:nrow(T_123_rF_ini))) ABS_123[i]<-sum(abs(T_123_rF_ini[i,5:col_cnt]))
ABS_123_TF<-(ABS_123>100)

T_123_ini<-T_123_ini[ABS_123_TF,]
T_123_rF_ini<-T_123_rF_ini[ABS_123_TF,]

# (123) eliminate delisted rows prior years and set delisted flag
ind<-which((T_123_ini$v03_D_yr>="2014") | (T_123_ini$v03_D_yr=="0"))
T_123_ini<-T_123_ini[ind,]
ind<-which(T_123_ini$v03_D_yr=="2014")
T_123_ini[ind,"v04_D_YN"]<-1
table(T_123_ini$v04_D_YN) # 16/(1660+16)

ind<-which((T_123_rF_ini$v03_D_yr>="2014") | (T_123_rF_ini$v03_D_yr=="0"))
T_123_rF_ini<-T_123_rF_ini[ind,]
ind<-which(T_123_rF_ini$v03_D_yr=="2014")
T_123_rF_ini[ind,"v04_D_YN"]<-1
table(T_123_rF_ini$v04_D_YN) # 16/(1660+16)

# (123) change colnames
names(T_123_ini)<-col_nm
names(T_123_rF_ini)<-col_nm

# (123) fatorize T var & cut the inf col
T_123_ini$v04_D_YN<-factor(T_123_ini$v04_D_YN)
T_123<-T_123_ini[,-c(1:3)]

T_123_rF_ini$v04_D_YN<-factor(T_123_rF_ini$v04_D_YN)
T_123_rF<-T_123_rF_ini[,-c(1:3)]

## (3) 감사의견과 파생변수는 factor화

#####################################################
# factorize audit opinion column & derived variable #
#####################################################
ind_aud<-grep("_aud",names(T_456))
for (i in 1:length(ind_aud)) T_456[,ind_aud[i]]<-factor(T_456[,ind_aud[i]],levels=c("0","1"))
ind_dv<-grep("_dv",names(T_456))
for (i in 1:length(ind_dv)) T_456[,ind_dv[i]]<-factor(T_456[,ind_dv[i]],levels=c("-1","0","1"))
str(T_456[,ind_aud])
str(T_456[,ind_dv])

ind_aud<-grep("_aud",names(T_567))
for (i in 1:length(ind_aud)) T_567[,ind_aud[i]]<-factor(T_567[,ind_aud[i]],levels=c("0","1"))
ind_dv<-grep("_dv",names(T_567))
for (i in 1:length(ind_dv)) T_567[,ind_dv[i]]<-factor(T_567[,ind_dv[i]],levels=c("-1","0","1"))

ind_aud<-grep("_aud",names(T_678))
for (i in 1:length(ind_aud)) T_678[,ind_aud[i]]<-factor(T_678[,ind_aud[i]],levels=c("0","1"))
ind_dv<-grep("_dv",names(T_678))
for (i in 1:length(ind_dv)) T_678[,ind_dv[i]]<-factor(T_678[,ind_dv[i]],levels=c("-1","0","1"))

ind_aud<-grep("_aud",names(T_789))
for (i in 1:length(ind_aud)) T_789[,ind_aud[i]]<-factor(T_789[,ind_aud[i]],levels=c("0","1"))
ind_dv<-grep("_dv",names(T_789))
for (i in 1:length(ind_dv)) T_789[,ind_dv[i]]<-factor(T_789[,ind_dv[i]],levels=c("-1","0","1"))

ind_aud<-grep("_aud",names(T_890))
for (i in 1:length(ind_aud)) T_890[,ind_aud[i]]<-factor(T_890[,ind_aud[i]],levels=c("0","1"))
ind_dv<-grep("_dv",names(T_890))
for (i in 1:length(ind_dv)) T_890[,ind_dv[i]]<-factor(T_890[,ind_dv[i]],levels=c("-1","0","1"))

ind_aud<-grep("_aud",names(T_901))
for (i in 1:length(ind_aud)) T_901[,ind_aud[i]]<-factor(T_901[,ind_aud[i]],levels=c("0","1"))
ind_dv<-grep("_dv",names(T_901))
for (i in 1:length(ind_dv)) T_901[,ind_dv[i]]<-factor(T_901[,ind_dv[i]],levels=c("-1","0","1"))

ind_aud<-grep("_aud",names(T_012))
for (i in 1:length(ind_aud)) T_012[,ind_aud[i]]<-factor(T_012[,ind_aud[i]],levels=c("0","1"))
ind_dv<-grep("_dv",names(T_012))
for (i in 1:length(ind_dv)) T_012[,ind_dv[i]]<-factor(T_012[,ind_dv[i]],levels=c("-1","0","1"))

ind_aud<-grep("_aud",names(T_123))
for (i in 1:length(ind_aud)) T_123[,ind_aud[i]]<-factor(T_123[,ind_aud[i]],levels=c("0","1"))
ind_dv<-grep("_dv",names(T_123))
for (i in 1:length(ind_dv)) T_123[,ind_dv[i]]<-factor(T_123[,ind_dv[i]],levels=c("-1","0","1"))

names(T_456)

## (4) rdata로 저장

save(T_456_ini,T_456,T_456_rF_ini,T_456_rF,T_567_ini,T_567,T_567_rF_ini,T_567_rF,T_678_ini,T_678,T_678_rF_ini,T_678_rF,T_789_ini,T_789,T_789_rF_ini,T_789_rF,T_890_ini,T_890,T_890_rF_ini,T_890_rF,T_901_ini,T_901,T_901_rF_ini,T_901_rF,T_012_ini,T_012,T_012_rF_ini,T_012_rF,T_123_ini,T_123,T_123_rF_ini,T_123_rF,file="data/3yr_data_04to13.rdata")
