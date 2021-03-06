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
## Function to produce Plot 3  ##
#################################
plot3 <- function() {
	png("plot3.png")  # draw to a png file
			  # - using default size of 480 x 480 pixels

	with(getDF(), {   # read in the data
		
		# draw three lines and a legend
		
		# plot first line in black
		plot(x = datetime, 
		     y = Sub_metering_1, 
		     type = "l", col="black",
		     xlab = "", 
		     ylab= "Energy sub metering")
		
		# draw second line in red
		lines(x = datetime, 
		      y = Sub_metering_2, 
		      type = "l", col="red")
		
		# draw third line in blue
		lines(x = datetime, 
		      y = Sub_metering_3, 
		      type = "l", col="blue")
		
		# draw the legend
		legend("topright", lty = 1,
		       legend = c("Sub_metering_1",
		       	   	"Sub_metering_2",
		       	   	"Sub_metering_3"),
		       col = c("black", "red", "blue"))
	})
	dev.off()
}