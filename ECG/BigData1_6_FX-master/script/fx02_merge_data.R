# 2. Merge Data

load("data/mart_raw.rdata")
library(sqldf)

# =========== #
# Create Date #
# =========== #
Date<-rep(as.Date("2009-07-01"),as.Date("2014-06-30")-as.Date("2009-07-01")+1);flag<-0
n<-0:(as.Date("2014-06-30")-as.Date("2009-07-01"))
if (flag==0) Date<-Date+n;flag<-1 # 중복실행을 막기 위해 flag 설정
Date<-as.data.frame(Date)
head(Date,3);tail(Date,3)

# =========================== #
# 00. Merge Date with krw/usd #
# =========================== #
# merge Date with target variable fx_krw_usd using sqldf
names(fx_krw_usd)
mart_tmp_01<-sqldf("select a.Date,b.f_krw_usd from Date a left outer join fx_krw_usd b on a.Date=b.Date")
str(mart_tmp_01)
# verification (last date - first date + 1 == length(date))
mart_tmp_01$Date[length(mart_tmp_01$Date)]-mart_tmp_01$Date[1]+1==length(mart_tmp_01$Date)
# eye check
head(fx_krw_usd,3);head(mart_tmp_01,3)
tail(fx_krw_usd,3);tail(mart_tmp_01,3)

# =========================== #
# 01. Merge Korean bond yield #
# =========================== #
# using cbind
names(yield_krx_b)
table(mart_tmp_01$Date==yield_krx_b$Date); nrow(yield_krx_b)
mart_tmp_02<-cbind(mart_tmp_01,yield_krx_b$y_krx_b)
mart_tmp_02$Date[length(mart_tmp_02$Date)]-mart_tmp_02$Date[1]+1==length(mart_tmp_02$Date)
mart_tmp_02[1:3,]
names(mart_tmp_02)[3]<-"y_krx_b"

names(yield_krx_g)
yield_krx_g_tmp<-sqldf("select a.Date,b.y_krx_g_3yr,b.y_krx_g_5yr,b.y_krx_g_10yr from Date a left outer join yield_krx_g b on a.Date=b.Date")
head(yield_krx_g_tmp,3);tail(yield_krx_g_tmp,3)
names(yield_krx_t)
yield_krx_t_tmp<-sqldf("select a.Date,b.y_krx_t from Date a left outer join yield_krx_t b on a.Date=b.Date")
head(yield_krx_t_tmp,3);tail(yield_krx_t_tmp,3)

# verify the order of data
table(mart_tmp_02$Date==yield_krx_g_tmp$Date);nrow(yield_krx_g_tmp)
table(mart_tmp_02$Date==yield_krx_t_tmp$Date);nrow(yield_krx_t_tmp)

# merge using cbind
names(yield_krx_g_tmp);names(yield_krx_t_tmp)
mart_tmp_03<-cbind(mart_tmp_02,yield_krx_g_tmp[,c(2:4)],y_krx_t=yield_krx_t_tmp$y_krx_t)

# verify the number of days == length(Date)
mart_tmp_03$Date[length(mart_tmp_03$Date)]-mart_tmp_03$Date[1]+1==length(mart_tmp_03$Date)

# eye check
mart_tmp_03[1:3,c(1,4:7)];yield_krx_g_tmp[1:3,];yield_krx_t_tmp[1:3,]
n<-nrow(mart_tmp_03)
mart_tmp_03[(n-2):n,c(1,4:7)];yield_krx_g_tmp[(n-2):n,];yield_krx_t_tmp[(n-2):n,]


# ============================================= #
# 10. merge mart_tmp_04 with Korean stock index #
# ============================================= #
# using merge
names(stck_kospi)
mart_tmp_11<-merge(mart_tmp_03,stck_kospi,by.x="Date",by.y="Date",all.x=T)
mart_tmp_11$Date[length(mart_tmp_11$Date)]-mart_tmp_11$Date[1]+1==length(mart_tmp_11$Date)
mart_tmp_11[1:3,c(1,((ncol(mart_tmp_11)-ncol(stck_kospi)):ncol(mart_tmp_11)))]

names(stck_krx_100)
mart_tmp_12<-merge(mart_tmp_11,stck_krx_100,by.x="Date",by.y="Date",all.x=T)
mart_tmp_12$Date[length(mart_tmp_12$Date)]-mart_tmp_12$Date[1]+1==length(mart_tmp_12$Date)
mart_tmp_12[1:3,c(1,((ncol(mart_tmp_12)-ncol(stck_krx_100)):ncol(mart_tmp_12)))]

