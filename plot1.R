library(data.table) 

## PLEASE ALSO READ getDF.R 
##   which contains the code to download, unzip and read in the data
source("getDF.R")

plot1 <- function() {
# 	png("plot1.png")  # draw to a png file
	with(getDF(), {   # read in the data
		
		# then plot the histogram with the data
		hist(x = Global_active_power,
		     main = "Global Active Power",
		     xlab = "Global Active Power (kilowatts)",
		     ylab = "Frequency", 
		     col = "red")
	})
# 	dev.off()
}