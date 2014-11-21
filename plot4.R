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


## Get codes for all coal related emitters
## Quick testing with grepl revealed the columns in SCC which contain the string "coal"
## It was decided to use the union of all of these hits
coal <- SCC %>%
        select(SCC, Short.Name, SCC.Level.One, SCC.Level.Two, SCC.Level.Three, SCC.Level.Four) %>%
        filter( grepl("coal", Short.Name, ignore.case = TRUE) |
                         grepl("coal", SCC.Level.Three, ignore.case = TRUE) |
                                  grepl("coal", SCC.Level.Four, ignore.case = TRUE)
        )

# Now find those entries in NEI which stem from coal related emitters
BC <- inner_join(NEI, coal)
# Save some memory
rm(NEI)

#Open png file for plotting
png(file = "plot4.png", width = 960, height = 480)

## Make the plot
g <- with(BC, qplot(
        log(Emissions), 
        data = BC, 
        facets = .~year, 
        binwidth = 2 
        ) 
) 

## Add some more layers
g +
        facet_grid(facets = . ~ year) + 
        labs(x = expression('log(PM'[2.5]*' emissions)')) +
        labs(y = "Frequency") +
        labs(title = expression('Total PM'[2.5]*' emissions from coal-related emitters in the U.S. over time')) +
        stat_bin(breaks = seq(-20, 10, 3)) +
        theme(panel.margin.x = unit(1, "lines"))


#Close the file
dev.off()
