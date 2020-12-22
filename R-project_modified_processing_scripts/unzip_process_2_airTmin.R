
# read output of downloading script

loc<-"/media/juhele/data_2TB/_CRAN/input/"
zips<-list.files(loc,pattern = "*.zip$",full.names = T) # list paths to all zip files in current directory

unzips<-"/media/juhele/data_2TB/_CRAN/unzips/"
setwd(unzips)

for (i in 1:length(zips)){
  unzip(zips[i],exdir=unzips)  # unzip your file 
}


library(data.table)

## min air temperature
files<-list.files(pattern = "*_TMI_N.csv$") # load files based on pattern

years<-lapply(files,fread,skip = "Měsíc",header = T, dec=",",select=1) # find absolute start + end date
min(unlist(lapply(years,min,na.rm=T)))
max(unlist(lapply(years,min,na.rm=T)))

# generate clear time series by day
prvni<-as.POSIXct("1961-01-01",tz="UTC") # start time
posledni<-as.POSIXct("2019-12-31",tz="UTC") # end time
cas<-seq(from=prvni,to=posledni, by=60*60*24) # generate clear time series
 
## cler data frame for joining data together
airTmin<-data.frame(date=cas)
airTmin$date<-as.character(airTmin$date)

records<-lapply(files,fread,skip = "Měsíc",header = T, dec=",",select=c(1:4)) 
# read all csv files starting with line where string "měsíc" is found
# didn not work with "Rok" because of "Rokytnice nad Jizerou"

for (i in 1:length(files)) {
  tm<-data.frame(records[[i]]) # single data frame
  loc<-substr(files[i],1,8) # staton id
  datum<-paste(tm$Rok,tm$Měsíc,tm$Den,sep="-") # construct posix date
  pos<-as.POSIXct(datum)
  cha<-as.character(pos) # convert to character, merge not works with posix
  tms<-data.frame(date=cha,mer=tm$Hodnota) # single station ready for merge
  names(tms)<-c("date",loc)
  airTmin<-merge(airTmin,tms,by="date",all.x = T) # final merge
}

save(airTmin,file="airTmin_merged.RData")