names(stck_krx_autos)
mart_tmp_13<-merge(mart_tmp_12,stck_krx_autos,by.x="Date",by.y="Date",all.x=T)
mart_tmp_13$Date[length(mart_tmp_13$Date)]-mart_tmp_13$Date[1]+1==length(mart_tmp_13$Date)
mart_tmp_13[1:3,c(1,((ncol(mart_tmp_13)-ncol(stck_krx_autos)):ncol(mart_tmp_13)))]

names(stck_krx_energy)
mart_tmp_14<-merge(mart_tmp_13,stck_krx_energy,by.x="Date",by.y="Date",all.x=T)
mart_tmp_14$Date[length(mart_tmp_14$Date)]-mart_tmp_14$Date[1]+1==length(mart_tmp_14$Date)
mart_tmp_14[1:3,c(1,((ncol(mart_tmp_14)-ncol(stck_krx_energy)):ncol(mart_tmp_14)))]

names(stck_krx_it)
mart_tmp_15<-merge(mart_tmp_14,stck_krx_it,by.x="Date",by.y="Date",all.x=T)
mart_tmp_15$Date[length(mart_tmp_15$Date)]-mart_tmp_15$Date[1]+1==length(mart_tmp_15$Date)
mart_tmp_15[1:3,c(1,((ncol(mart_tmp_15)-ncol(stck_krx_it)):ncol(mart_tmp_15)))]

names(stck_krx_semicon)
mart_tmp_16<-merge(mart_tmp_15,stck_krx_semicon,by.x="Date",by.y="Date",all.x=T)
mart_tmp_16$Date[length(mart_tmp_16$Date)]-mart_tmp_16$Date[1]+1==length(mart_tmp_16$Date)
mart_tmp_16[1:3,c(1,((ncol(mart_tmp_16)-ncol(stck_krx_semicon)):ncol(mart_tmp_16)))]

names(stck_krx_ship_build)
mart_tmp_17<-merge(mart_tmp_16,stck_krx_ship_build,by.x="Date",by.y="Date",all.x=T)
mart_tmp_17$Date[length(mart_tmp_17$Date)]-mart_tmp_17$Date[1]+1==length(mart_tmp_17$Date)
mart_tmp_17[1:3,c(1,((ncol(mart_tmp_17)-ncol(stck_krx_ship_build)):ncol(mart_tmp_17)))]

names(stck_krx_steels)
mart_tmp_18<-merge(mart_tmp_17,stck_krx_steels,by.x="Date",by.y="Date",all.x=T)
mart_tmp_18$Date[length(mart_tmp_18$Date)]-mart_tmp_18$Date[1]+1==length(mart_tmp_18$Date)
mart_tmp_18[1:3,c(1,((ncol(mart_tmp_18)-ncol(stck_krx_steels)):ncol(mart_tmp_18)))]

names(stck_krx_trans)
mart_tmp_19<-merge(mart_tmp_18,stck_krx_trans,by.x="Date",by.y="Date",all.x=T)
mart_tmp_19$Date[length(mart_tmp_19$Date)]-mart_tmp_19$Date[1]+1==length(mart_tmp_19$Date)
mart_tmp_19[1:3,c(1,((ncol(mart_tmp_19)-ncol(stck_krx_trans)):ncol(mart_tmp_19)))]

# ========================================== #
# 20. merge mart_tmp_14 with forex variables #
# ========================================== #
names(fx_krw_aud)
mart_tmp_21<-merge(mart_tmp_19,fx_krw_aud,by.x="Date",by.y="Date",all.x=T)
mart_tmp_21$Date[length(mart_tmp_21$Date)]-mart_tmp_21$Date[1]+1==length(mart_tmp_21$Date)
mart_tmp_21[1:3,c(1,((ncol(mart_tmp_21)-ncol(fx_krw_aud)):ncol(mart_tmp_21)))]

names(fx_krw_cny)
mart_tmp_22<-merge(mart_tmp_21,fx_krw_cny,by.x="Date",by.y="Date",all.x=T)
mart_tmp_22$Date[length(mart_tmp_22$Date)]-mart_tmp_22$Date[1]+1==length(mart_tmp_22$Date)
mart_tmp_22[1:3,c(1,((ncol(mart_tmp_22)-ncol(fx_krw_cny)):ncol(mart_tmp_22)))]

