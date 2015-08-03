# install.packages("Quandl")
library(Quandl)
library(xlsx)
Quandl.auth("__________") # input your authentification token

# =================== #
# 01. krw_usd: target #
# =================== #

fx_krw_usd<-Quandl("QUANDL/USDKRW", trim_start="2009-07-01", trim_end="2014-06-30")
str(fx_krw_usd)
fx_krw_usd<-fx_krw_usd[,-c(3:4)]
names(fx_krw_usd)[2]<-"f_krw_usd"
fx_krw_usd<-fx_krw_usd[order(fx_krw_usd$Date),]
head(fx_krw_usd,3);tail(fx_krw_usd,3)

# ================================ #
# 11. Interst Rate (Domestic: KRX) #
# ================================ #

# yield_krx_b
yield_krx_b_2010<-read.xlsx("krx/krx_bond_index_2010.xls",1,colIndex=c(1:2),header=T)
yield_krx_b_2011<-read.xlsx("krx/krx_bond_index_2011.xls",1,colIndex=c(1:2),header=T)
yield_krx_b_2012<-read.xlsx("krx/krx_bond_index_2012.xls",1,colIndex=c(1:2),header=T)
yield_krx_b_2013<-read.xlsx("krx/krx_bond_index_2013.xls",1,colIndex=c(1:2),header=T)
yield_krx_b_2014<-read.xlsx("krx/krx_bond_index_2014.xls",1,colIndex=c(1:2),header=T)
yield_krx_b<-rbind(yield_krx_b_2010,yield_krx_b_2011,yield_krx_b_2012,yield_krx_b_2013,yield_krx_b_2014)
str(yield_krx_b)
names(yield_krx_b)<-c("Date","y_krx_b")
yield_krx_b$Date<-as.Date(yield_krx_b$Date)
yield_krx_b<-yield_krx_b[order(yield_krx_b$Date),]
head(yield_krx_b,3);tail(yield_krx_b,3)

# yield_krx_g
yield_krx_g_2010<-read.xlsx("krx/krx_g_bond_prc_2010.xls",1,colIndex=c(1:2,4,6),header=T)
yield_krx_g_2011<-read.xlsx("krx/krx_g_bond_prc_2011.xls",1,colIndex=c(1:2,4,6),header=T)
yield_krx_g_2012<-read.xlsx("krx/krx_g_bond_prc_2012.xls",1,colIndex=c(1:2,4,6),header=T)
yield_krx_g_2013<-read.xlsx("krx/krx_g_bond_prc_2013.xls",1,colIndex=c(1:2,4,6),header=T)
yield_krx_g_2014<-read.xlsx("krx/krx_g_bond_prc_2014.xls",1,colIndex=c(1:2,4,6),header=T)
yield_krx_g<-rbind(yield_krx_g_2010,yield_krx_g_2011,yield_krx_g_2012,yield_krx_g_2013,yield_krx_g_2014)
str(yield_krx_g)
names(yield_krx_g)<-c("Date","y_krx_g_3yr","y_krx_g_5yr","y_krx_g_10yr")
yield_krx_g$Date<-as.Date(yield_krx_g$Date)
yield_krx_g<-yield_krx_g[order(yield_krx_g$Date),]
head(yield_krx_g,3);tail(yield_krx_g,3)

# yield_krx_t
yield_krx_t_2010<-read.xlsx("krx/krx_t_bond_index_2010.xls",1,colIndex=c(1,6),header=T)
yield_krx_t_2011<-read.xlsx("krx/krx_t_bond_index_2011.xls",1,colIndex=c(1,6),header=T)
yield_krx_t_2012<-read.xlsx("krx/krx_t_bond_index_2012.xls",1,colIndex=c(1,6),header=T)
yield_krx_t_2013<-read.xlsx("krx/krx_t_bond_index_2013.xls",1,colIndex=c(1,6),header=T)
yield_krx_t_2014<-read.xlsx("krx/krx_t_bond_index_2014.xls",1,colIndex=c(1,6),header=T)
yield_krx_t<-rbind(yield_krx_t_2010,yield_krx_t_2011,yield_krx_t_2012,yield_krx_t_2013,yield_krx_t_2014)
str(yield_krx_t)
names(yield_krx_t)<-c("Date","y_krx_t")
yield_krx_t$Date<-as.Date(yield_krx_t$Date)
yield_krx_t<-yield_krx_t[order(yield_krx_t$Date),]
head(yield_krx_t,3);tail(yield_krx_t,3)

