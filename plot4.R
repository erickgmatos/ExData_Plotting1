con <- file("household_power_consumption.txt", "r")
lines <- c()
header <-  readLines(con, 1)
while(TRUE) {
        line = readLines(con, 1)
        if(length(line) == 0) break
        else if(grepl("^3/2/2007", line)) break
        else if(grepl("^[1-3]/2/2007", line)) lines <- c(lines, line)
}
close(con, type="r")
file2 <- tempfile()
writeLines(c(header,lines),file2)
data <- read.table(file2, sep = ";", na.strings = "?",
                      colClasses = c("character", "character", "numeric",
                                     "numeric", "numeric", "numeric",
                                     "numeric", "numeric", "numeric"),
                      header = TRUE)
unlink(file2)
datatime <- paste(data$Date, data$Time)
datatime <- strptime(datatime, "%d/%m/%Y %H:%M:%S")
data$Time <- datatime
png(filename = "plot4.png", bg = "transparent", width = 480, height = 480)
par(mfcol = c(2,2))
with(data, plot(Time, Global_active_power, type = "l", xlab = "",
                ylab = "Global Active Power (kilowatts)"))
with(data,{
        plot(Time, Sub_metering_1, type = "l", xlab = "", ylab = "Energy sub metering")
        lines(Time, Sub_metering_2, col = "red")
        lines(Time, Sub_metering_3, col = "blue")
        legend("topright", legend= paste0("Sub_metering_", 1:3), lty = c(1,1,1),
               col = c("black", "red", "blue"))
with(data, plot(Time, Voltage, type = "l", xlab = "datetime"))
})
with(data, plot(Time, Global_reactive_power, type = "l", xlab = "datetime"))
cod <-dev.off()
