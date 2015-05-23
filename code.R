library(dplyr)
library(car)
library(jpeg)

path <- setwd("~/Documents/Data Science/Turbo Vane/Run1")
files <- list.files(path,full.names = F)
files <- matrix(unlist(strsplit(x=files,split = "\\.")),ncol=2,byrow=T)[,1]
fn <- files[1]
edgeExtract <- function(fn,offsets=c(600,320),size=c(130,1380)){
    #     x <- "05"
    #     offsets <- c(600,320)
    #     size <- c(130,1380)
    # system(sprintf("convert %s.jpg -auto-orient %sr.png",fn,fn))
    jp <- readJPEG(paste(fn,".jpg",sep = ""))
    j <- jp[,,1]
    writeJPEG(image = j,target = "red.jpg")
    j <- jp[,,2]
    writeJPEG(image = j,target = "green.jpg")
    j <- jp[,,3]
    writeJPEG(image = j,target = "blue.jpg")
    system(sprintf("convert red.jpg -contrast -contrast -contrast red.jpg"))
 #   system(sprintf("convert %s.jpg -crop %sx%s+%s+%s %sr.jpg",
 #                  fn,size[1],size[2],offsets[1],offsets[2],fn))
     # radiusxsigma{+lower-percent}{+upper-percent}
    system(sprintf("convert red.jpg -canny .001x1+16%%+25%% canny.jpg"))
#    system(sprintf("convert %sr.png -canny .1x1+10%%+15%% canny.png",fn)) 
    system("convert canny.jpg -bordercolor white -fill red -draw \"color
           120,1000 filltoborder\" cred.png")
    system("convert canny.jpg -fill red -draw \"color 0,0 floodfill\" -alpha off -fill black +opaque red -fill white -opaque red binary.png")
    system("convert binary.png -background none -fill red -morphology edgein octagon:1 edge.png")
    system("convert edge.png -flip edge.png")
    system(sprintf("convert canny.jpg txt:- | grep \"white\\|gray(255)\" | sed -n 's/^\\([0-9]*,[0-9]*\\).*$/\\1/p' > %s.txt",fn))
    #widthxheight{+threshold}
    system(sprintf("convert canny.jpg -background none -fill red -stroke red -strokewidth 1 -hough-lines 20x20+210 hough.jpg"))
    #system("convert edge.png -hough-lines 25x25+100 hough.csv")
    system("convert canny.jpg hough.jpg -composite composite.jpg")
}

readData <- function(fn){
    data <- read.delim(paste(fn,'.txt',sep = ""), 
                       header = FALSE, 
                       sep = ",", 
                       dec = ".", 
                       fill = TRUE, 
                       col.names=c('x','y'))
#     subset(data,x>=110 & x<=118)
}

plotData <- function(data){
    #plot(data.sub$x,data.sub$y,type="b",xlim=c(100,120))
    scatterplot(data$x,data$y,grid=T,smoother=F,reg.line=F)    
}

library(jpeg)
j <- readJPEG("v1_1.JPG")
