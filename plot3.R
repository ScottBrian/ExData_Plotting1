# script to create plot3
# need lubridate for date time manipulations 
library(lubridate)

# download and unzip the data  
temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",temp)
plotdata <- read.table(unz(temp, "household_power_consumption.txt"), header=TRUE, sep=";", colClasses="character", na.strings="?")
unlink(temp)

# we will need 2 days of data starting Feb 1 2007 and ending Feb 2 2007 
startDate <- dmy("01/02/2007")
stopDate <- dmy("02/02/2007")

# clean the data - get the 2 days, filtered for NAs, with the columns needed for the plot     
plotdata <- plotdata[which(!is.na(plotdata$Date) & !is.na(plotdata$Time) 
                           & !is.na(plotdata$Sub_metering_1) & !is.na(plotdata$Sub_metering_2) & !is.na(plotdata$Sub_metering_3)
                           & dmy(plotdata$Date) >= startDate & dmy(plotdata$Date) <= stopDate),
                              c("Date", "Time","Sub_metering_1", "Sub_metering_2", "Sub_metering_3")]

# relace the "Date" column with the "Date" and "Time" as POSIXct objects
plotdata[,"Date"] <- dmy(plotdata[,"Date"]) + hms(plotdata[,"Time"])

# open the output device (file), create the plot, and close the output device (file) 
png(filename = "plot3.png", width = 480, height = 480, bg="white")
plot(x = plotdata[,"Date"], y = as.numeric(plotdata[,"Sub_metering_1"]), type="n", xlab = " ", ylab = "Energy sub metering")
lines(x = plotdata[,"Date"], y = as.numeric(plotdata[,"Sub_metering_1"]), type="l", col = "black")
lines(x = plotdata[,"Date"], y = as.numeric(plotdata[,"Sub_metering_2"]), type="l", col = "green")
lines(x = plotdata[,"Date"], y = as.numeric(plotdata[,"Sub_metering_3"]), type="l", col = "blue")
legend("topright", col = c("black", "green", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), bty = "0", lty = 1)
dev.off()