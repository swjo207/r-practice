load("data/lm_model.rdata")

?step

l_lm<-lm(f_krw_usd~1,train_data[,-1])

# forward
lm_fx_fwd<-step(l_lm,scope=(upper=f_krw_usd~1 + c_copper + c_corn + c_gold + c_oil_brent + c_oil_wti + c_gas + c_silver + f_aud_usd + f_cad_usd + f_cny_usd + f_eur_usd + f_gbp_usd + f_jpy_usd + f_nzd_usd + y_ca_1m + y_ca_3m + y_ca_6m + y_ca_1yr + y_ca_3yr + y_ca_5yr + y_ca_10yr + y_jp_1yr + y_jp_3yr + y_jp_5yr + y_jp_10yr + y_fr_1m + y_fr_3m + y_fr_6m + y_fr_1yr + y_fr_10yr + y_nz_1m + y_nz_3m + y_nz_6m + y_nz_1yr + y_nz_5yr + y_nz_10yr + y_uk_5yr + y_uk_10yr + y_us_1m + y_us_3m + y_us_6m + y_us_1yr + y_us_3yr + y_us_5yr + y_us_10yr + s_cac40 + s_dax + s_nasdaq + s_nikkei + s_nyse + s_snp500 + s_ssec + u_index + f_krw_aud + f_krw_cny + f_krw_gbp + f_krw_eur + y_krx_b + y_krx_g_3yr + y_krx_g_5yr + y_krx_g_10yr + y_krx_t + s_kospi + s_krx_100 + s_krx_autos + s_krx_energy + s_krx_it + s_krx_semicon + s_krx_ship_build + s_krx_steels + s_krx_trans),direction="forward")
summary(lm_fx_fwd)

# backward
lm_fx_bwd<-step(lm_fx,direction="backward")
summary(lm_fx_bwd)

# both
lm_fx_bth<-step(lm_fx,direction="both")
summary(lm_fx_bth)
