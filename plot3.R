library(dplyr)
library(ggplot2)
library(grid)
source('getAndLoadData.R')

#Fetch the data, unzip and read it
directory <- "..\\ExData_Plotting2_Data"
download.and.unzip(directory)
fL <- as.character(c("summarySCC_PM25.rds", "Source_Classification_Code.rds"))
NEI <- read.energy.data(directory, fL[1])
SCC <- read.energy.data(directory, fL[2])

#Factorize NEI for plotting with ggplot2
NEI$type <- as.factor(NEI$type)

#Save some memory: Select only Baltimore City and Los Angeles
BCLA <- NEI %>%
        filter(fips == "24510" | fips == "06037")
rm(NEI)


#Calculate total emissions using dplyr
yE <- BCLA %>% 
        filter(fips == "24510") %>%                     #Filter for Baltimore City
        group_by(year, type) %>%                              
        summarise(yearly.emissions = sum(Emissions))    #Sum up in new column

#Open png file for plotting
png(file = "plot3.png", width = 960, height = 480)


## Setup ggplot with data frame
g <- ggplot(yE, aes(year, yearly.emissions))
        
## Add layers
with(yE, 
g       + geom_smooth(method="lm", se=FALSE, col="steelblue", lwd=2, alpha = 0.5)
        + geom_point(size = 4) 
        + facet_grid(. ~ type, space = "fixed") 
        + labs(x = "Year") 
        + labs(y = expression('PM'[2.5]*' emissions [tons]')) 
        + labs(title = expression('Yearly emissions of PM'[2.5]*' in Baltimore City by type'))
        + scale_x_continuous(breaks = unique(year))
        + theme(panel.margin.x = unit(1, "lines"))
)
                
#Close the file
dev.off()

