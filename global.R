## Download Baltimore crime data csv file to working directory
if(!file.exists("./Data")){dir.create("./Data")}
destfile="./bmoreCrime2014.csv"
if (!file.exists(destfile)) {
    fileURL <- "https://data.baltimorecity.gov/api/views/59fg-ary5/rows.csv?accessType=DOWNLOAD"   
    download.file(fileURL ,destfile) }

## Load required libraries
library(plotly)
library(leaflet)
library(lubridate)
library(tidyr)
library(dplyr)

## Stage data for presentation
bmoreRaw <- read.csv("bmoreCrime2014.csv", stringsAsFactors = FALSE)
## Splitting location into latitude and longitude
bmoreRaw <- bmoreRaw %>% extract(Location.1, c('lat', 'lng'), '\\(([^,]+), ([^)]+)\\)')
bmoreRaw$CrimeDate <- mdy(bmoreRaw$CrimeDate)
bmoreRaw$lng <- as.numeric(bmoreRaw$lng)
bmoreRaw$lat <- as.numeric(bmoreRaw$lat)
# Set up data to display histogram and line charts
bmoreClean <- bmoreRaw[,c(2,5,6,7,10)]
bmoreAgg <- aggregate(bmoreClean$Description, by=list(bmoreClean$CrimeDate), length)
bmoreAgg$CrimeDate <- as.Date(bmoreAgg$Group.1)


