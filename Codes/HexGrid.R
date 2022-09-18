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

aoi.proj <- st_transform(aoi, st_crs(2392))
hex <- st_make_grid(x = aoi.proj, cellsize = 17280, square = FALSE) %>%
  st_sf() %>%
  rowid_to_column('hex_id')
hex <- hex[aoi.proj,]