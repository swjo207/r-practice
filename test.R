video <- read.csv("비디오대여.csv",header=T)
video.list <- split(video$ID,dvd$ID)

str(video.list)
video.trans <- as(video.list,"transactions")
video.trans
library(arules)
video.dataFrame <- as(video.trans,"data.frame")
video.rules <- apriori(video.trans)
video.rules <- apriori(video.trans,parameter = list(support=0.3,confidence=0.6))
summary(video.rules)
inspect(video.rules)

#install.packages("arulesViz")
par(mfrow=c(2,2))
plot(video.rules)
plot(video.rules,method="grouped")
plot(video.rules,method="graph")
plot(video.rules,method="graph",control=list(type="items"))
plot(video.rules,method="paracoord", control=list(reorder=TRUE))


data("Adult")
class(Adult)
str(Adult)

rules <- apriori(Adult, parameter=list(supp=0.5,conf=0.9,target="rules"))
summary(rules)
rules <- apriori(Adult,parameter = list(support=0.4))
rules.sub = subset(rules,subset=rhs %pin% "sex" & lift>1.3)
inspect(sort(rules.sub)[1:3])
plot(rules.sub,method="graph")

### Hierarchical Clustering 
x <- matrix (rnorm(100), nrow = 5)
x <- x * 100
dist(x)
par(mfrow=c(2,2))
plot(h<-hclust(dist(x), method = "single"))
plot(h<-hclust(dist(x), method = "complete"))
plot(h<-hclust(dist(x), method = "average"))
plot(h<-hclust(dist(x), method = "centroid"),hang=-1)

## k-means clustering
set.seed(1234)
par(mfrow=c(1,1))
#par(mar=c(2,2,2,2))
x <- rnorm(12,mean = rep(1:3,each=4),sd=0.2)
y <- rnorm(12,mean = rep(c(1,2,1),each=4),sd=0.2)
plot(x,y,col="blue",pch=1,cex=3)
text(x+0.05,y+0.05,labels = as.character(1:12))
