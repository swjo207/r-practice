## 2011
filenames <- list.files(path = "./HR110_chulma/seoul/2011")
setwd("./HR110_chulma/seoul/2011")
fileMerge <- do.call("rbind", lapply(filenames, read.csv, fileEncoding="CP949"))
write.csv(fileMerge, "../../HR110_chulma_seoul_2011.txt")
setwd("../../../")

## 2012
filenames <- list.files(path = "./HR110_chulma/seoul/2012") 
setwd("./HR110_chulma/seoul/2012")
fileMerge <- do.call("rbind", lapply(filenames, read.csv, fileEncoding="CP949"))
write.csv(fileMerge, "../../HR110_chulma_seoul_2012.txt")
setwd("../../../")

## 2013
filenames <- list.files(path = "./HR110_chulma/seoul/2013") 
setwd("./HR110_chulma/seoul/2013")
fileMerge <- do.call("rbind", lapply(filenames, read.csv, fileEncoding="CP949"))
write.csv(fileMerge, "../../HR110_chulma_seoul_2013.txt")
setwd("../../../")

## 2014
filenames <- list.files(path = "./HR110_chulma/seoul/2014") 
setwd("./HR110_chulma/seoul/2014")
fileMerge <- do.call("rbind", lapply(filenames, read.csv, fileEncoding="CP949"))
write.csv(fileMerge, "../../HR110_chulma_seoul_2014.txt")
setwd("../../../")
