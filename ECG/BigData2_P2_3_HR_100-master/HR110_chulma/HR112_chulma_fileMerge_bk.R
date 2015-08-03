## 2011
filenames <- list.files(path = "./chulma/busan/2011")
setwd("./chulma/busan/2011")
fileMerge <- do.call("rbind", lapply(filenames, read.csv, fileEncoding="CP949"))
write.csv(fileMerge, "../../chulma_busan_2011.txt")
setwd("../../../")

## 2012
filenames <- list.files(path = "./chulma/busan/2012")
setwd("./chulma/busan/2012")
fileMerge <- do.call("rbind", lapply(filenames, read.csv, fileEncoding="CP949"))
write.csv(fileMerge, "../../chulma_busan_2012.txt")
setwd("../../../")

## 2013
filenames <- list.files(path = "./chulma/busan/2013")
setwd("./chulma/busan/2013")
fileMerge <- do.call("rbind", lapply(filenames, read.csv, fileEncoding="CP949"))
write.csv(fileMerge, "../../chulma_busan_2013.txt")
setwd("../../../")

## 2014
filenames <- list.files(path = "./chulma/busan/2014")
setwd("./chulma/busan/2014")
fileMerge <- do.call("rbind", lapply(filenames, read.csv, fileEncoding="CP949"))
write.csv(fileMerge, "../../chulma_busan_2014.txt")
setwd("../../../")
