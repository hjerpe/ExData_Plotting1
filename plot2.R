# Adam Hjerpe 2014-06-07.
# Project1 coursera Exploratory Data analysis.
# Ploting timeseries of Global Active Power over two days 2007-02-01
# and 2007-02-02 vs Dates (with time stamp) from the data
# "Individual household electric power consumption Data Set" from the
# machine learning repository http://archive.ics.uci.edu/ml/ .

# Info about data set,
#1.date: Date in format dd/mm/yyyy
#2.time: time in format hh:mm:ss
#3.global_active_power: household global minute-averaged active power (in kilowatt)
#4.global_reactive_power: household global minute-averaged reactive power (in kilowatt)
#5.voltage: minute-averaged voltage (in volt)
#6.global_intensity: household global minute-averaged current intensity (in ampere)
#7.sub_metering_1: (in watt-hour of active energy).
#It corresponds to the kitchen, containing mainly a dishwasher, an oven and a microwave
#(hot plates are not electric but gas powered).
#8.sub_metering_2: (in watt-hour of active energy).
#It corresponds to the laundry room, containing a washing-machine, a tumble-drier, a
#refrigerator and a light.
#9.sub_metering_3: (in watt-hour of active energy).
#It corresponds to an electric water-heater and an air-conditioner.

setwd("./programming/ExData//ExDataProj1")
# Create directory and download data.
if (!file.exists('./data1')){
    dir.create('./data1/')
    # If we do not want to save zip file on computer the we can use a tempfile.
    #temp <- tempfile()
    #download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",temp)
    #unlink(temp)
    download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",destfile="./data1/household_power_consumption.zip")
}
# Try later to use sql to search for desired dates.
#close.connection('./data/household_power_consumption.txt')
#library(sqldf)
#DF4 <- read.csv.sql(fn, sql = 'select * from file where Date >= "1985-01-01"')

# Read data the desired dates are 2007-02-01 and 2007-02-02.
# (na:s are encoded as ?).
con <- unz('./data1/household_power_consumption.zip',
           filename='household_power_consumption.txt',encoding="UTF-8")
powerData1 <- read.table(con,sep=';',header=TRUE,skip=60000,nrows=10000,
                         na.strings='?')

# Adding correct column names.
con <- unz('./data1/household_power_consumption.zip',
           filename='household_power_consumption.txt',encoding="UTF-8")
strNames <- names(read.table(con,sep=';',header=TRUE,nrows=1))
names(powerData1) <- strNames

# Fix date format and fetch subset with desired dates.
powerData1$Date <- as.Date(powerData1$Date,format="%d/%m/%Y")
startdate <- as.Date("01/02/2007",format="%d/%m/%Y")
enddate <- as.Date("02/02/2007",format="%d/%m/%Y")
powerData2 <- powerData1[powerData1$Date==startdate | powerData1$Date==enddate,]

# Adjoin dates and times.
xTimes <-  as.POSIXlt(paste(powerData2$Date,
                            as.character(powerData2$Time)),tz="GMT")

Sys.setlocale("LC_TIME", "English") # Change to non-local time zone.

# Plot and save time series of date times vs Global Active Power (kilowatts).
png(filename = "plot2.png",width = 480, height = 480) # Open file to save plot on disk.
plot(xTimes,powerData2$Global_active_power,type="n",
     xlab="",
     ylab="Global Active Power (kilowatts)")
lines(xTimes,powerData2$Global_active_power,
      xlab="",
      ylab ="")
dev.off()
