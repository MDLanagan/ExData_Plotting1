#data set from course website, original source http://archive.ics.uci.edu/ml/
#file to create time series of Sub_metering

#get users working directory
fPath<-getwd()

#test if file already downloaded (assumes file with same name but different data does not exist
#    but works around trying to download on protected systems)
if(!file.exists(file.path(fPath,"household_power_consumption.txt"))){
#Download and unzip the file (if on a scanned system this step may be blocked, download manually and unzip to wd)
fileUrl <-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileUrl,destfile="exdata_data_household_power_consumption.zip")
unzip("exdata_data_household_power_consumption.zip", overwrite = TRUE,exdir = ".")}
if(file.exists(file.path(fPath,"household_power_consumption.txt"))) { 

hpcdata<-read.table("household_power_consumption.txt", nrows = 6, sep = ";",header = TRUE)
classes <- sapply(hpcdata, class)
hpcdata<-read.table("household_power_consumption.txt", nrows = 6, sep = ";",header = TRUE, colClasses = classes)
getColNames<-colnames(hpcdata)
#format date and time as below
hpcdata$Date<-as.Date(hpcdata$Date,"%d/%m/%Y")
hpcdata$Time<-strptime(paste(hpcdata$Date,hpcdata$Time,sep = " "),"%Y-%m-%d %H:%M:%S", tz="UTC")

#start time
dataStart<-strptime("2007-02-01 00:00:00","%Y-%m-%d %H:%M:%S", tz="UTC")
dataskip<-difftime(dataStart,hpcdata$Time[1],units = "mins")
#get data, skip no of rows to get to start date (+1 for headers), 1440 minutes per day * 2 days = 2880 rows to return
hpcdata<-read.table("household_power_consumption.txt", skip=dataskip+1,nrows = 2*1440, sep = ";",col.names = getColNames,colClasses = classes)
#covert dates to class date 
hpcdata$Date<-as.Date(hpcdata$Date,"%d/%m/%Y")
#combine date and time 
hpcdata$Time<-strptime(paste(hpcdata$Date,hpcdata$Time,sep = " "),"%Y-%m-%d %H:%M:%S", tz="UTC")



#plot 3
tPath<-file.path(fPath,"plot3.png")
png(tPath)
plot(hpcdata$Time,hpcdata$Sub_metering_1,type = "l",ylab = "Energy sub metering",xlab = "")
points(hpcdata$Time,hpcdata$Sub_metering_2,col="red",type = "l")
points(hpcdata$Time,hpcdata$Sub_metering_3,col="blue",type = "l")
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2","Sub_metering_3"),col = c("black","red","blue") ,lty = 1)
dev.off()
 }


