# To download
# http://race.kra.co.kr/kdb/common/Data_viewFile.jsp?fn=chollian/seoul/jungbo/rcresult/20110108dacom11.rpt&meet=1&site_flag=company

# To browse
# http://race.kra.co.kr/kdb/common/Data_viewFile.jsp?f=chollian/seoul/jungbo/rcresult/20110108dacom11.rpt&meet=1&site_flag=

library(stringr)

## Contents & Local
Contents <- "rcresult"
Local  <- "seoul"

## Read 6 months at a time
startDate <- "2011-01-01" 
endDate <- "2011-06-30"

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
rcresult <- sprintf('%s?fn=chollian/%s/jungbo/%s/%sdacom11.rpt&meet=%s&site_flag=company', master, Local, Contents, selectDates, meet)

## get files
for (i in 1:length(rcresult)){
  ex <- readLines(rcresult[i], encoding="CP949")
  FileName <- paste("./HR150_result/",Local,"/tmp/",Contents, "_", Local, "_", selectDates[i],".txt",sep="")
  if(length(ex)>100) write.csv(ex, FileName)
}
