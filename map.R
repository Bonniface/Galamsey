## required packages
library(rgdal)
library(rworldmap)
library(plotKML)

## shapefile data
data("countriesCoarse")
spy <- subset(countriesCoarse, continent == "Africa")

## plotKML
data("worldgrids_pal")
plotKML(spy["MAP_COLOR"], filename = "africa.kml",
        colour_scale = worldgrids_pal[["lgn3"]])