# ================================================= #
# 12. Stock Market Industrial Index (Domestic: KRX) #
# ================================================= #

# stck_kospi
stck_kospi<-Quandl("YAHOO/INDEX_KS11", trim_start="2009-07-01", trim_end="2014-06-30")
str(stck_kospi)
stck_kospi<-stck_kospi[,c(1,5)]
names(stck_kospi)[2]<-"s_kospi"
stck_kospi<-stck_kospi[order(stck_kospi$Date),]
head(stck_kospi,3);tail(stck_kospi,3)

# stck_krx_100
stck_krx_100_2010<-read.xlsx("krx/krx_100_2010.xls",1,colIndex=c(1:2),header=T)
stck_krx_100_2011<-read.xlsx("krx/krx_100_2011.xls",1,colIndex=c(1:2),header=T)
stck_krx_100_2012<-read.xlsx("krx/krx_100_2012.xls",1,colIndex=c(1:2),header=T)
stck_krx_100_2013<-read.xlsx("krx/krx_100_2013.xls",1,colIndex=c(1:2),header=T)
stck_krx_100_2014<-read.xlsx("krx/krx_100_2014.xls",1,colIndex=c(1:2),header=T)
stck_krx_100<-rbind(stck_krx_100_2010,stck_krx_100_2011,stck_krx_100_2012,stck_krx_100_2013,stck_krx_100_2014)
str(stck_krx_100)
names(stck_krx_100)<-c("Date","s_krx_100")
stck_krx_100$Date<-as.Date(stck_krx_100$Date)
stck_krx_100<-stck_krx_100[order(stck_krx_100$Date),]
head(stck_krx_100,3);tail(stck_krx_100,3)

# stck_krx_autos
stck_krx_autos_2010<-read.xlsx("krx/krx_auto_2010.xls",1,colIndex=c(1:2),header=T)
stck_krx_autos_2011<-read.xlsx("krx/krx_auto_2011.xls",1,colIndex=c(1:2),header=T)
stck_krx_autos_2012<-read.xlsx("krx/krx_auto_2012.xls",1,colIndex=c(1:2),header=T)
stck_krx_autos_2013<-read.xlsx("krx/krx_auto_2013.xls",1,colIndex=c(1:2),header=T)
stck_krx_autos_2014<-read.xlsx("krx/krx_auto_2014.xls",1,colIndex=c(1:2),header=T)
stck_krx_autos<-rbind(stck_krx_autos_2010,stck_krx_autos_2011,stck_krx_autos_2012,stck_krx_autos_2013,stck_krx_autos_2014)
str(stck_krx_autos)
names(stck_krx_autos)<-c("Date","s_krx_autos")
stck_krx_autos$Date<-as.Date(stck_krx_autos$Date)
stck_krx_autos<-stck_krx_autos[order(stck_krx_autos$Date),]
head(stck_krx_autos,3);tail(stck_krx_autos,3)

# stck_krx_energy
stck_krx_energy_2010<-read.xlsx("krx/krx_energy_2010.xls",1,colIndex=c(1:2),header=T)
stck_krx_energy_2011<-read.xlsx("krx/krx_energy_2011.xls",1,colIndex=c(1:2),header=T)
stck_krx_energy_2012<-read.xlsx("krx/krx_energy_2012.xls",1,colIndex=c(1:2),header=T)
stck_krx_energy_2013<-read.xlsx("krx/krx_energy_2013.xls",1,colIndex=c(1:2),header=T)
stck_krx_energy_2014<-read.xlsx("krx/krx_energy_2014.xls",1,colIndex=c(1:2),header=T)
stck_krx_energy<-rbind(stck_krx_energy_2010,stck_krx_energy_2011,stck_krx_energy_2012,stck_krx_energy_2013,stck_krx_energy_2014)
str(stck_krx_energy)
names(stck_krx_energy)<-c("Date","s_krx_energy")
stck_krx_energy$Date<-as.Date(stck_krx_energy$Date)
stck_krx_energy<-stck_krx_energy[order(stck_krx_energy$Date),]
head(stck_krx_energy,3);tail(stck_krx_energy,3)

