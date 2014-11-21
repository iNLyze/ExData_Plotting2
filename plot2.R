library(dplyr)
source('getAndLoadData.R')

#Fetch the data, unzip and read it
directory <- "..\\ExData_Plotting2_Data"
download.and.unzip(directory)
fL <- as.character(c("summarySCC_PM25.rds", "Source_Classification_Code.rds"))
NEI <- read.energy.data(directory, fL[1])
SCC <- read.energy.data(directory, fL[2])


#Calculate total emissions using dplyr and filter for region (fips)
yE <- NEI %>%
        filter(fips == "24510") %>%
        group_by(year) %>%
        summarise(yearly.emissions = sum(Emissions))


#Open png file for plotting
png(file = "plot2.png")

#More space at left margin
par(mar=c(4,6,2,2))

#Prepare plot and axis titles, no ticks for x-axis
plot(yE$year, yE$yearly.emissions / 10^3, type = "n", xaxt = "n", main = expression('Total yearly emissions of PM'[2.5]*' in Baltimore City'), xlab = "Year", ylab = expression('PM'[2.5]*' Emissions'*' [10'^3* ' tons]'))

#Draw blue line
lines(yE$year, yE$yearly.emissions / 10^3, lwd = 2, col = "blue")

#Draw x-axis ticks
axis(side = 1, yE$year)

#Close the file
dev.off()


