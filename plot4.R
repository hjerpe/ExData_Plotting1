# Adam Hjerpe 2014-06-08.
# Project1 coursera Exploratory Data analysis.
# Ploting subplots of plot2, plot3, timeseries of voltage and time series of 
# global reactive power over two days 2007-02-01 and 2007-02-02 vs Dates 
# (with time stamp) from the data
# "Individual household electric power consumption Data Set" from the
# machine learning repository http://archive.ics.uci.edu/ml/
# (https://archive.ics.uci.edu/ml/datasets/Individual+household+electric+power+consumption).

# Info about data set,
#1.date: Date in format dd/mm/yyyy
#2.time: time in format hh:mm:ss
#3.global_active_power: household global minute-averaged active power
#(in kilowatt).
#4.global_reactive_power: household global minute-averaged reactive 
#power (in kilowatt).
#5.voltage: minute-averaged voltage (in volt)
#6.global_intensity: household global minute-averaged current intensity 
#(in ampere).
#7.sub_metering_1: (in watt-hour of active energy).
#It corresponds to the kitchen, containing mainly a dishwasher, 
#an oven and a microwave (hot plates are not electric but gas powered).
#8.sub_metering_2: (in watt-hour of active energy).
#It corresponds to the laundry room, containing a washing-machine, 
#a tumble-drier, a refrigerator and a light.
#9.sub_metering_3: (in watt-hour of active energy).
#It corresponds to an electric water-heater and an air-conditioner.

setwd("~/programming/ExData//ExDataProj1")
# Create directory and download data.
if (!file.exists('./data1')){
    dir.create('./data1/')
    download.file(paste0("https://d396qusza40orc.cloudfront.net/", 
                         "exdata%2Fdata%2Fhousehold_power_consumption.zip"), 
                  destfile="./data1/household_power_consumption.zip")
}
con <- unz('./data1/household_power_consumption.zip', 
           filename='household_power_consumption.txt', 
           encoding="UTF-8")
powerData1 <- read.table(con, sep=';', header=TRUE, skip=60000, 
                         nrows=10000, na.strings='?')

# Adding correct column names.
con <- unz('./data1/household_power_consumption.zip', 
           filename='household_power_consumption.txt', 
           encoding="UTF-8")
strNames <- names(read.table(con, sep=';', header=TRUE, nrows=1))
names(powerData1) <- strNames

# Fix date format and fetch subset with desired dates.
powerData1$Date <- as.Date(powerData1$Date, format="%d/%m/%Y")
startdate <- as.Date("01/02/2007", format="%d/%m/%Y")
enddate <- as.Date("02/02/2007", format="%d/%m/%Y")
powerData2 <- powerData1[powerData1$Date==startdate | powerData1$Date==enddate,]

# Adjoin dates and times.
xTimes <-  as.POSIXlt(paste(powerData2$Date, 
                            as.character(powerData2$Time)), tz="GMT")

Sys.setlocale("LC_TIME", "English") # Change to non-local time zone.

# Open file to save plot on disk.
png(filename = "plot4.png", width = 480, height = 480)

# Plot 4 subplots of size 4x4.
par(mfrow = c(2, 2), lwd=0.5)
# Plot 1.
plot(xTimes, powerData2$Global_active_power, type="n", 
     xlab="", 
     ylab="Global Active Power")
lines(xTimes,powerData2$Global_active_power, 
      xlab="", 
      ylab ="")
# Plot 2.
plot(xTimes, powerData2$Voltage,type="n", 
     xlab="datetime", 
     ylab="Voltage")
lines(xTimes, powerData2$Voltage, 
      xlab="", 
      ylab ="")
# Plot 3.
plot(xTimes, powerData2$Sub_metering_1, type="n", 
     xlab="", 
     ylab="Energy sub metering")
lines(xTimes, powerData2$Sub_metering_1, 
      xlab="", 
      ylab ="", 
      col='black')
lines(xTimes, powerData2$Sub_metering_2, 
      xlab="", 
      ylab ="", 
      col='red')
lines(xTimes, powerData2$Sub_metering_3, 
      xlab="", 
      ylab ="", 
      col='blue')
legend("topright", lty=c(1, 1), col = c("black", "blue", "red"), 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
# Plot 4.
with(powerData2, {
    plot(xTimes, Global_reactive_power, type="n", 
         xlab="datetime")
    lines(xTimes, Global_reactive_power, 
          xlab="", ylab ="", type = "l")
})
#graphics.off()
dev.off()