library(sqldf)

# Function  to download, if necessary, and read in the data
#   filtered just for the dates 1/2/2007 and 2/2/2007
# Arguments: none
# Returns: TRUE if download and unzip succeeded
#
downloadFile <- function() {
	# download the zipfile from the web, if necessary
	zipfile <- "household_power_consumption.zip"
	if (!file.exists(zipfile)) {
		myurl <- "http://d396qusza40orc.cloudfront.net/exdata/data/household_power_consumption.zip"
		setInternet2(use = TRUE)
		download.file(url = myurl, 
			      destfile = zipfile)
		
		# check download has succeeded
		if (!file.exists(zipfile)) {
			print("Warning in plot1.R downloadFile() - http download failed")
			return(FALSE)
		}
	}
	
	# unzip the zipfile, if necessary
	txtfile <- "household_power_consumption.txt"
	if (!file.exists(txtfile)) {
		unzip(zipfile)
		
		# check unzip has succeeded
		if (!file.exists(txtfile)) {
			print("Warning in plot1.R downloadFile() - unzip failed")
			return(FALSE)
		}
	}
	return(TRUE)
}


# Function to read in the data filtered just for the dates 1/2/2007 and 2/2/2007
# Arguments: none
# Returns: a data frame with the data and an additional column for datetime
#
getDF <- function() {	
	txtfile <- "household_power_consumption.txt"
	
	# if the file is not found, then download it
	if (!file.exists(txtfile)) {
		success <- downloadFile()
	}
	
	# prepare to read in the filtered data from short_textfile
	short_txtfile <- paste("short_", txtfile, sep = "")
	
	# if the short_txtfile has not already been created, 
	if (!file.exists(short_txtfile)) {
		# then create short_txtfile
		
		# read the txtfile, filtered to have only those rows
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
			    row.names = FALSE)			
	} else {		
		# read the filtered data directly from short_textfile
		df <- read.table(file = short_txtfile, 
				 sep = ";", 
				 header = TRUE, 
				 stringsAsFactors = FALSE)			
	} 
	
	# add a column for datetime, using Date and Time
	df$datetime <- strptime(x = paste(df$Date, df$Time), 
				format = "%d/%m/%Y %H:%M:%S")
	
	# return value is the dataframe
	df
}


#################################
## Function to produce Plot 4  ##
#################################
plot4 <- function() {
	png("plot4.png")      # draw to a png file 
			      # - using default size of 480 x 480 pixels
	par(mfrow = c(2, 2))  # prepare to make 4 plots in 2 x 2 array
	
	with(getDF(), {       # read in the data
		
		# Upper left plot
		plot(x = datetime, 
		     y = Global_active_power, 
		     type="l", 
		     xlab = "",
		     ylab = "Global Active Power")
		
		
		# Upper Right plot
		plot(x = datetime, 
		     y = Voltage, 
		     type = "l")		
		
		
		# Lower Left plot, with three lines and a legend
		plot(x = datetime, 
		     y = Sub_metering_1, 
		     type = "l", col="black",
		     xlab = "", 
		     ylab= "Energy sub metering")
		
		lines(x = datetime, 
		      y = Sub_metering_2, 
		      type = "l", col="red")
		
		lines(x = datetime, 
		      y = Sub_metering_3, 
		      type = "l", col="blue")	
		
		legend("topright", lty = 1, bty = "n",
		       legend = c("Sub_metering_1",
		       	   	"Sub_metering_2",
	       	   		"Sub_metering_3"),
		       col = c("black", "red", "blue"))
		
		
		# Lower Right plot
		plot(x = datetime, 
		     y = Global_reactive_power, 
		     type = "l")
		
	})
	par(mfrow = c(1, 1))
	dev.off()
}