# stck_krx_it
stck_krx_it_2010<-read.xlsx("krx/krx_it_2010.xls",1,colIndex=c(1:2),header=T)
stck_krx_it_2011<-read.xlsx("krx/krx_it_2011.xls",1,colIndex=c(1:2),header=T)
stck_krx_it_2012<-read.xlsx("krx/krx_it_2012.xls",1,colIndex=c(1:2),header=T)
stck_krx_it_2013<-read.xlsx("krx/krx_it_2013.xls",1,colIndex=c(1:2),header=T)
stck_krx_it_2014<-read.xlsx("krx/krx_it_2014.xls",1,colIndex=c(1:2),header=T)
stck_krx_it<-rbind(stck_krx_it_2010,stck_krx_it_2011,stck_krx_it_2012,stck_krx_it_2013,stck_krx_it_2014)
str(stck_krx_it)
names(stck_krx_it)<-c("Date","s_krx_it")
stck_krx_it$Date<-as.Date(stck_krx_it$Date)
stck_krx_it<-stck_krx_it[order(stck_krx_it$Date),]
head(stck_krx_it,3);tail(stck_krx_it,3)

# stck_krx_semicon
stck_krx_semicon_2010<-read.xlsx("krx/krx_semicon_2010.xls",1,colIndex=c(1:2),header=T)
stck_krx_semicon_2011<-read.xlsx("krx/krx_semicon_2011.xls",1,colIndex=c(1:2),header=T)
stck_krx_semicon_2012<-read.xlsx("krx/krx_semicon_2012.xls",1,colIndex=c(1:2),header=T)
stck_krx_semicon_2013<-read.xlsx("krx/krx_semicon_2013.xls",1,colIndex=c(1:2),header=T)
stck_krx_semicon_2014<-read.xlsx("krx/krx_semicon_2014.xls",1,colIndex=c(1:2),header=T)
stck_krx_semicon<-rbind(stck_krx_semicon_2010,stck_krx_semicon_2011,stck_krx_semicon_2012,stck_krx_semicon_2013,stck_krx_semicon_2014)
str(stck_krx_semicon)
names(stck_krx_semicon)<-c("Date","s_krx_semicon")
stck_krx_semicon$Date<-as.Date(stck_krx_semicon$Date)
stck_krx_semicon<-stck_krx_semicon[order(stck_krx_semicon$Date),]
head(stck_krx_semicon,3);tail(stck_krx_semicon,3)

# stck_krx_ship_build
stck_krx_ship_build_2010<-read.xlsx("krx/krx_ship_build_2010.xls",1,colIndex=c(1:2),header=T)
stck_krx_ship_build_2011<-read.xlsx("krx/krx_ship_build_2011.xls",1,colIndex=c(1:2),header=T)
stck_krx_ship_build_2012<-read.xlsx("krx/krx_ship_build_2012.xls",1,colIndex=c(1:2),header=T)
stck_krx_ship_build_2013<-read.xlsx("krx/krx_ship_build_2013.xls",1,colIndex=c(1:2),header=T)
stck_krx_ship_build_2014<-read.xlsx("krx/krx_ship_build_2014.xls",1,colIndex=c(1:2),header=T)
stck_krx_ship_build<-rbind(stck_krx_ship_build_2010,stck_krx_ship_build_2011,stck_krx_ship_build_2012,stck_krx_ship_build_2013,stck_krx_ship_build_2014)
str(stck_krx_ship_build)
names(stck_krx_ship_build)<-c("Date","s_krx_ship_build")
stck_krx_ship_build$Date<-as.Date(stck_krx_ship_build$Date)
stck_krx_ship_build<-stck_krx_ship_build[order(stck_krx_ship_build$Date),]
head(stck_krx_ship_build,3);tail(stck_krx_ship_build,3)

# stck_krx_steels
stck_krx_steels_2010<-read.xlsx("krx/krx_steels_2010.xls",1,colIndex=c(1:2),header=T)
stck_krx_steels_2011<-read.xlsx("krx/krx_steels_2011.xls",1,colIndex=c(1:2),header=T)
stck_krx_steels_2012<-read.xlsx("krx/krx_steels_2012.xls",1,colIndex=c(1:2),header=T)
stck_krx_steels_2013<-read.xlsx("krx/krx_steels_2013.xls",1,colIndex=c(1:2),header=T)
stck_krx_steels_2014<-read.xlsx("krx/krx_steels_2014.xls",1,colIndex=c(1:2),header=T)
stck_krx_steels<-rbind(stck_krx_steels_2010,stck_krx_steels_2011,stck_krx_steels_2012,stck_krx_steels_2013,stck_krx_steels_2014)
str(stck_krx_steels)
names(stck_krx_steels)<-c("Date","s_krx_steels")
stck_krx_steels$Date<-as.Date(stck_krx_steels$Date)
stck_krx_steels<-stck_krx_steels[order(stck_krx_steels$Date),]
head(stck_krx_steels,3);tail(stck_krx_steels,3)

