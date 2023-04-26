## code to prepare `shapefile` dataset goes here
library(sf)
library(dplyr)
shapefile <- st_read("data-raw/input/admin/IRN_adm1.shp") %>%
  st_transform(shape_data, crs = 4326)
usethis::use_data(shapefile, overwrite = TRUE)
