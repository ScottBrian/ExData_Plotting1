# script to create plot2
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
plotdata <- plotdata[which(!is.na(plotdata$Date) & !is.na(plotdata$Global_active_power) & !is.na(plotdata$Time)  
                             & dmy(plotdata$Date) >= startDate & dmy(plotdata$Date) <= stopDate),c("Date", "Time","Global_active_power")]

# relace the "Date" column with the "Date" and "Time" as POSIXct objects
plotdata[,"Date"] <- dmy(plotdata[,"Date"]) + hms(plotdata[,"Time"])

# open the output device (file), create the plot, and close the output device (file) 
png(filename = "plot2.png", width = 480, height = 480, bg="white")
plot(x = plotdata[,"Date"], y = as.numeric(plotdata[,"Global_active_power"]), type="l", xlab = " ", ylab = "Global Active Power (kilowatts)")
dev.off()