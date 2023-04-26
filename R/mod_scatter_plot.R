#' scatter_plot UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
#' @importFrom plotly plotlyOutput
#' @importFrom shinycssloaders withSpinner
mod_scatter_plot_ui <- function(id){
  ns <- NS(id)
  tagList(
    plotlyOutput(ns("scatterplot"))%>%
      withSpinner()
  )
}

#' scatter_plot Server Functions
#'
#' @noRd
#' @importFrom dplyr mutate select mutate_at vars all_of rowwise ungroup across c_across
#' @importFrom plotly plot_ly renderPlotly layout
#' @importFrom sf st_drop_geometry
mod_scatter_plot_server <- function(id, selected_data_1, selected_data_2){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    # merge two data
    data_reactive_1 <- reactive({
      req(selected_data_1())
      selected_data_1()$data %>%
        mutate(avg_1 = avg) %>%
        st_drop_geometry() %>%
        select(province_name, avg_1)
    })

    data_reactive_2 <- reactive({
      req(selected_data_2())
      selected_data_2()$data %>%
        mutate(avg_2 = avg) %>%
        st_drop_geometry() %>%
        select(province_name, avg_2)
    })

    data_joined <- reactive({
      req(data_reactive_1())
      req(data_reactive_2())
      data_reactive_1() %>%
        left_join(.,data_reactive_2(), by = "province_name")
    })

    output$scatterplot <- renderPlotly({
      req(data_joined())
      # Create the interactive scatter plot
      plot_ly(data_joined(), x = ~avg_1, y = ~avg_2, type = "scatter", mode = "markers",
              text = ~province_name,
              hovertemplate = paste0('Province Name: %{text}',
                '<br>', selected_data_1()$subindicator_readable, ': %{x:.2s}',
                '<br>', selected_data_2()$subindicator_readable, ': %{y:.2s}')) %>%
        layout(title = "Interactive scatter plot",
               xaxis = list(title = selected_data_1()$subindicator_readable),
               yaxis = list(title = selected_data_1()$subindicator_readable))
    })
  })
}

## To be copied in the UI
# mod_scatter_plot_ui("scatter_plot_1")

## To be copied in the server
# mod_scatter_plot_server("scatter_plot_1")
