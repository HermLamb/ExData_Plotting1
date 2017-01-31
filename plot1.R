################################################################################
#
## aim: plot 1 of assignment 1 of the Exploratory Data Analysis course
## date: 2017-01-27
#
################################################################################

## load required libraries
library(dplyr)


## create output directory
outdir <- 'plots'
dir.create( outdir, showWarnings = FALSE )


# --------------------------------------------------------------------------
# download data
# --------------------------------------------------------------------------

fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file( fileURL, "data/power.zip")
unzip("data/power.zip", exdir = "./data")
unlink("data/power.zip")

# --------------------------------------------------------------------------
# read data
# --------------------------------------------------------------------------

## read table, subset for dates "1/2/2007" and "2/2/2007"
data <- read.table("data/household_power_consumption.txt", sep = ";", 
                 header = TRUE )
df <- data[data$Date == "1/2/2007" | data$Date == "2/2/2007",]

## replace all "?" by NA
newdf <- data.frame(matrix(ncol = 0, nrow = 2880))

for( i in names(df)[c(3:9)]){
  d <- df[,i]
  d <- as.data.frame(d)
  colnames(d) <- i
  d[d=="?"] <- NA
  newdf <- cbind(newdf, d)
}


## transform Date to date-variable and Time to time-variable
date <- as.Date(df$Date, "%d/%m/%Y")
x <- paste(date, df$Time, sep = ";")
newdf$DateTime <- strptime(x, "%Y-%m-%d;%H:%M:%S")

## transform numeric values to numeric
newdf$Global_active_power <- as.numeric(as.character(newdf$Global_active_power))
newdf$Global_reactive_power <- as.numeric(as.character(newdf$Global_reactive_power))
newdf$Voltage <- as.numeric(as.character(newdf$Voltage))
newdf$Global_intensity <- as.numeric(as.character(newdf$Global_intensity))
newdf$Sub_metering_1 <- as.numeric(as.character(newdf$Sub_metering_1))
newdf$Sub_metering_2 <- as.numeric(as.character(newdf$Sub_metering_2))


# --------------------------------------------------------------------------
# create plot 1
# --------------------------------------------------------------------------

png(file = "plots/plot1.png", width = 480, height = 480, units = "px")
hist(newdf$Global_active_power, col = 'red', main = "Global Active Power", 
     xlab = "Global Active Power (kilowatts)")
dev.off()
