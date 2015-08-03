# To Download
# http://race.kra.co.kr/kdb/common/Data_viewFile.jsp?fn=chollian/seoul/jungbo/chulma/20110106dacom01.rpt&meet=1&site_flag=company

# For Contents
# http://race.kra.co.kr/kdb/common/Data_viewFile.jsp?fn=chollian/seoul/jungbo/chulma/20110106dacom01.rpt&meet=1&site_flag=
  
library(stringr)

## Contents & Local
Contents <- "chulma"
Local  <- "seoul"

## Read 6 months at a time
startDate <- "2014-06-18"
endDate <- "2014-06-22"

## date function
selectDate <- function(startDate, endDate){
  duration <- seq.Date(as.Date(startDate), as.Date(endDate), by = "1 day")
  duration <- as.character(duration)
  Year <- substr(duration, 1, 4)
  Month <- substr(duration, 6, 7)
  Day <- substr(duration, 9, 10)
  ymd <- paste(Year, Month, Day, sep="")
}

## meet function
selectLocal <- function(x){
  if (x == "seoul") 1
  else if (x == "jeju") 2
  else if (x == "busan") 3
}

master <- 'http://race.kra.co.kr/kdb/common/Data_viewFile.jsp'
meet <- selectLocal(Local)
selectDates <- selectDate(startDate, endDate)

## seoul url
rcresult <- sprintf('%s?fn=chollian/%s/jungbo/%s/%sdacom01.rpt&meet=%s&site_flag=company',
                    master, Local, Contents ,selectDates, meet)

for (i in 1:length(rcresult)){
  ex <- readLines(rcresult[i], encoding="CP949")
  FileName <- paste("./HR110_chulma/",Local,"/tmp/",Contents, "_", Local, "_", selectDates[i],".txt",sep="")
  if(length(ex)>10) write.csv(ex, FileName)
}
