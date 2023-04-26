#' download UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
#' @importFrom utils write.csv
mod_download_ui <- function(id){
  ns <- NS(id)
  tagList(
    # Button to download csv data
    downloadButton(ns("download_excel"),
                   "Download excel files"),

    # add some space between buttons
    tags$div(style="margin-bottom:10px"),

    # Button to download shp data
    downloadButton(ns("download_shapefile"),
                   "Download shapefile data"),

    # add some space between buttons
    tags$div(style="margin-bottom:10px")
  )
}

#' download Server Functions
#'
#' @noRd
#' @importFrom tidyr pivot_wider
#' @importFrom dplyr select left_join rename relocate
#' @importFrom leaflet.extras2 easyprintMap
#' @importFrom writexl write_xlsx
#' @importFrom zip zip
#' @importFrom sf st_write
mod_download_server <- function(id, map_main){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    # *****************************************************************
    # Download Excel data
    output$download_excel <- downloadHandler(
      filename = function() {
        paste0("indicators_", Sys.Date(), ".zip")
      },
      content = function(file) {
        excel_basename <- "data/indicators"
        excel_zip <- paste0(excel_basename, "_", Sys.Date(), ".zip")

        if (length(Sys.glob(paste0(excel_basename, "*"))) > 0) {
          file.remove(Sys.glob(paste0(excel_basename, "*")))
        }

        for (i in seq_along(excel)) {
          excel_file <- paste0(excel_basename, "_", names(excel)[i], ".xlsx")
          write_xlsx(excel[[i]], excel_file)
        }

        excel_files <- Sys.glob(paste0(excel_basename, "*"))
        zip(excel_zip, excel_files)
        file.copy(excel_zip, file)

        if (length(Sys.glob(paste0(excel_basename, "*"))) > 0) {
          file.remove(Sys.glob(paste0(excel_basename, "*")))
        }
      }
    )

    # Download shapefile
    output$download_shapefile <- downloadHandler(
      filename = function() {
        paste0("shapefile_", Sys.Date(), ".zip")
      },
      content = function(file) {
        shapefile_basename <- "data/shapefile"
        shapefile_zip <- paste0(shapefile_basename, ".zip")

        if (length(Sys.glob(paste0(shapefile_basename, ".*"))) > 0) {
          file.remove(Sys.glob(paste0(shapefile_basename, ".*")))
        }

        st_write(shapefile, dsn = paste0(shapefile_basename, ".shp"), layer = shapefile_basename, driver = "ESRI Shapefile", overwrite_layer = TRUE)

        zip(zipfile = shapefile_zip, files = Sys.glob(paste0(shapefile_basename, ".*")))
        file.copy(shapefile_zip, file)

        if (length(Sys.glob(paste0(shapefile_basename, ".*"))) > 0) {
          file.remove(Sys.glob(paste0(shapefile_basename, ".*")))
        }
      }
    )
  })
}

## To be copied in the UI
# mod_download_ui("download_1")

## To be copied in the server
# mod_download_server("download_1")
