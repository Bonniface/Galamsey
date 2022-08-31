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
}
  


{#This will take about 30 minutes # 
  if(readline(prompt = "Hit enter to proceed or type 'no' to download the data from G-Drive. ") == "no"){ googledrive::drive_download(file =                               googledrive::as_id("https://drive.google.com/drive/folders/1ZnCpYz38ezSU1XG7ixJ2sPg_DX7bO07J?usp=sharing"),overwrite = T) 
    
    ndvi.df <- read.csv("rgee_file_2d44527a3b0e_2022_07_28_15_40_52.csv")  
    ndvi.df <- ndvi.df[,3:ncol(ndvi.df)] # 
    colnames(ndvi.df) <- c('hex_id', stringr::str_replace_all(substr(colnames(ndvi.df[, 2:ncol(ndvi.df)]), 2, 11), "_", "-")) #Convert dates to unambiguous format # 
  } else {paste0(system.time(expr = aoi.ndvi <- ee_extract(x = modis.ndvi, y = hex["hex_id"], sf = FALSE, scale = 250, fun = ee$Reducer$mean(), via = "drive", quiet = T))/60, " Minutes Elapsed. ")
    evi.df <- as.data.frame(aoi.ndvi) 
    
    colnames(ndvi.df) <- c('hex_id', stringr::str_replace_all(substr(colnames(ndvi.df[, 2:ncol(ndvi.df)]), 2, 11), "_", "-"))
    write.csv(x = ndvi.df, file = "~/rgee_file_2d44527a3b0e_2022_07_28_15_40_52.csv")}
  
  #Create an empty list, this will be used to house the time series projections for each cell.
  evi.hw.lst <- list()
  #Create an empty list, this will be used to house the time series decomposition for each cell.
  evi.dcmp.lst <- list()
  #This data frame will hold the trend data
  evi.trend <- data.frame(hex_id = ndvi.df$hex_id, na.cnt = NA, NA_Values = NA, Trend = NA, P_value = NA, R_Squared = NA, Standard_Error = NA, Trend_Strength = NA, Seasonal_Strength = NA)
  Dates <- data.frame(date = seq(as.Date('2001-01-01'), as.Date('2022-01-01'), "month"))
  
  Dates$month <- month(Dates$date)
  Dates$year <- year(Dates$date)
  i <- 1}
{#This will take about 30 minutes # 
  if(readline(prompt = "Hit enter to proceed or type 'no' to download the data from G-Drive. ") == "no"){ googledrive::drive_download(file =                               googledrive::as_id("https://drive.google.com/drive/folders/1ZnCpYz38ezSU1XG7ixJ2sPg_DX7bO07J?usp=sharing"),overwrite = T) 
    
    evi.df <- read.csv("rgee_file_2d44527a3b0e_2022_07_28_15_40_52.csv")  
    evi.df <- evi.df[,3:ncol(evi.df)] # 
    colnames(evi.df) <- c('hex_id', stringr::str_replace_all(substr(colnames(evi.df[, 2:ncol(evi.df)]), 2, 11), "_", "-")) #Convert dates to unambiguous format # 
  } else {paste0(system.time(expr = aoi.evi <- ee_extract(x = modis.evi, y = hex["hex_id"], sf = FALSE, scale = 250, fun = ee$Reducer$mean(), via = "drive", quiet = T))/60, " Minutes Elapsed. ")
    evi.df <- as.data.frame(aoi.evi) 
    
    colnames(evi.df) <- c('hex_id', stringr::str_replace_all(substr(colnames(evi.df[, 2:ncol(evi.df)]), 2, 11), "_", "-"))
    write.csv(x = evi.df, file = "~/rgee_file_2d44527a3b0e_2022_07_28_15_40_52.csv")}
  
  #Create an empty list, this will be used to house the time series projections for each cell.
  evi.hw.lst <- list()
  #Create an empty list, this will be used to house the time series decomposition for each cell.
  evi.dcmp.lst <- list()
  #This data frame will hold the trend data
  evi.trend <- data.frame(hex_id = evi.df$hex_id, na.cnt = NA, NA_Values = NA, Trend = NA, P_value = NA, R_Squared = NA, Standard_Error = NA, Trend_Strength = NA, Seasonal_Strength = NA)
  Dates <- data.frame(date = seq(as.Date('2001-01-01'), as.Date('2022-01-01'), "month"))
  
  Dates$month <- month(Dates$date)
  Dates$year <- year(Dates$date)
  i <- 1}


{#converting the data to a transposed data frame
  tsv <- data.frame(evi = t(evi.df[i, 2:ncol(evi.df)]))
  colnames(tsv) <- c("evi")
  write.csv(tsv,"Data/tsv.csv")
  #let's take a look
  #We want to get an idea of the number of entries with no EVI value
  na.cnt <- length(tsv[is.na(tsv)])
  evi.trend$na.cnt[i] <- na.cnt
  
  td <- tsv %>%
    mutate(month =month(as.Date(rownames(tsv))),year =year(as.Date(rownames(tsv))))%>%
    group_by(year, month) %>%
    summarise(mean_evi = mean(evi, na.rm = T), .groups = "keep") %>%
    as.data.frame()
  
  td$date <- as.Date(paste0(td$year, "-", td$month, "-01"))
  dx <- Dates[!(Dates$date %in% td$date),]
  
  
  dx$mean_evi <- NA
  Time_Series <- rbind(td, dx) %>%
    arrange(date)
  write.csv(Time_Series,"Data/Time_Series.csv")}
{#converting the data to a transposed data frame
  tsv <- data.frame(evi = t(evi.df[i, 2:ncol(evi.df)]))
  colnames(tsv) <- c("evi")
  write.csv(tsv,"Data/tsv.csv")
  #let's take a look
  #We want to get an idea of the number of entries with no EVI value
  na.cnt <- length(tsv[is.na(tsv)])
  evi.trend$na.cnt[i] <- na.cnt
  
  td <- tsv %>%
    mutate(month =month(as.Date(rownames(tsv))),year =year(as.Date(rownames(tsv))))%>%
    group_by(year, month) %>%
    summarise(mean_evi = mean(evi, na.rm = T), .groups = "keep") %>%
    as.data.frame()
  
  td$date <- as.Date(paste0(td$year, "-", td$month, "-01"))
  dx <- Dates[!(Dates$date %in% td$date),]
  
  
  dx$mean_evi <- NA
  Time_Series <- rbind(td, dx) %>%
    arrange(date)
  write.csv(Time_Series,"Data/Time_Series.csv")}