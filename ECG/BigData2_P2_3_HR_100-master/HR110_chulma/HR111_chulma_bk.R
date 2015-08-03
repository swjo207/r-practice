library(stringr)

## Contents & Local
Contents <- "chulma"
Local  <- "seoul" ## "seoul", "busan", "jeju"

## Read 6 months at a time
startDate <- "2012-07-01" 
endDate <- "2012-12-31"

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

## busan url
rcresult <- sprintf('%s?fn=chollian/%s/jungbo/%s/%sdacom01.rpt&meet=%s&site_flag=company',
                    master, Local, Contents, selectDates, meet)

for (i in 1:length(rcresult))
{
  ex <- readLines(rcresult[i], encoding="CP949")
  FileName <- paste("./chulma/",Local,"/tmp/",Contents, "_", Local, "_", selectDates[i],".txt",sep="")
  if(length(ex)>10) write.csv(ex, FileName)
}
