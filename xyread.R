data <- read.delim('xy.txt', 
                   header = FALSE, 
                   sep = ",", 
                   dec = ".", 
                   fill = TRUE, 
                   col.names=c('x','y'))
data.sub<-subset(data,x>=110 & x<=118)
plot(data.sub$x,data.sub$y)