# stck_krx_trans
stck_krx_trans_2010<-read.xlsx("krx/krx_trans_2010.xls",1,colIndex=c(1:2),header=T)
stck_krx_trans_2011<-read.xlsx("krx/krx_trans_2011.xls",1,colIndex=c(1:2),header=T)
stck_krx_trans_2012<-read.xlsx("krx/krx_trans_2012.xls",1,colIndex=c(1:2),header=T)
stck_krx_trans_2013<-read.xlsx("krx/krx_trans_2013.xls",1,colIndex=c(1:2),header=T)
stck_krx_trans_2014<-read.xlsx("krx/krx_trans_2014.xls",1,colIndex=c(1:2),header=T)
stck_krx_trans<-rbind(stck_krx_trans_2010,stck_krx_trans_2011,stck_krx_trans_2012,stck_krx_trans_2013,stck_krx_trans_2014)
str(stck_krx_trans)
names(stck_krx_trans)<-c("Date","s_krx_trans")
stck_krx_trans$Date<-as.Date(stck_krx_trans$Date)
stck_krx_trans<-stck_krx_trans[order(stck_krx_trans$Date),]
head(stck_krx_trans,3);tail(stck_krx_trans,3)

# ==================== #
# 13. Forex (Domestic) #
# ==================== #

# fx_krw_aud
fx_krw_aud<-Quandl("QUANDL/AUDKRW", trim_start="2009-07-01", trim_end="2014-06-30")
str(fx_krw_aud)
fx_krw_aud<-fx_krw_aud[,c(1,2)]
names(fx_krw_aud)[2]<-"f_krw_aud"
fx_krw_aud<-fx_krw_aud[order(fx_krw_aud$Date),]
head(fx_krw_aud,3);tail(fx_krw_aud,3)

# fx_krw_cny
fx_krw_cny<-Quandl("QUANDL/CNYKRW", trim_start="2009-07-01", trim_end="2014-06-30")
str(fx_krw_cny)
fx_krw_cny<-fx_krw_cny[,c(1,2)]
names(fx_krw_cny)[2]<-"f_krw_cny"
fx_krw_cny<-fx_krw_cny[order(fx_krw_cny$Date),]
head(fx_krw_cny,3);tail(fx_krw_cny,3)

# fx_krw_gbp
fx_krw_gbp<-Quandl("QUANDL/GBPKRW", trim_start="2009-07-01", trim_end="2014-06-30")
str(fx_krw_gbp)
fx_krw_gbp<-fx_krw_gbp[,c(1,2)]
names(fx_krw_gbp)[2]<-"f_krw_gbp"
fx_krw_gbp<-fx_krw_gbp[order(fx_krw_gbp$Date),]
head(fx_krw_gbp,3);tail(fx_krw_gbp,3)

# fx_krw_eur
fx_krw_eur<-Quandl("QUANDL/EURKRW", trim_start="2009-07-01", trim_end="2014-06-30")
str(fx_krw_eur)
fx_krw_eur<-fx_krw_eur[,c(1,2)]
names(fx_krw_eur)[2]<-"f_krw_eur"
fx_krw_eur<-fx_krw_eur[order(fx_krw_eur$Date),]
head(fx_krw_eur,3);tail(fx_krw_eur,3)

# ========================================= #
# 21. Trade Weighted US Dollar Index: Broad #
# ========================================= #

usd_index<-Quandl("FRED/DTWEXB", trim_start="2009-07-01", trim_end="2014-06-30")
str(usd_index)
names(usd_index)[2]<-"u_index"
usd_index<-usd_index[order(usd_index$Date),]
head(usd_index,3);tail(usd_index,3)

# =================================== #
# 22. Commodity Index (International) #
# =================================== #

# cmd_copper
cmd_copper<-Quandl("WSJ/COPPER", trim_start="2009-07-01", trim_end="2014-06-30")
str(cmd_copper)
names(cmd_copper)[2]<-"c_copper"
cmd_copper<-cmd_copper[order(cmd_copper$Date),]
head(cmd_copper,3);tail(cmd_copper,3)

