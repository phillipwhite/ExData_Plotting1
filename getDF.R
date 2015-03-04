#library(data.table) 
library(sqldf)


getDF <- function() {
	
	# download the zipfile from the web, if necessary
	zipfile <- "household_power_consumption.zip"
	if (!file.exists(zipfile)) {
		myurl <- "http://d396qusza40orc.cloudfront.net/exdata/data/household_power_consumption.zip"
		setInternet2(use = TRUE)
		download.file(url = myurl, 
			      destfile = zipfile)
		
		# check download has succeeded
		if (!file.exists(zipfile)) {
			print("Warning in plot1.R getDF() - http download failed")
			return
		}
	}
	
	# unzip the zipfile, if necessary
	txtfile <- "household_power_consumption.txt"
	if (!file.exists(txtfile)) {
		unzip(zipfile)
		
		# check unzip has succeeded
		if (!file.exists(txtfile)) {
			print("Warning in plot1.R getDF() - unzip failed")
			return	
		}
	}

	# read in the filtered data from short_textfile
	short_txtfile <- paste("short_", txtfile, sep = "")
	
	# if the short_txtfile has not already been created,
	if (!file.exists(short_txtfile)) {
		# then create short_txtfile
		
		# read the txtfile filtered to have only those rows
		#    where the Date is 1/2/2007 or 2/2/2007
		sqlstr <- "SELECT * FROM file WHERE Date IN (1/2/2007', '2/2/2007')"
		df <- read.csv.sql(file = txtfile, 
				   sql = sqlstr, 
				   header = TRUE,  
				   sep = ";")
		closeAllConnections()
		
		# save the filtered data to short_textfile
		write.table(x = df, 
			    file = short_txtfile, 
			    sep = ";", 
			    row.names= FALSE)		
		
	} else {		
		# read the filtered data from short_textfile
		df <- read.table(file = short_txtfile, 
				 sep=";", 
				 header=TRUE, 
				 stringsAsFactors = FALSE)			
		
	} 
	
	# add a column for datetime, using Date and Time
	df$datetime <- strptime(x = paste(df$Date, df$Time), 
				format = "%d/%m/%Y %H:%M:%S")
	
	# return value is the dataframe
	df
}