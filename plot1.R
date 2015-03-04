library(data.table) 
library(sqldf)


getDF <- function() {
	zipfile <- "household_power_consumption.zip"
	if (!file.exists(zipfile)) {
		url <- "http://d396qusza40orc.cloudfront.net/exdata/data/household_power_consumption.zip"
		setInternet2(use = TRUE)
		if (download.file(url, zipfile) != 0) {
			print("Warning in plot1.R download() - http download failed")
			return
		}
	}
	
	unzip(zipfile)
	txtfile <- "household_power_consumption.txt"
	if (!file.exists(txtfile)) {
		print("Warning in plot1.R download() - unzip failed")
		return	
	}
	
	short_txtfile <- paste("short_", txtfile, sep = "")
	if (file.exists(short_txtfile)) {
		
		# read back filtered text file
		df <- read.table(short_txtfile, sep=";", header=TRUE, stringsAsFactors = FALSE)
	
	} else {
		
		# read in a filtered file
		sql <- "SELECT * FROM file WHERE Date = '1/2/2007' OR Date = '2/2/2007'"
		df <- read.csv.sql(txtfile, sql = sql, header = TRUE,  sep = ";")
		closeAllConnections()
		
		# and save the filtered file
		write.table(df, file = short_txtfile, sep = ";", row.names= FALSE)	
	} 
	df$datetime <- strptime(paste(df$Date, df$Time), "%d/%m/%Y %H:%M:%S")
	df
}

plot1 <- function() {
# 	png("plot1.png")
	with(getDF(), {
		hist(Global_active_power,
		     main = "Global Active Power",
		     xlab = "Global Active Power (kilowatts)",
		     ylab = "Frequency", 
		     col = "red")
	})
# 	dev.off()
}