#load data from ./data/wxdata/weather dir
dir<-"./data/wxdata/"
flist<-list.files(dir,pattern="csv$")
flist<-paste0(dir,flist) 
#apply read.csv function to each element of list
city.temp.list<-lapply(flist,read.csv,header=FALSE,stringsAsFactors=FALSE)
#for each element of a list,combine result into a data.frame
city.temp.df<-ldply(city.temp.list)
#set the names of city.temp.df object
names(city.temp.df)<-c("City","Date","Hour","Temperature")

#remove the duplicate elements in data.frame or array
cities<-unique(city.temp.df$City)
brk=c(seq(-10,100,10),1000)
label10s<-c(as.character(seq(0,100,10)),">100")
wx_range<-colorRampPalette(c(rgb(0,0.5,1),rgb(1,0.35,0)))
