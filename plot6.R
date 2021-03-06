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


## Get codes for all motor vehicles
##motorV <- as.character(SCC$SCC[which(grepl("motor", SCC$Short.Name, ignore.case = TRUE))])
## For motor vehicles it was chosen to use SCC.Level.One == "Mobile Sources" and those entries
## in "Storage and Transport" which contain "Transport" as this seems to stem from 
## mobile vehicles as well.
motorV <- SCC %>%
        select(SCC, Short.Name, SCC.Level.One) %>%
        filter( (grepl("Transport", Short.Name, ignore.case = TRUE) &
                         SCC.Level.One == "Storage and Transport") |
                        SCC.Level.One == "Mobile Sources")



#Save some memory: Select only Baltimore City and Los Angeles
BC <- NEI %>%
        filter(fips == "24510" | fips == "06037")
        ##Re-arrange with tidyr or mutate ?? to create new column "city"
        ##Use this later in faceting
rm(NEI)

# Now find those entries in Baltimore City which stem from motor vehicles
BC <- inner_join(BC, motorV)

# Factorize fips for plotting
BC$fips <- as.factor(BC$fips)
levels(BC$fips) <- c("LA County", "Baltimore City")

#Open png file for plotting
png(file = "plot6.png", width = 960, height = 680)

## Make the plot
g <- with(BC, qplot(
        log(Emissions), 
        data = BC, 
        binwidth = 2, 
        fill = type
) 
) 

## Add some more layers
g +
        facet_grid(facets = fips ~ year) + 
        labs(x = expression('log(PM'[2.5]*' emissions)')) +
        labs(y = "Frequency") +
        labs(title = expression('PM'[2.5]*' emissions from mobile vehicles in Baltimore City and LA County over time')) +
        stat_bin(breaks = seq(-20, 10, 3)) +
        theme(panel.margin.x = unit(1, "lines"))


#Close the file
dev.off()

