{
library(tidyverse)  # for data wrangling and visualization
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
{
aoi <- read_sf('Ghana shp file/ROI/new_roi.shp')
  aoi <- st_transform(aoi, st_crs(4326))
  aoi.ee <- st_bbox(aoi) %>%
    st_as_sfc() %>%
    sf_as_ee() #Converts it to an Earth Engine Obj
}


Date <- Sys.Date()
# Map each image from 2000 to extract the monthly precipitation (Pr) from the Terraclimate dataset# ee$Image$rename(sprintf("PP_%02d")) # rename the bands of an image1

{Precipitation  <- ee$ImageCollection("UCSB-CHG/CHIRPS/DAILY") %>%
    ee$ImageCollection$filterDate("2000-01-01", rdate_to_eedate(Date)) %>%
    ee$ImageCollection$map(function(x) x$select("precipitation")) %>% 
    ee$ImageCollection$toBands() # from imagecollection to image
  
  }
{MinimumTemperature <- ee$ImageCollection("IDAHO_EPSCOR/TERRACLIMATE") %>%
    ee$ImageCollection$filterDate("2000-01-01", rdate_to_eedate(Date)) %>%
    ee$ImageCollection$map(function(x) x$select("tmmn")) %>% 
    ee$ImageCollection$toBands()}
{MaximumTemperature <- ee$ImageCollection("IDAHO_EPSCOR/TERRACLIMATE") %>%
    ee$ImageCollection$filterDate("2000-01-01", rdate_to_eedate(Date)) %>%
    ee$ImageCollection$map(function(x) x$select("tmmx")) %>% 
    ee$ImageCollection$toBands()}
{Evapotranspiration <- ee$ImageCollection("NASA/FLDAS/NOAH01/C/GL/M/V001") %>%
    ee$ImageCollection$filterDate("2000-01-01", rdate_to_eedate(Date)) %>%
    ee$ImageCollection$map(function(x) x$select("Evap_tavg")) %>% 
    ee$ImageCollection$toBands()}
{Humidity <- ee$ImageCollection("NASA/FLDAS/NOAH01/C/GL/M/V001") %>%
    ee$ImageCollection$filterDate("2000-01-01", rdate_to_eedate(Date)) %>%
    ee$ImageCollection$map(function(x) x$select("Qair_f_tavg")) %>% 
    ee$ImageCollection$toBands()}
{Drought <- ee$ImageCollection("IDAHO_EPSCOR/TERRACLIMATE") %>%
    ee$ImageCollection$filterDate("2000-01-01", rdate_to_eedate(Date)) %>%
    ee$ImageCollection$map(function(x) x$select("pdsi")) %>% 
    ee$ImageCollection$toBands()}
# Extract monthly precipitation values from the Terraclimate ImageCollection through ee_extract. ee_extract works similar to raster::extract, you just need to define: the ImageCollection object (x), the geometry (y), and a function to summarize the values (fun).

# Pr<-ee_extract(x = Precipitation, y = hex["hex_id"], sf = FALSE, scale = 250, fun = ee$Reducer$mean(), via = "drive", quiet = T)
# roi <- ee$Geometry$Point(5.96475,-1.782181)

Precipitation       <- ee_extract(x = Precipitation , y = aoi.ee, sf = FALSE, scale = 250, fun = ee$Reducer$mean(), via = "drive", quiet = T)
MinimumTemperature  <- ee_extract(x = MinimumTemperature , y = aoi.ee, sf = FALSE, scale = 250, fun = ee$Reducer$mean(), via = "drive", quiet = T)
MaximumTemperature  <- ee_extract(x = MaximumTemperature , y = aoi.ee, sf = FALSE, scale = 250, fun = ee$Reducer$mean(), via = "drive", quiet = T)
Evapotranspiration  <- ee_extract(x = Evapotranspiration , y = aoi.ee, sf = FALSE, scale = 250, fun = ee$Reducer$mean(), via = "drive", quiet = T)
Humidity            <- ee_extract(x = Humidity , y = aoi.ee, sf = FALSE, scale = 250, fun = ee$Reducer$mean(), via = "drive", quiet = T)
Drought             <- ee_extract(x = Drought , y = aoi.ee, sf = FALSE, scale = 250, fun = ee$Reducer$mean(), via = "drive", quiet = T)
}

{
  write.csv(Precipitation,"Data/Precipitation.csv")
  write.csv(MinimumTemperature,"Data/MinimumTemperature.csv")
  write.csv(MaximumTemperature,"Data/MaximumTemperature.csv")
  write.csv(Evapotranspiration,"Data/Evapotranspiration.csv")
  write.csv(Humidity,"Data/Humidity.csv")
  write.csv(Drought,"Data/Drought.csv")
}

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