# cmd_corn
cmd_corn<-Quandl("WSJ/CORN_FEED", trim_start="2009-07-01", trim_end="2014-06-30")
str(cmd_corn)
names(cmd_corn)[2]<-"c_corn"
cmd_corn<-cmd_corn[order(cmd_corn$Date),]
head(cmd_corn,3);tail(cmd_corn,3)

# cmd_gold
cmd_gold<-Quandl("LBMA/GOLD", trim_start="2009-07-01", trim_end="2014-06-30")
str(cmd_gold)
cmd_gold<-cmd_gold[,-c(2,4:7)]
names(cmd_gold)[2]<-"c_gold"
cmd_gold<-cmd_gold[order(cmd_gold$Date),]
head(cmd_gold,3);tail(cmd_gold,3)

# cmd_oil_brent
cmd_oil_brent<-Quandl("FRED/DCOILBRENTEU", trim_start="2009-07-01", trim_end="2014-06-30")
str(cmd_oil_brent)
names(cmd_oil_brent)[2]<-"c_oil_brent"
cmd_oil_brent<-cmd_oil_brent[order(cmd_oil_brent$Date),]
head(cmd_oil_brent,3);tail(cmd_oil_brent,3)

# cmd_oil_wti
cmd_oil_wti<-Quandl("FRED/DCOILWTICO", trim_start="2009-07-01", trim_end="2014-06-30")
str(cmd_oil_wti)
names(cmd_oil_wti)[2]<-"c_oil_wti"
cmd_oil_wti<-cmd_oil_wti[order(cmd_oil_wti$Date),]
head(cmd_oil_wti,3);tail(cmd_oil_wti,3)

# cmd_gas
cmd_gas<-Quandl("YAHOO/INDEX_XNG", trim_start="2009-07-01", trim_end="2014-06-30")
str(cmd_gas)
cmd_gas<-cmd_gas[,c(1,5)]
names(cmd_gas)[2]<-"c_gas"
cmd_gas<-cmd_gas[order(cmd_gas$Date),]
head(cmd_gas,3);tail(cmd_gas,3)

# cmd_silver
cmd_silver<-Quandl("LBMA/SILVER", trim_start="2009-07-01", trim_end="2014-06-30")
str(cmd_silver)
cmd_silver<-cmd_silver[,c(1,2)]
names(cmd_silver)[2]<-"c_silver"
cmd_silver<-cmd_silver[order(cmd_silver$Date),]
head(cmd_silver,3);tail(cmd_silver,3)

# ====================================== #
# 23. Stock Market Index (International) #
# ====================================== #

# stck_cac40
stck_cac40<-Quandl("YAHOO/INDEX_FCHI", trim_start="2009-07-01", trim_end="2014-06-30")
str(stck_cac40)
stck_cac40<-stck_cac40[,c(1,5)]
names(stck_cac40)[2]<-"s_cac40"
stck_cac40<-stck_cac40[order(stck_cac40$Date),]
head(stck_cac40,3);tail(stck_cac40,3)

# stck_dax
stck_dax<-Quandl("YAHOO/INDEX_GDAXI", trim_start="2009-07-01", trim_end="2014-06-30")
str(stck_dax)
stck_dax<-stck_dax[,c(1,5)]
names(stck_dax)[2]<-"s_dax"
stck_dax<-stck_dax[order(stck_dax$Date),]
head(stck_dax,3);tail(stck_dax,3)

# stck_nasdaq
stck_nasdaq<-Quandl("NASDAQOMX/NDX", trim_start="2009-07-01", trim_end="2014-06-30")
str(stck_nasdaq)
stck_nasdaq<-stck_nasdaq[,c(1,2)]
names(stck_nasdaq)<-c("Date","s_nasdaq")
stck_nasdaq<-stck_nasdaq[order(stck_nasdaq$Date),]
head(stck_nasdaq,3);tail(stck_nasdaq,3)

# stck_nikkei
stck_nikkei<-Quandl("YAHOO/INDEX_N225", trim_start="2009-07-01", trim_end="2014-06-30")
str(stck_nikkei)
stck_nikkei<-stck_nikkei[,c(1,5)]
names(stck_nikkei)[2]<-"s_nikkei"
stck_nikkei<-stck_nikkei[order(stck_nikkei$Date),]
head(stck_nikkei,3);tail(stck_nikkei,3)

