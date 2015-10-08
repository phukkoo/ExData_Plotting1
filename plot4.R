# the code assumes that the household_power_consumption.txt file is present in the current working directory
# read temp file if it exists. This file was created by prgramatically containing all the data needed in correct format
if(!file.exists("temp_plot_data.txt")) {
        full_data_file <- read.table("household_power_consumption.txt", na.strings = "?", sep=";" ,colClasses = c("character", "character", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric"), header = TRUE)
        # create new colums for datetime
        full_data_file$datetime <- strptime(paste(full_data_file$Date,full_data_file$Time), "%d/%m/%Y %H:%M:%S")
        # find time between these 2 values
        min_time = strptime("1/2/2007 00:00:00", "%d/%m/%Y %H:%M:%S")
        max_time = strptime("2/2/2007 23:59:00", "%d/%m/%Y %H:%M:%S")
        # filter out the data for the 2 days we need 01/02/20007 and 02/02/2007
        data_file <-subset (full_data_file, datetime >= min_time & datetime  <= max_time)
} else {
}        data_file <- read.table("temp_plot_data.txt", na.strings = "?", sep=" " ,colClasses = c("character", "character", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "POSIXct"), header = TRUE)

#plot 3 consist of 4 plots arranges in a 2 X 2 matrix format
#open png file device
png(filename = "plot4.png",width = 480, height = 480, units = "px")
#in order to arrange  in a 2 X 2 matrix formay
par(mfrow = c(2, 2)) 
# then we create the  4 desired plots 
with(data_file, {
        plot(datetime, Global_active_power, type="l", ylab = " Global Active Power", xlab ="")
        plot(datetime, Voltage, type="l", ylab = " Voltage",  xlab = "datetime") 
        with(data_file, plot(datetime, Sub_metering_1, type = "n", ylim = range(c(data_file$Sub_metering_1, data_file$Sub_metering_2, data_file$Sub_metering_3)) ,ylab = " Energy sub metering", xlab = " "))
        with(data_file, lines(datetime, Sub_metering_1, col = "black"))
        with(data_file, lines(datetime, Sub_metering_2, col = "red"))
        with(data_file, lines(datetime, Sub_metering_3, col = "blue"))
        legend("topright", lty = "solid", col = c("black", "blue", "red"),  bty = "n", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
        plot(datetime, Global_reactive_power, type="l", xlab = "datetime") })


#close the device file
dev.off()
# write required data frame  into temp file so we do not need to read the complete file again
write.table(data_file, "temp_plot_data.txt", row.name=FALSE)