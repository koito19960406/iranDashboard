## code to prepare `excel` dataset goes here
# excel.R
# Function to repair column names
library(readxl)
library(dplyr)
library(pbapply)

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

# Load the data from the Excel files
load_data <- function() {
  labor_force_data <- readxl::excel_sheets("data-raw/input/indicators/indicators_lfs_2011_2020.xlsx")
  welfare_data <- readxl::excel_sheets("data-raw/input/indicators/indicators_heis_2011_2020.xlsx")

  labor_force_data_list <- pblapply(labor_force_data, function(sheet) {
    read_excel("data-raw/input/indicators/indicators_lfs_2011_2020.xlsx",
               sheet = sheet, .name_repair = repair_column_names) %>%
      select(unique(colnames(.))) %>%
      mutate(province_name = iran_prov[province_name])
  })

  welfare_data_list <- pblapply(welfare_data, function(sheet) {
    read_excel("data-raw/input/indicators/indicators_heis_2011_2020.xlsx",
               sheet = sheet, .name_repair = repair_column_names) %>%
      select(unique(colnames(.))) %>%
      mutate(province_name = iran_prov[province_name])
  })

  names(labor_force_data_list) <- labor_force_data
  names(welfare_data_list) <- welfare_data

  list(labor_force = labor_force_data_list, welfare = welfare_data_list)
}
excel <- load_data()
usethis::use_data(excel, overwrite = TRUE)
