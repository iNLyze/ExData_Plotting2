library(dplyr)
library(lubridate)

download.and.unzip <- function(directory = ".") {
        url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
        destfile <- "ExData_Plotting2_Data.zip"
        path <- paste(directory, "\\", destfile, sep = "")
        download.file(url, path, method = "auto")
        print(paste("Unzipping to ", path, sep = ""))
        unzip(path, exdir = directory)
        print("Done.")
}

read.energy.data <- function(directory = ".", file) {
        path <- paste(directory, "\\", file, sep = "")
        data <- readRDS(path)
        data <- tbl_df(data)
        data
}

join.tables <- function(table1, table2) {
        
}

