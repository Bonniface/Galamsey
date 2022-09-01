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
aoi <- read_sf('Ghana shp file/GHA/gadm41_GHA_1.shp')
aoi <- st_transform(aoi, st_crs(4326))
aoi.ee <- st_bbox(aoi) %>%
  st_as_sfc() %>%
  sf_as_ee() #Converts it to an Earth Engine Object
################################################################################
#NDVI DATA

getQABits <- function(image, qa) {
  # Convert binary (character) to decimal (little endian)
  qa <- sum(2^(which(rev(unlist(strsplit(as.character(qa), "")) == 1))-1))
  # Return a mask band image, giving the qa value.
  image$bitwiseAnd(qa)$lt(1)
}

ndvi_mod.clean <- function(img) {
  # Extract the NDVI band
  ndvi_values <- img$select("NDVI")
  # Extract the quality band
  ndvi_qa <- img$select("SummaryQA")
  # Select pixels to mask
  quality_mask <- getQABits(ndvi_qa, "11")
  # Mask pixels with value zero.
  
  #0.0001 is the MODIS Scale Factor
  ndvi_values$updateMask(quality_mask)$divide(ee$Image$constant(10000))
}

modis.ndvi <- ee$ImageCollection("MODIS/006/MOD13Q1"
)$filter(ee$Filter$date('2000-01-01','2022-01-01'))$map(ndvi_mod.clean)
################################################################################

# EVI DATA

getQABits <- function(image, qa) {
  # Convert binary (character) to decimal (little endian)
  qa <- sum(2^(which(rev(unlist(strsplit(as.character(qa), "")) == 1))-1))
  # Return a mask band image, giving the qa value.
  image$bitwiseAnd(qa)$lt(1)
}

evi_mod.clean <- function(img) {
  # Extract the NDVI band
  evi_values <- img$select("EVI")
  # Extract the quality band
  evi_qa <- img$select("SummaryQA")
  # Select pixels to mask
  evi_quality_mask <- getQABits(evi_qa, "11")
  # Mask pixels with value zero.
  
  #0.0001 is the MODIS Scale Factor
  evi_values$updateMask(evi_quality_mask)$divide(ee$Image$constant(10000))
}

modis.evi <- ee$ImageCollection("MODIS/006/MOD13Q1"
)$filter(ee$Filter$date('2000-01-01','2022-01-01'))$map(evi_mod.clean)
################################################################################

aoi.proj <- st_transform(aoi, st_crs(2392))
hex <- st_make_grid(x = aoi.proj, cellsize = 17280, square = FALSE) %>%
  st_sf() %>%
  rowid_to_column('hex_id')
hex <- hex[aoi.proj,]

{#This will take about 30 minutes # 
aoi.ndvi <- ee_extract(x = modis.ndvi, y = hex["hex_id"], sf = FALSE, scale = 250, fun = ee$Reducer$mean(), via = "drive", quiet = T)
colnames(aoi.ndvi) <- c('hex_id', stringr::str_replace_all(substr(colnames(aoi.ndvi[, 2:ncol(aoi.ndvi)]), 2, 11), "_", "-"))
}
  
{ aoi.evi <- ee_extract(x = modis.evi, y = hex["hex_id"], sf = FALSE, scale = 250, fun = ee$Reducer$mean(), via = "drive", quiet = T)
colnames(aoi.evi) <- c('hex_id', stringr::str_replace_all(substr(colnames(aoi.evi [, 2:ncol(aoi.evi )]), 2, 11), "_", "-"))
}
  
# {EVI <- aoi.evi%>%
#     pivot_longer(-hex_id,names_to = "Date",values_to = "EVI")%>%
#     separate(Date,into = c("year","month","day"),sep = "-")%>%
#     select(hex_id,year,month,EVI)}
{
  #converting the data to a transposed data frame
NDVI  <- data.frame(ndvi = t(aoi.ndvi[i, 2:ncol(aoi.ndvi)]))
    
EVI <- data.frame(ndvi = t(aoi.evi[i, 2:ncol(aoi.evi)]))
 }
    
# {Vegetation <- NDVI %>% full_join(EVI,by ="hex_id")
#   Vegetation%>%
#     mutate(month = month(as.Date(rownames(Vegetation))), year = year(as.Date(rownames(Vegetation)))) %>%
#     group_by(year, month) %>%
#     summarise(mean_evi = mean(evi, na.rm = T), .groups = "keep") %>%
#     as.data.frame()}


{
  Dates <- data.frame(date = seq(as.Date('2001-01-01'), as.Date('2022-01-01'),"month"))
  
  Dates$month <- month(Dates$date)
  Dates$year <- year(Dates$date)
  i <- 1
  }


{
  NDVI <- NDVI %>%
    mutate(month =month(as.Date(rownames(NDVI))),year =year(as.Date(rownames(NDVI))))%>%
    group_by(year, month) %>%
    summarise(mean_evi = mean(evi, na.rm = T), .groups = "keep") %>%
    as.data.frame()
  
  NDVI$date <- as.Date(paste0(NDVI$year, "-", NDVI$month, "-01"))
  dx <- Dates[!(Dates$date %in% NDVI$date),]
  
  
  dx$mean_evi <- NA
  NDVI <- rbind(NDVI, dx) %>%
    arrange(date)
  }
