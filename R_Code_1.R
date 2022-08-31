library(openintro)  # for data
library(tidyverse)  # for data wrangling and visualization
library(knitr)      # for tables
library(broom)      # for model summary
library(imputeTS)
library(dplyr)
library(kableExtra)
library(forecast)
library(psych)
library(viridis)
library(ggridges)
library('sf')
library(tibble)
library(lubridate)

# Downloading the EVI and NDVI

library(rgee)

library(reticulate)
#ee_install()
ee_check()

ee_Initialize("kalong",drive = TRUE) # initialize GEE,
#this will have you log in to Google Drive


#Load shape file
{aoi <- read_sf('Ghana shp file/GHA/gadm41_GHA_1.shp')
  aoi <- st_transform(aoi, st_crs(4326))
  aoi.ee <- st_bbox(aoi) %>%
    st_as_sfc() %>%
    sf_as_ee() #Converts it to an Earth Engine Obj
  }

# Map each image from 2000 to extract the monthly precipitation (Pr) from the Terraclimate dataset

{Precipitation  <- ee$ImageCollection("IDAHO_EPSCOR/TERRACLIMATE") %>%
    ee$ImageCollection$filterDate("2000-01-01", "2022-01-01") %>%
    ee$ImageCollection$map(function(x) x$select("pr")) %>% # Select only precipitation bands
    ee$ImageCollection$toBands() # from imagecollection to image
  # ee$Image$rename(sprintf("PP_%02d")) # rename the bands of an image
  }
{MinimumTemperature <- ee$ImageCollection("IDAHO_EPSCOR/TERRACLIMATE") %>%
    ee$ImageCollection$filterDate("2000-01-01", "2022-01-01") %>%
    ee$ImageCollection$map(function(x) x$select("tmmn")) %>% # Select only precipitation bands
    ee$ImageCollection$toBands()}
{MaximumTemperature <- ee$ImageCollection("IDAHO_EPSCOR/TERRACLIMATE") %>%
    ee$ImageCollection$filterDate("2000-01-01", "2022-01-01") %>%
    ee$ImageCollection$map(function(x) x$select("tmmx")) %>% # Select only precipitation bands
    ee$ImageCollection$toBands()}
# Extract monthly precipitation values from the Terraclimate ImageCollection through ee_extract. ee_extract works similar to raster::extract, you just need to define: the ImageCollection object (x), the geometry (y), and a function to summarize the values (fun).

Pr<-ee_extract(x = Precipitation, y = hex["hex_id"], sf = FALSE, scale = 250, fun = ee$Reducer$mean(), via = "drive", quiet = T)

Precipitation  <- ee_extract(x = Precipitation , y = aoi.ee, sf = FALSE)
MinimumTemperature  <- ee_extract(x = MinimumTemperature , y = aoi.ee, sf = FALSE)
MaximumTemperature  <- ee_extract(x = MaximumTemperature , y = aoi.ee, sf = FALSE)

#Tidy the Data


{Precipitation <- Precipitation%>%
    pivot_longer(starts_with("X20"),names_to =  c("X","Date"),names_pattern = "(.)(.+)",values_to = "Precipitation")%>%
    separate(Date,into = c("Date","Pr"),sep = "_")%>% 
    separate(Date, into = c('year', 'month'), sep = -2, convert = TRUE)%>%
    select(year,month,Precipitation)}
{MinimumTemperature <- MinimumTemperature%>%
    pivot_longer(starts_with("X20"),names_to =  c("X","Date"),names_pattern = "(.)(.+)",values_to = "MinTemperature")%>%
    separate(Date,into = c("Date","tmmn"),sep = "_")%>% 
    separate(Date, into = c('year', 'month'), sep = -2, convert = TRUE)%>%
    select(year,month,MinTemperature)}
{MaximumTemperature <- MaximumTemperature%>%
    pivot_longer(starts_with("X20"),names_to =  c("X","Date"),names_pattern = "(.)(.+)",values_to = "MaxTemperature")%>%
    separate(Date,into = c("Date","tmmx"),sep = "_")%>% 
    separate(Date, into = c('year', 'month'), sep = -2, convert = TRUE)%>%
    select(year,month,MaxTemperature)}


# Save the Data
ClimateChange <- Precipitation%>%full_join(MinimumTemperature)%>%full_join(MaximumTemperature)

{write.csv(ClimateChange,"Data/ClimateChange.csv")
  write.csv(Precipitation,"Data/Precipitation.csv")
  write.csv(MinimumTemperature,"Data/MinTemperature.csv")
  write.csv(MaximumTemperature,"Data/MaxTemperature.csv")}


  # ggplot(aes(x = month, y = pr, group = NAME, color = pr)) +
  # geom_line(alpha = 0.4) +
  # xlab("Month") +
  # ylab("Precipitation (mm)") +
  # theme_minimal()