names(fx_krw_gbp)
mart_tmp_23<-merge(mart_tmp_22,fx_krw_gbp,by.x="Date",by.y="Date",all.x=T)
mart_tmp_23$Date[length(mart_tmp_23$Date)]-mart_tmp_23$Date[1]+1==length(mart_tmp_23$Date)
mart_tmp_23[1:3,c(1,((ncol(mart_tmp_23)-ncol(fx_krw_gbp)):ncol(mart_tmp_23)))]

names(fx_krw_eur)
mart_tmp_24<-merge(mart_tmp_23,fx_krw_eur,by.x="Date",by.y="Date",all.x=T)
mart_tmp_24$Date[length(mart_tmp_24$Date)]-mart_tmp_24$Date[1]+1==length(mart_tmp_24$Date)
mart_tmp_24[1:3,c(1,((ncol(mart_tmp_24)-ncol(fx_krw_eur)):ncol(mart_tmp_24)))]

# ==================================================== #
# 30. merge mart_tmp_24 with US Dollar index variables #
# ==================================================== #
names(usd_index)
mart_tmp_31<-merge(mart_tmp_24,usd_index,by.x="Date",by.y="Date",all.x=T)
mart_tmp_31$Date[length(mart_tmp_31$Date)]-mart_tmp_31$Date[1]+1==length(mart_tmp_31$Date)
mart_tmp_31[1:3,c(1,((ncol(mart_tmp_31)-ncol(usd_index)):ncol(mart_tmp_31)))]

# ==================================================== #
# 40. merge mart_tmp_31 with commodity price variables #
# ==================================================== #
names(cmd_copper)
mart_tmp_41<-merge(mart_tmp_31,cmd_copper,by.x="Date",by.y="Date",all.x=T)
mart_tmp_41$Date[length(mart_tmp_41$Date)]-mart_tmp_41$Date[1]+1==length(mart_tmp_41$Date)
head(mart_tmp_41,3)

names(cmd_corn)
mart_tmp_42<-merge(mart_tmp_41,cmd_corn,by.x="Date",by.y="Date",all.x=T)
mart_tmp_42$Date[length(mart_tmp_42$Date)]-mart_tmp_42$Date[1]+1==length(mart_tmp_42$Date)
head(mart_tmp_42,3)

names(cmd_gold)
mart_tmp_43<-merge(mart_tmp_42,cmd_gold,by.x="Date",by.y="Date",all.x=T)
mart_tmp_43$Date[length(mart_tmp_43$Date)]-mart_tmp_43$Date[1]+1==length(mart_tmp_43$Date)
head(mart_tmp_43,3)

names(cmd_oil_brent)
mart_tmp_44<-merge(mart_tmp_43,cmd_oil_brent,by.x="Date",by.y="Date",all.x=T)
mart_tmp_44$Date[length(mart_tmp_44$Date)]-mart_tmp_44$Date[1]+1==length(mart_tmp_44$Date)
head(mart_tmp_44,3)

names(cmd_oil_wti)
mart_tmp_45<-merge(mart_tmp_44,cmd_oil_wti,by.x="Date",by.y="Date",all.x=T)
mart_tmp_45$Date[length(mart_tmp_45$Date)]-mart_tmp_45$Date[1]+1==length(mart_tmp_45$Date)
head(mart_tmp_45,3)

names(cmd_gas)
mart_tmp_46<-merge(mart_tmp_45,cmd_gas,by.x="Date",by.y="Date",all.x=T)
mart_tmp_46$Date[length(mart_tmp_46$Date)]-mart_tmp_46$Date[1]+1==length(mart_tmp_46$Date)
mart_tmp_46[1:3,c(1,((ncol(mart_tmp_46)-2):ncol(mart_tmp_46)))]

names(cmd_silver)
mart_tmp_47<-merge(mart_tmp_46,cmd_silver,by.x="Date",by.y="Date",all.x=T)
mart_tmp_47$Date[length(mart_tmp_47$Date)]-mart_tmp_47$Date[1]+1==length(mart_tmp_47$Date)
mart_tmp_47[1:3,c(1,((ncol(mart_tmp_47)-2):ncol(mart_tmp_47)))]

# ======================================================== #
# 50. merge mart_tmp_47 with Foreign stock index variables #
# ======================================================== #
names(stck_cac40)
mart_tmp_51<-merge(mart_tmp_47,stck_cac40,by.x="Date",by.y="Date",all.x=T)
mart_tmp_51$Date[length(mart_tmp_51$Date)]-mart_tmp_51$Date[1]+1==length(mart_tmp_51$Date)
mart_tmp_51[1:3,c(1,((ncol(mart_tmp_51)-ncol(stck_cac40)):ncol(mart_tmp_51)))]