# stck_nyse
stck_nyse<-Quandl("YAHOO/INDEX_NYA", trim_start="2009-07-01", trim_end="2014-06-30")
str(stck_nyse)
stck_nyse<-stck_nyse[,c(1,5)]
names(stck_nyse)[2]<-"s_nyse"
stck_nyse<-stck_nyse[order(stck_nyse$Date),]
head(stck_nyse,3);tail(stck_nyse,3)

# stck_snp500
stck_snp500<-Quandl("YAHOO/INDEX_GSPC", trim_start="2009-07-01", trim_end="2014-06-30")
str(stck_snp500)
stck_snp500<-stck_snp500[,c(1,5)]
names(stck_snp500)[2]<-"s_snp500"
stck_snp500<-stck_snp500[order(stck_snp500$Date),]
head(stck_snp500,3);tail(stck_snp500,3)

# stck_ssec
stck_ssec<-Quandl("YAHOO/INDEX_SSEC", trim_start="2009-07-01", trim_end="2014-06-30")
str(stck_ssec)
stck_ssec<-stck_ssec[,c(1,5)]
names(stck_ssec)[2]<-"s_ssec"
stck_ssec<-stck_ssec[order(stck_ssec$Date),]
head(stck_ssec,3);tail(stck_ssec,3)

# ================================= #
# 24. Interest Rate (International) #
# ================================= #

# yield_ca
yield_ca<-Quandl("YIELDCURVE/CAN", trim_start="2009-07-01", trim_end="2014-06-30")
str(yield_ca)
yield_ca<-yield_ca[,c(1:5,7,8,10)]
names(yield_ca)[2:8]<-c("y_ca_1m","y_ca_3m","y_ca_6m","y_ca_1yr","y_ca_3yr","y_ca_5yr","y_ca_10yr")
yield_ca<-yield_ca[order(yield_ca$Date),]
head(yield_ca,3);tail(yield_ca,3)

# yield_jp
yield_jp<-Quandl("YIELDCURVE/JPN", trim_start="2009-07-01", trim_end="2014-06-30")
str(yield_jp)
yield_jp<-yield_jp[,c(1,2,4,6,11)]
names(yield_jp)[2:5]<-c("y_jp_1yr","y_jp_3yr","y_jp_5yr","y_jp_10yr")
yield_jp<-yield_jp[order(yield_jp$Date),]
head(yield_jp,3);tail(yield_jp,3)

# yield_fr
yield_fr<-Quandl("YIELDCURVE/FRA", trim_start="2009-07-01", trim_end="2014-06-30")
str(yield_fr)
yield_fr<-yield_fr[,c(1:4,6,8,9)]
names(yield_fr)[2:7]<-c("y_fr_1m","y_fr_3m","y_fr_6m","y_fr_1yr","y_fr_5yr","y_fr_10yr")
yield_fr<-yield_fr[order(yield_fr$Date),]
head(yield_fr,3);tail(yield_fr,3)

# yield_nz
yield_nz<-Quandl("YIELDCURVE/NZL", trim_start="2009-07-01", trim_end="2014-06-30")
str(yield_nz)
yield_nz<-yield_nz[,-6]
names(yield_nz)[2:7]<-c("y_nz_1m","y_nz_3m","y_nz_6m","y_nz_1yr","y_nz_5yr","y_nz_10yr")
yield_nz<-yield_nz[order(yield_nz$Date),]
head(yield_nz,3);tail(yield_nz,3)

# yield_uk
yield_uk<-Quandl("YIELDCURVE/GBR", trim_start="2009-07-01", trim_end="2014-06-30")
str(yield_uk)
yield_uk<-yield_uk[,-4]
names(yield_uk)[2:3]<-c("y_uk_5yr","y_uk_10yr")
yield_uk<-yield_uk[order(yield_uk$Date),]
head(yield_uk,3);tail(yield_uk,3)

# yield_us
yield_us<-Quandl("YIELDCURVE/USA", trim_start="2009-07-01", trim_end="2014-06-30")
str(yield_us)
yield_us<-yield_us[,c(1:5,7,8,10)]
names(yield_us)[2:8]<-c("y_us_1m","y_us_3m","y_us_6m","y_us_1yr","y_us_3yr","y_us_5yr","y_us_10yr")
yield_us<-yield_us[order(yield_us$Date),]
head(yield_us,3);tail(yield_us,3)

# ========================= #
# 25. Forex (International) #
# ========================= #

