#' map UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_map_ui <- function(id,height = "100%", width = "100%", embed = F){
  ns <- NS(id)
  tagList(
    tags$head(
      tags$style(HTML(".leaflet-container {border: 0.5px solid black; background: #FFFFFF; }"))),
    tags$style(type = 'text/css', paste0('#', ns("map"), ' {height: ', height, '; width: ', width, ';}'), style = 'padding-top:0px;'),
    leafletOutput(ns("map")) %>%
      withSpinner(),
    if (embed) {
      absolutePanel(
        left = 20, bottom = 10,
        style = "background-color: white; max-width: 20%; padding: 10px;", # Set the background color and limit the width
        mod_indicator_selection_ui(id)
      )
    }
  )
}

#' map Server Functions
#'
#' @noRd
#' @importFrom leaflet renderLeaflet leaflet leafletOptions fitBounds addMeasure addScaleBar
#' @importFrom leaflet leafletProxy clearControls clearShapes addPolygons addLegend colorBin
#' @importFrom leaflet labelFormat labelOptions highlightOptions addProviderTiles
#' @importFrom leaflet addTiles providers addLayersControl layersControlOptions leafletOutput
#' @importFrom magrittr %>%
#' @importFrom sf st_bbox
#' @importFrom shinycssloaders withSpinner
mod_map_server <- function(id, selected_data) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    # Create a reactive object for the shapefile
    shp_reactive <- reactive({
      req(selected_data()$data)
      selected_data()$data
    })

    bb <- reactive({
      req(shp_reactive())
      st_bbox(shp_reactive()) %>%
      as.vector()# consistent for all leaflets. Resize them all here.
      # bb <- bb+c(-0.5,0,+0.5,0)
      # bb
      })

    # Reactive function for the map
    output$map <- renderLeaflet({
      req(bb())
      # Create the initial map with options and fit the bounds
      leaflet(options = leafletOptions(zoomSnap = 0.20, zoomDelta = 0.20)) %>%
        fitBounds(bb()[1],bb()[2],bb()[3],bb()[4]) %>%
        # addTiles() %>%
        addProviderTiles(providers$CartoDB.Voyager, group = "CartoDB") %>%
        addProviderTiles(providers$Esri, group = "ESRI") %>%
        addProviderTiles(providers$OpenStreetMap , group = "OpenStreetMap") %>%
        addLayersControl(
          baseGroups = c("CartoDB", "ESRI", "OpenStreetMap"),
          options = layersControlOptions(collapsed = T)
        ) %>%
        addMeasure() %>%
        addScaleBar("bottomleft")
    })

    # Observer for updating the map based on the reactive shapefile
    observe({
      # Create necessary variables and functions for the map
      labels <- reactive(create_labels(selected_data()))
      pal_raw <- c('#FFEDA0', '#FED976', '#FEB24C', '#FD8D3C', '#FC4E2A', '#E31A1C')
      bins <- reactive(create_bins(selected_data(), 5))
      pal <- colorBin(palette = pal_raw, bins = bins(), na.color = "grey")
      pal_reversed <- colorBin(palette = rev(pal_raw), bins = bins(), na.color = "grey")

      # Update the map with polygons and legend
      leafletProxy("map") %>%
        clearControls() %>%
        clearShapes() %>%
        addPolygons(
          data = shp_reactive(),
          label = labels(),
          labelOptions = labelOptions(
            style = list("font-weight" = "normal", padding = "3px 8px", "color" = "#cc4c02"),
            textsize = "15px",
            direction = "auto"
          ),
          fillColor = ~pal(shp_reactive()$avg),
          fillOpacity = 1,
          stroke = TRUE,
          color = "white",
          weight = 1,
          opacity = 0.5,
          fill = TRUE,
          dashArray = NULL,
          smoothFactor = 0.5,
          highlightOptions = highlightOptions(weight = 5, fillOpacity = 1, opacity = 1, bringToFront = FALSE),
          group = "Polygons"
        ) %>%
        addLegend("bottomright",
                  pal = pal_reversed,
                  values = shp_reactive()$avg,
                  title = selected_data()$subindicator_readable,
                  opacity = 1,
                  labFormat = labelFormat(digits = round_vec(bins()), transform = function(x) sort(x, decreasing = TRUE)),
                  group = "Polygons")
    })

  })
}
## To be copied in the UI
# mod_map_ui("map_1")

## To be copied in the server
# mod_map_server("map_1")
