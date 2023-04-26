## code to prepare `shapefile` dataset goes here
library(readxl)
library(dplyr)
library(sf)
library(pbapply)
library(rmapshaper)

# Function to repair column names
repair_column_names <- function(names) {
  names <- ifelse(names == "", "province_name", paste0("y_",names))
  names
}

# named vector to fix name fluctuations
iran_prov <- c("Alborz" = "Alborz",
               "Ardebil" = "Ardebil",
               "Bakhtiari" = "Chahar Mahall and Bakhtiari",
               "Bushehr" = "Bushehr",
               "EAzarbaijan" = "East Azarbaijan",
               "Fars" = "Fars",
               "Gilan" = "Gilan",
               "Golestan" = "Golestan",
               "Hamadan" = "Hamadan",
               "Hormozgan" = "Hormozgan",
               "Ilam" = "Ilam",
               "Isfahan" = "Esfahan",
               "Kerman" = "Kerman",
               "Kermanshah" = "Kermanshah",
               "KhorasanRazavi" = "Razavi Khorasan",
               "Khuzestan" = "Khuzestan",
               "Kohkiloyeh" = "Kohgiluyeh and Buyer Ahmad",
               "Kurdestan" = "Kordestan",
               "Lorestan" = "Lorestan",
               "Markazi" = "Markazi",
               "Mazandaran" = "Mazandaran",
               "National" = "",
               "NKhorasan" = "North Khorasan",
               "Qazvin" = "Qazvin",
               "Qom" = "Qom",
               "Semnan" = "Semnan",
               "Sistan" = "Sistan and Baluchestan",
               "SKhorasan" = "South Khorasan",
               "Tehran" = "Tehran",
               "WAzarbaijan" = "West Azarbaijan",
               "Yazd" = "Yazd",
               "Zanjan" = "Zanjan")

# Load shapefile
shapefile <- st_read("data-raw/input/admin/IRN_adm1.shp") %>%
  ms_simplify(., keep = 0.001,
              keep_shapes = FALSE)

# Load the data from the Excel files
load_data <- function() {
  labor_force_data <- readxl::excel_sheets("data-raw/input/indicators/indicators_lfs_2011_2020.xlsx")
  welfare_data <- readxl::excel_sheets("data-raw/input/indicators/indicators_heis_2011_2020.xlsx")

  labor_force_data_list <- pblapply(labor_force_data, function(sheet) {
    read_excel("data-raw/input/indicators/indicators_lfs_2011_2020.xlsx",
               sheet = sheet, .name_repair = repair_column_names) %>%
      select(unique(colnames(.))) %>%
      mutate(province_name = iran_prov[province_name]) %>%
      left_join(., shapefile, by = c("province_name" = "NAME_1")) %>%
      st_as_sf()
  })

  welfare_data_list <- pblapply(welfare_data, function(sheet) {
    read_excel("data-raw/input/indicators/indicators_heis_2011_2020.xlsx",
               sheet = sheet, .name_repair = repair_column_names) %>%
      select(unique(colnames(.))) %>%
      mutate(province_name = iran_prov[province_name]) %>%
      left_join(., shapefile, by =  c("province_name" = "NAME_1")) %>%
      st_as_sf()
  })

  names(labor_force_data_list) <- labor_force_data
  names(welfare_data_list) <- welfare_data

  list(labor_force = labor_force_data_list, welfare = welfare_data_list)
}

# Load data
shapefile_list <- load_data()
usethis::use_data(shapefile_list, overwrite = TRUE)