# fx_aud_usd
fx_aud_usd<-Quandl("QUANDL/USDAUD", trim_start="2009-07-01", trim_end="2014-06-30")
str(fx_aud_usd)
fx_aud_usd<-fx_aud_usd[,-c(3,4)]
names(fx_aud_usd)[2]<-"f_aud_usd"
fx_aud_usd<-fx_aud_usd[order(fx_aud_usd$Date),]
head(fx_aud_usd,3);tail(fx_aud_usd,3)

# fx_cad_usd
fx_cad_usd<-Quandl("QUANDL/USDCAD", trim_start="2009-07-01", trim_end="2014-06-30")
str(fx_cad_usd)
fx_cad_usd<-fx_cad_usd[,-c(3,4)]
names(fx_cad_usd)[2]<-"f_cad_usd"
fx_cad_usd<-fx_cad_usd[order(fx_cad_usd$Date),]
head(fx_cad_usd,3);tail(fx_cad_usd,3)

# fx_cny_usd
fx_cny_usd<-Quandl("QUANDL/USDCNY", trim_start="2009-07-01", trim_end="2014-06-30")
str(fx_cny_usd)
fx_cny_usd<-fx_cny_usd[,-c(3,4)]
names(fx_cny_usd)[2]<-"f_cny_usd"
fx_cny_usd<-fx_cny_usd[order(fx_cny_usd$Date),]
head(fx_cny_usd,3);tail(fx_cny_usd,3)

# fx_eur_usd
fx_eur_usd<-Quandl("BNP/USDEUR", trim_start="2009-07-01", trim_end="2014-06-30")
str(fx_eur_usd)
names(fx_eur_usd)[2]<-"f_eur_usd"
fx_eur_usd<-fx_eur_usd[order(fx_eur_usd$Date),]
head(fx_eur_usd,3);tail(fx_eur_usd,3)

# fx_gbp_usd
fx_gbp_usd<-Quandl("QUANDL/USDGBP", trim_start="2009-07-01", trim_end="2014-06-30")
str(fx_gbp_usd)
fx_gbp_usd<-fx_gbp_usd[,-c(3,4)]
names(fx_gbp_usd)[2]<-"f_gbp_usd"
fx_gbp_usd<-fx_gbp_usd[order(fx_gbp_usd$Date),]
head(fx_gbp_usd,3);tail(fx_gbp_usd,3)

# fx_jpy_usd
fx_jpy_usd<-Quandl("QUANDL/USDJPY", trim_start="2009-07-01", trim_end="2014-06-30")
str(fx_jpy_usd)
fx_jpy_usd<-fx_jpy_usd[,-c(3,4)]
names(fx_jpy_usd)[2]<-"f_jpy_usd"
fx_jpy_usd<-fx_jpy_usd[order(fx_jpy_usd$Date),]
head(fx_jpy_usd,3);tail(fx_jpy_usd,3)

# fx_nzd_usd
fx_nzd_usd<-Quandl("QUANDL/USDNZD", trim_start="2009-07-01", trim_end="2014-06-30")
str(fx_nzd_usd)
fx_nzd_usd<-fx_nzd_usd[,-c(3,4)]
names(fx_nzd_usd)[2]<-"f_nzd_usd"
fx_nzd_usd<-fx_nzd_usd[order(fx_nzd_usd$Date),]
head(fx_nzd_usd,3);tail(fx_nzd_usd,3)

# =============== #
# 99. Data Backup #
# =============== #

save(fx_krw_usd,yield_krx_b,yield_krx_g,yield_krx_t,stck_kospi,stck_krx_100,stck_krx_autos,stck_krx_energy,stck_krx_it,stck_krx_semicon,stck_krx_ship_build,stck_krx_steels,stck_krx_trans,fx_krw_aud,fx_krw_cny,fx_krw_gbp,fx_krw_eur,usd_index,cmd_copper,cmd_corn,cmd_gold,cmd_oil_brent,cmd_oil_wti,cmd_gas,cmd_silver,stck_cac40,stck_dax,stck_nasdaq,stck_nikkei,stck_nyse,stck_snp500,stck_ssec,yield_ca,yield_jp,yield_fr,yield_nz,yield_uk,yield_us,fx_aud_usd,fx_cad_usd,fx_cny_usd,fx_eur_usd,fx_gbp_usd,fx_jpy_usd,fx_nzd_usd,file="data/mart_raw.rdata")
