# Determine if subsetted power consumption file exists
if (!file.exists("../hpc.2days.csv")) {
    # No - read the full power consumption file.
    hpc <- read.table("../household_power_consumption.txt", 
          header=T, sep=";", na.strings = "?")

    # Subset it for the two days of interest.
    hpc.2days <- subset(hpc,
        hpc$Date == "1/2/2007" | hpc$Date == "2/2/2007")
    # Write a CSV file to save time on subsequent runs.
    write.csv(hpc.2days, "../hpc.2days.csv")
} else {
    # We've filtered and processed the dataset previously, so re-read that.
    hpc.2days <- read.csv("../hpc.2days.csv")
}

# Prepare to write a PNG file.
png(file = "plot1.png", width = 480, height = 480)

# Make a histogram of Global Active Power in kW.
hist(hpc.2days$Global_active_power, xlab="Global Active Power (kilowatts)",
    col="red", main="Global Active Power")

# Finished writing PNG file - close graphics device.
dev.off()
