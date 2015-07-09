#===========================================
# 8강 SQL (p206)
#===========================================
install.packages("sqldf")
library(sqldf)
?sqldf

s <- read.table("d:/r_sample/survey_h.txt", header=TRUE); s
#class(sqldf("select * from s")) # data.frame 
#mode(sqldf("select * from s"))  # list 

sqldf("select * from s")  # p206
sqldf("select id,gender,wage from s")
sqldf("select id,gender,wage from s limit 5")
sqldf("select id,gender,wage from s order by age") # p206 데이터정렬
sqldf("select id,gender,wage from s order by gender,age") # 변수2개 정렬
sqldf("select id,gender,wage from s order by 2,3")  # p207 변수gender,age
sqldf("select id,gender,wage from s order by gender,age desc ") #p208 남여별, 연령 내림차순

# SQL – where
sqldf("select * from s where gender = 'F'")  #p209
sqldf("select * from s where gender <> 'F'")
sqldf("select * from s where wage >= 60") #p210
sqldf("select * from s where id >= 'A036' AND wage >= 60")
sqldf("select * from s where id >= 'A036' OR wage >= 60")
sqldf("select * from s where wage between 50 and 60")  # p211

# SQL - in 연산자
sqldf("select * from s where id in('A001','A036')") #p212
sqldf("select * from s where id in(select id from s where wage>60)")
sqldf("select * from s where  wage>60")

# 와일드카드 % p213
sqldf("select * from s where id like 'A%'")  # A로 시작하는 전부
sqldf("select * from s where id like 'A01%'")
sqldf("select * from s where id like '%3%'")
sqldf("select * from s where id like 'A%7'")

# SQL – where, order by  필터링 후, 정렬 p215
sqldf("select * from s where id >= 'A036' AND wage >= 60 order by age")

sqldf("select id,his,work,pay,his+work+pay from s") # 계산식
sqldf("select id,his,work,pay,his+work+pay as sat from s")

sqldf("select sum(wage), avg(wage) as m_wge from s") # 기술통계 구하기 P216
sqldf("select count(wage) from s")  # 빈도수 구하기

sqldf("select sum(wage), avg(wage) as m_wge from s group by gender") # group by p219

sqldf("select sum(wage), avg(wage)  from s group by gender having sum(wage) > 900")
# where 절은 그룹화하기전.... having 절은 데이터를 그룹화한 뒤에 
# where 절에 제외된 것은 그룹에 포함되지 않음
# where 절로 대상을 먼저 제외하고, group by 로 대상에 한해 그룹화한 다음
# having 절로 각 그룹을 필터링한다