names(stck_dax)
mart_tmp_52<-merge(mart_tmp_51,stck_dax,by.x="Date",by.y="Date",all.x=T)
mart_tmp_52$Date[length(mart_tmp_52$Date)]-mart_tmp_52$Date[1]+1==length(mart_tmp_52$Date)
mart_tmp_52[1:3,c(1,((ncol(mart_tmp_52)-ncol(stck_dax)):ncol(mart_tmp_52)))]

names(stck_nasdaq)
mart_tmp_53<-merge(mart_tmp_52,stck_nasdaq,by.x="Date",by.y="Date",all.x=T)
mart_tmp_53$Date[length(mart_tmp_53$Date)]-mart_tmp_53$Date[1]+1==length(mart_tmp_53$Date)
mart_tmp_53[1:3,c(1,((ncol(mart_tmp_53)-ncol(stck_nasdaq)):ncol(mart_tmp_53)))]

names(stck_nikkei)
mart_tmp_54<-merge(mart_tmp_53,stck_nikkei,by.x="Date",by.y="Date",all.x=T)
mart_tmp_54$Date[length(mart_tmp_54$Date)]-mart_tmp_54$Date[1]+1==length(mart_tmp_54$Date)
mart_tmp_54[1:3,c(1,((ncol(mart_tmp_54)-ncol(stck_nikkei)):ncol(mart_tmp_54)))]

names(stck_nyse)
mart_tmp_55<-merge(mart_tmp_54,stck_nyse,by.x="Date",by.y="Date",all.x=T)
mart_tmp_55$Date[length(mart_tmp_55$Date)]-mart_tmp_55$Date[1]+1==length(mart_tmp_55$Date)
mart_tmp_55[1:3,c(1,((ncol(mart_tmp_55)-ncol(stck_nyse)):ncol(mart_tmp_55)))]

names(stck_snp500)
mart_tmp_56<-merge(mart_tmp_55,stck_snp500,by.x="Date",by.y="Date",all.x=T)
mart_tmp_56$Date[length(mart_tmp_56$Date)]-mart_tmp_56$Date[1]+1==length(mart_tmp_56$Date)
mart_tmp_56[1:3,c(1,((ncol(mart_tmp_56)-ncol(stck_snp500)):ncol(mart_tmp_56)))]

names(stck_ssec)
mart_tmp_57<-merge(mart_tmp_56,stck_ssec,by.x="Date",by.y="Date",all.x=T)
mart_tmp_57$Date[length(mart_tmp_57$Date)]-mart_tmp_57$Date[1]+1==length(mart_tmp_57$Date)
mart_tmp_57[1:3,c(1,((ncol(mart_tmp_57)-ncol(stck_ssec)):ncol(mart_tmp_57)))]

# ================================================== #
# 60. merge mart_tmp_57 with interest rate variables #
# ================================================== #
names(yield_ca)
mart_tmp_61<-merge(mart_tmp_57,yield_ca,by.x="Date",by.y="Date",all.x=T)
mart_tmp_61$Date[length(mart_tmp_61$Date)]-mart_tmp_61$Date[1]+1==length(mart_tmp_61$Date)
mart_tmp_61[1:3,c(1,((ncol(mart_tmp_61)-ncol(yield_ca)):ncol(mart_tmp_61)))]

names(yield_jp)
mart_tmp_62<-merge(mart_tmp_61,yield_jp,by.x="Date",by.y="Date",all.x=T)
mart_tmp_62$Date[length(mart_tmp_62$Date)]-mart_tmp_62$Date[1]+1==length(mart_tmp_62$Date)
mart_tmp_62[1:3,c(1,((ncol(mart_tmp_62)-ncol(yield_jp)):ncol(mart_tmp_62)))]

names(yield_fr)
mart_tmp_63<-merge(mart_tmp_62,yield_fr,by.x="Date",by.y="Date",all.x=T)
mart_tmp_63$Date[length(mart_tmp_63$Date)]-mart_tmp_63$Date[1]+1==length(mart_tmp_63$Date)
mart_tmp_63[1:3,c(1,((ncol(mart_tmp_63)-ncol(yield_fr)):ncol(mart_tmp_63)))]
names(mart_tmp_63)
ind<-which(!is.na(mart_tmp_63$y_fr_5yr))
mart_tmp_63[ind[1],]

