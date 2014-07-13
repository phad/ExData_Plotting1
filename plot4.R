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

# Add a datetime column by pasting Date and Time and parsing the result.
hpc.2days$datetime <- strptime(
    paste(as.character(hpc.2days$Date), as.character(hpc.2days$Time)),
    format="%d/%m/%Y %H:%M:%S")

# Prepare to write a PNG file.
png(file = "plot4.png", width = 480, height = 480)

# Make a 2x2 set of plots.
par(mfrow = c(2, 2))
with(hpc.2days, {
    plot(datetime, Global_active_power, type="l", xlab = "",
        ylab = "Global Active Power")
    plot(datetime, Voltage, type="l", ylab = "Voltage")
    with(hpc.2days, {
        plot(datetime, Sub_metering_1, type="n", xlab = "", ylab= "Energy sub metering")
        par(col="black")
        lines(datetime, Sub_metering_1)

        par(col="red")
        lines(datetime, Sub_metering_2)

        par(col="blue")
        lines(datetime, Sub_metering_3)

        par(col="black")
        legend("topright", lwd = 1, col = c("black", "red", "blue"),
            legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
    })
    plot(datetime, Global_reactive_power, type="l")
})
par(mfrow = c(1, 1))

# Finished writing PNG file - close graphics device.
dev.off()
