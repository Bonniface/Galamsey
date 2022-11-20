library(forecast)
library(leaflet)
library(sf)
library(tibble)
library(ggplot2)
library(googledrive)
library(lubridate)
library(magrittr)
library(tidyverse)
library(geojsonio)
library(rgee)
library(reticulate)

ee_Initialize("kalong",drive = TRUE) # initialize GEE,
#this will have you log in to Google Drive


cc <- read_sf('Ghana shp file/ROI/new_roi.shp')
aoi <- st_transform(cc, st_crs(4326))
aoi.ee <- st_bbox(aoi) %>%
  st_as_sfc() %>%
  sf_as_ee() #Converts it to an Earth Engine Object

`



getQABits <- function(image, qa) {
  # Convert binary (character) to decimal (little endian)
  qa <- sum(2^(which(rev(unlist(strsplit(as.character(qa), "")) == 1))-1))
  # Return a mask band image, giving the qa value.
  image$bitwiseAnd(qa)$lt(1)
}

mod.clean <- function(img) {
  # Extract the NDVI band
  ndvi_values <- img$select("NDVI")
  # Extract the quality band
  ndvi_qa <- img$select("SummaryQA")
  # Select pixels to mask
  quality_mask <- getQABits(ndvi_qa, "11")
  # Mask pixels with value zero.
  ndvi_values$updateMask(quality_mask)$divide(ee$Image$constant(10000)) #0.0001 is the MODIS Scale Factor
}
Date <- Sys.Date()

modis.evi <- ee$ImageCollection("MODIS/006/MOD13Q1")$filter(ee$Filter$date('2000-01-01',rdate_to_eedate(Date)))$map(mod.clean)




cc.proj <- st_transform(cc, st_crs(2992))
hex <- st_make_grid(x = cc.proj, cellsize = 17080, square = FALSE) %>%
st_sf() %>%
rowid_to_column('hex_id')
hex <- hex[cc.proj,]


{
cc.evi <- ee_extract(x = modis.evi, y = hex["hex_id"], sf = FALSE, scale = 250, fun = ee$Reducer$mean(), via = "drive", quiet = T)
evi.df <- as.data.frame(cc.evi)
write.csv(x = evi.df, file = "Data/rgeedf.csv")
}

cc.evi = evi.df <-read.csv("Data/rgeedf.csv")
colnames(evi.df) <- c('hex_id', stringr::str_replace_all(substr(colnames(evi.df[, 2:ncol(evi.df)]), 2, 11), "_", "-"))





{
  evi.hw.lst <- list() #Create an empty list, this will be used to house the time series projections for each cell. 
evi.dcmp.lst <- list() #Create an empty list, this will be used to house the time series decomposition for each cell.
evi.df<-evi.df[,-2]
evi.trend <- data.frame(hex_id = evi.df$hex_id, na.cnt = NA, na.cnt.2 = NA, trend = NA, p.val = NA, r2 = NA, std.er = NA, trnd.strngth = NA, seas.strngth = NA) #This data frame will hold the trend data
Dates <- data.frame(date = seq(as.Date('2000-01-01'), Date, "month"))
Dates$month <- month(Dates$date)
Dates$year <- year(Dates$date)
i <- 1
}
tsv <- data.frame(evi = t(evi.df[i, 2:ncol(evi.df)])) #converting the data to a transposed data frame
colnames(tsv) <- c("evi")

 

na.cnt <- length(tsv[is.na(tsv)]) #We want to get an idea of the number of entries with no EVI value
evi.trend$na.cnt[i] <- na.cnt
td <- tsv %>% 
  mutate(month = month(as.Date(rownames(tsv))), year = year(as.Date(rownames(tsv)))) %>% 
  group_by(year, month) %>%
  summarise(mean_evi = mean(evi, na.rm = T), .groups = "keep") %>%
  as.data.frame()
write.csv(td,"Data/td.csv")


td$date <- as.Date(paste0(td$year, "-", td$month, "-01"))
dx <- Dates[!(Dates$date %in% td$date),]



dx$mean_evi <- NA
tdx <- rbind(td, dx) %>% 
  arrange(date)
head(tdx)
write.csv(tdx,"Data/NDVI.csv")
na.cnt <- length(tdx[is.na(tdx)])
evi.trend$na.cnt.2[i] <- na.cnt #add count of na values to dataframe
rm(td, dx) #remove data we're no longer using, this is a good rule of thumb, especially when working with larger datasets.
tdx <- ts(data = tdx$mean_evi, start = c(2000, 1), end = c(2022, 01), frequency = 12) #convert data to time series.


tdx <- if(na.cnt > 0){imputeTS::na_kalman(tdx, model = "auto.arima", smooth = T)} else {
    tdx
}


tdx.dcp <- stl(tdx, s.window = 'periodic')


Tt <- trendcycle(tdx.dcp)
St <- seasonal(tdx.dcp)
Rt <- remainder(tdx.dcp)


tdx.ns <- data.frame(time = c(1:length(tdx)), trend = tdx - tdx.dcp$time.series[,1])
Tt <- trendcycle(tdx.dcp)
St <- seasonal(tdx.dcp)
Rt <- remainder(tdx.dcp)
trend.summ <- summary(lm(formula = trend ~ time, data = tdx.ns)) #tslm
plot(tdx.ns,pch = 16, 
     xlab = "Time", ylab = "Trend ", col = "#2E9FDF")
abline(a = trend.summ$coefficients[1,1], b = trend.summ$coefficients[2,1], col='red')


evi.trend$trend[i] <- trend.summ$coefficients[2,1]
evi.trend$trnd.strngth[i] <- round(max(0,1 - (var(Rt)/var(Tt + Rt))), 1) #Trend Strength Calculation <https://towardsdatascience.com/rainfall-time-series-analysis-and-forecasting-87a29316494e>
evi.trend$seas.strngth[i] <- round(max(0,1 - (var(Rt)/var(St + Rt))), 1) #Seasonal Strength Calculation
evi.trend$p.val[i] <- trend.summ$coefficients[2,4]
evi.trend$r2[i] <- trend.summ$r.squared
evi.trend$std.er[i] <- trend.summ$sigma
evi.trend[i,]

evi.trend <- read.csv("Data/rgeedf.csv")

for(i in 1:nrow(evi.df)){
tsv <- data.frame(evi = t(evi.df[i, 2:ncol(evi.df)])) 
colnames(tsv) <- c("evi")
na.cnt <- length(tsv[is.na(tsv)])
evi.trend$na.cnt[i] <- na.cnt
if(na.cnt < 263){
td <- tsv %>% 
  mutate(month = month(as.Date(rownames(tsv))), year = year(as.Date(rownames(tsv)))) %>%
  group_by(year, month) %>%
  summarise(mean_evi = mean(evi, na.rm = T), .groups = "keep") %>%
  as.data.frame()
td$date <- as.Date(paste0(td$year, "-", td$month, "-01"))
dx <- Dates[!(Dates$date %in% td$date),]
dx$mean_evi <- NA
tdx <- rbind(td, dx) %>% 
  arrange(date)
na.cnt <- length(tdx[is.na(tdx)])
evi.trend$na.cnt.2[i] <- na.cnt
rm(td, dx)
tdx <- ts(data = tdx$mean_evi, start = c(2001, 1), end = c(2019, 11), frequency = 12)
tdx <- if(na.cnt > 0){imputeTS::na_kalman(tdx, model = "auto.arima", smooth = T)} else {
    tdx
}

tdx.dcp <- stl(tdx, s.window = 'periodic')
evi.dcmp.lst[[i]] <- tdx.dcp
 #This will save our decomposition plots
plot(tdx.dcp)
dev.off()
tdx.ns <- data.frame(time = c(1:length(tdx)), trend = tdx - tdx.dcp$time.series[,1])
Tt <- trendcycle(tdx.dcp)
St <- seasonal(tdx.dcp)
Rt <- remainder(tdx.dcp)
trend.summ <- summary(lm(formula = trend ~ time, data = tdx.ns)) #tslm
evi.trend$trend[i] <- trend.summ$coefficients[2,1]
evi.trend$trnd.strngth[i] <- round(max(0,1 - (var(Rt)/var(Tt + Rt))), 1) 

evi.trend$seas.strngth[i] <- round(max(0,1 - (var(Rt)/var(St + Rt))), 1) #Seasonal Strength Calculation
evi.trend$p.val[i] <- trend.summ$coefficients[2,4]
evi.trend$r2[i] <- trend.summ$r.squared
evi.trend$std.er[i] <- trend.summ$sigma
evi.hw <- forecast::hw(y = tdx, h = 12, damped = T)
evi.hw.lst[[i]] <- evi.hw
# plot(evi.hw)
# dev.off()
# rm(evi.hw, trend.summ, tdx.ns, tdx.dcp, Tt, St, Rt, tdx, na.cnt)
# gc()
} else {
  evi.ts[[i]] <- NA
    }
  }


write.csv(evi.trend,"Data/evi.trend.csv")


evi.trend$system.index <- cc.evi[,1]
hex_trend <- hex %>%
  left_join(evi.trend, by = 'hex_id', keep = F) %>%
  replace(is.na(.), 0)
hex_trend <- st_transform(hex_trend, st_crs(4326))



library(classInt)
trend_brks <- classIntervals(hex_trend$trend, n=11, style = "fisher")
colorscheme <- RColorBrewer::brewer.pal(n = 11, 'RdYlGn')
palette_sds <- leaflet::colorBin(colorscheme, domain = hex_trend$trend, bins=trend_brks$brks, na.color = "#ffffff", pretty = T)

pop <- paste0("<b> Hex ID: </b>",hex_trend$hex_id,"<br><b>NA Count: </b>",hex_trend$na.cnt+hex_trend$na.cnt.2,"<br><b>Trend: </b>",format(round(hex_trend$trend, 4), scientific = FALSE),"<br><b> P-Value: </b>",round(hex_trend$p.val, 4),"<br><b>R2: </b>",round(hex_trend$r2, 4),"<br><b>Std Err: </b>",round(hex_trend$std.er, 4),"<br><b>Trend Strength: </b>",round(hex_trend$trnd.strngth, 2),"<br><b>Seasonal Strength: </b>",round(hex_trend$seas.strngth, 4),"<br>")
#Here we're creating a popup for our interactive map.



library(leaflet)
library(dplyr)
map <- hex_trend %>%
  leaflet() %>%
  setView(-2.063,6.088,8) %>%
  addProviderTiles("Esri.WorldTopoMap", group = "Topo Map") %>%
  addProviderTiles("Esri.WorldImagery", group = "Imagery", 
                   options = providerTileOptions(opacity = 0.7)) %>%
  addProviderTiles( "CartoDB.Positron", group = "CartoDB.Positron") %>%
  addPolygons(
    fillColor = ~palette_sds(hex_trend$trend),
    fillOpacity = hex_trend$trnd.strngth,
    opacity = 0.5,
    weight = 0.1,
    color='white', 
    group = "Hexbins", 
    highlightOptions = highlightOptions(
       color = "white",
       weight = 2,
       bringToFront = TRUE),
       popup = pop,
    popupOptions = popupOptions(
       maxHeight = 250, 
       maxWidth = 250)) %>%
  addLegend(
    title = "Trend: lm(EVI ~ Month)",
    pal = palette_sds,
    values = hex_trend$trend,
    opacity = 0.7,
    labFormat = labelFormat(
      digits = 5)) %>%
  addLayersControl(
       baseGroups = c("Topo Map", "Imagery","Basemap - dark","Basemap - greyscale","Basemap - aerial"),
       overlayGroups = c("Hexbins"),
       options = layersControlOptions(collapsed = TRUE)) %>%
  addEasyButton(easyButton(
    icon="fa-globe", title="Zoom to Level 1",
    onClick=JS("function(btn, map){ map.setZoom(1); }"))) %>%
  addEasyButton(easyButton(
    icon="fa-crosshairs", title="Study Area",
    onClick=JS("function(btn, map){ map.locate({setView: true}); }")))%>%
  addScaleBar(position='bottomright')
map