names(yield_nz)
mart_tmp_64<-merge(mart_tmp_63,yield_nz,by.x="Date",by.y="Date",all.x=T)
mart_tmp_64$Date[length(mart_tmp_64$Date)]-mart_tmp_64$Date[1]+1==length(mart_tmp_64$Date)
mart_tmp_64[1:3,c(1,((ncol(mart_tmp_64)-ncol(yield_nz)):ncol(mart_tmp_64)))]

names(yield_uk)
mart_tmp_65<-merge(mart_tmp_64,yield_uk,by.x="Date",by.y="Date",all.x=T)
mart_tmp_65$Date[length(mart_tmp_65$Date)]-mart_tmp_65$Date[1]+1==length(mart_tmp_65$Date)
mart_tmp_65[1:3,c(1,((ncol(mart_tmp_65)-ncol(yield_uk)):ncol(mart_tmp_65)))]

names(yield_us)
mart_tmp_66<-merge(mart_tmp_65,yield_us,by.x="Date",by.y="Date",all.x=T)
mart_tmp_66$Date[length(mart_tmp_66$Date)]-mart_tmp_66$Date[1]+1==length(mart_tmp_66$Date)
mart_tmp_66[1:3,c(1,((ncol(mart_tmp_66)-ncol(yield_us)):ncol(mart_tmp_66)))]

# ========================================== #
# 70. merge mart_tmp_66 with forex variables #
# ========================================== #
names(fx_aud_usd)
mart_tmp_71<-merge(mart_tmp_66,fx_aud_usd,by.x="Date",by.y="Date",all.x=T)
mart_tmp_71$Date[length(mart_tmp_71$Date)]-mart_tmp_71$Date[1]+1==length(mart_tmp_71$Date)
mart_tmp_71[1:3,c(1,((ncol(mart_tmp_71)-2):ncol(mart_tmp_71)))]

names(fx_cad_usd)
mart_tmp_72<-merge(mart_tmp_71,fx_cad_usd,by.x="Date",by.y="Date",all.x=T)
mart_tmp_72$Date[length(mart_tmp_72$Date)]-mart_tmp_72$Date[1]+1==length(mart_tmp_72$Date)
mart_tmp_72[1:3,c(1,((ncol(mart_tmp_72)-2):ncol(mart_tmp_72)))]

names(fx_cny_usd)
mart_tmp_73<-merge(mart_tmp_72,fx_cny_usd,by.x="Date",by.y="Date",all.x=T)
mart_tmp_73$Date[length(mart_tmp_73$Date)]-mart_tmp_73$Date[1]+1==length(mart_tmp_73$Date)
mart_tmp_73[1:3,c(1,((ncol(mart_tmp_73)-2):ncol(mart_tmp_73)))]

names(fx_eur_usd)
mart_tmp_74<-merge(mart_tmp_73,fx_eur_usd,by.x="Date",by.y="Date",all.x=T)
mart_tmp_74$Date[length(mart_tmp_74$Date)]-mart_tmp_74$Date[1]+1==length(mart_tmp_74$Date)
mart_tmp_74[1:3,c(1,((ncol(mart_tmp_74)-2):ncol(mart_tmp_74)))]

names(fx_gbp_usd)
mart_tmp_75<-merge(mart_tmp_74,fx_gbp_usd,by.x="Date",by.y="Date",all.x=T)
mart_tmp_75$Date[length(mart_tmp_75$Date)]-mart_tmp_75$Date[1]+1==length(mart_tmp_75$Date)
mart_tmp_75[1:3,c(1,((ncol(mart_tmp_75)-2):ncol(mart_tmp_75)))]

names(fx_jpy_usd)
mart_tmp_76<-merge(mart_tmp_75,fx_jpy_usd,by.x="Date",by.y="Date",all.x=T)
mart_tmp_76$Date[length(mart_tmp_76$Date)]-mart_tmp_76$Date[1]+1==length(mart_tmp_76$Date)
mart_tmp_76[1:3,c(1,((ncol(mart_tmp_76)-2):ncol(mart_tmp_76)))]

names(fx_nzd_usd)
mart_tmp_77<-merge(mart_tmp_76,fx_nzd_usd,by.x="Date",by.y="Date",all.x=T)
mart_tmp_77$Date[length(mart_tmp_77$Date)]-mart_tmp_77$Date[1]+1==length(mart_tmp_77$Date)
mart_tmp_77[1:3,c(1,((ncol(mart_tmp_77)-2):ncol(mart_tmp_77)))]

names(mart_tmp_77)

mart_mrg<-mart_tmp_77

save(mart_mrg,file="data/mart_mrg.rdata")
