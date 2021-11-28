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
png(filename = "plot1.png", bg = "transparent", width = 480, height = 480)
with(data, hist(Global_active_power,col = "red", 
        xlab="Global Active Power (kilowatts)", main= "Global Active Power"))
cod <- dev.off()