#' year_selection UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_year_selection_ui <- function(id){
  ns <- NS(id)
  tagList(
    uiOutput(ns("year_dropdown"))
  )
}

#' year_selection Server Functions
#'
#' @noRd
mod_year_selection_server <- function(id, selected_data){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    # Update the year range slider based on the selected subindicator
    output$year_dropdown <- renderUI({
      req(selected_data())
      years <- colnames(selected_data()$data)[grepl("^y_", colnames(selected_data()$data))]
      years <- as.numeric(sub("^y_", "", years))
      years <- sort(years, decreasing = TRUE)
      selectInput(session$ns("year"), "Year:",
                  choices = years,
                  selected = years[1])
    })

    # Filter the data based on the selected year
    selected_year_data <- reactive({
      req(selected_data())
      req(input$year)
      selected_year <- paste0("y_", input$year)
      selected_data_filtered <- selected_data()$data %>%
        select(c("province_name", "geometry", {{selected_year}}))
      return(selected_data_filtered)
    })

    # Return the selected data type, subindicator, years, and filtered data
    return(reactive({
      req(selected_year_data())
      req(input$year)
      list(
        data_type = selected_data()$data_type,
        subindicator = selected_data()$subindicator,
        subindicator_readable = selected_data()$subindicator_readable,
        year = input$year,
        data = selected_year_data()
      )
    })%>%  #putting preselected inputs in cache
      bindCache(selected_data(), input$year)
    )
  })
}

## To be copied in the UI
# mod_year_selection_ui("year_selection_1")

## To be copied in the server
# mod_year_selection_server("year_selection_1")
