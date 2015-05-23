system("convert original.jpeg -auto-level leveled.png")
system("convert leveled.png -canny 0x1+10%+10% canny.png")
system("convert canny.png -fill red -draw \"color 0,0 floodfill\" -alpha off -fill black +opaque red -fill white -opaque red binary.png")
system("convert binary.png -background none -fill red -morphology edgein octagon:1 edge.png")
system("convert edge.png -flip edge.png")
system("convert edge.png txt:- | grep \"white\\|gray(255)\" | sed -n 's/^\\([0-9]*,[0-9]*\\).*$/\\1/p' > xy.txt")
system("convert edge.png -background none -fill red -stroke red -strokewidth 1 -hough-lines 25x25+100 hough.png")
system("convert edge.png -hough-lines 25x25+100 hough.csv")
system("convert leveled.png -flip hough.png -composite composite.png")
data <- read.delim('xy.txt', 
                   header = FALSE, 
                   sep = ",", 
                   dec = ".", 
                   fill = TRUE, 
                   col.names=c('x','y'))
data.sub<-subset(data,x>=110 & x<=118)
#plot(data.sub$x,data.sub$y,type="b",xlim=c(100,120))
library(car)
scatterplot(data.sub$x,data.sub$y,boxplots="x",xlim=c(100,120),grid=T)
