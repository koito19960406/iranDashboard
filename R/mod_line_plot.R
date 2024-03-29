#' line_plot UI Function
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
mod_line_plot_ui <- function(id, height = "100%", width = "100%"){
  ns <- NS(id)
  tagList(
    tags$style(type = 'text/css', paste0('#', ns("lineplot"), ' {height: ', height, '; width: ', width, ';}'), style = 'padding-top:0px;'),
    plotlyOutput(ns("lineplot"))%>%
      withSpinner()
  )
}

#' line_plot Server Functions
#'
#' @noRd
#' @importFrom dplyr mutate select mutate_at vars all_of rowwise ungroup across c_across filter slice
#' @importFrom tidyr pivot_longer
#' @importFrom plotly plot_ly renderPlotly layout add_trace highlight style attrs_selected ggplotly config
#' @importFrom sf st_drop_geometry
#' @importFrom crosstalk SharedData
#' @importFrom ggplot2 ggplot aes geom_line geom_point theme_minimal labs ggtitle theme element_text geom_text
#' @importFrom ggplot2 scale_x_continuous
mod_line_plot_server <- function(id, selected_data){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    # get all provinces data
    data_reactive <- reactive({
      req(selected_data())
      # pivot_longer
      selected_data()$data %>%
        st_drop_geometry() %>%
        pivot_longer(
          cols = starts_with("y_"),
          names_to = "year",
          names_prefix = "y_",
          values_to = "value",
          values_drop_na = T
        ) %>%
        mutate(year_num = as.numeric(year))
    })

    output$lineplot <- renderPlotly({
      req(data_reactive())

      # Generate x-axis breaks and labels
      x_axis_breaks_and_labels <- generate_x_axis_breaks_and_labels(data_reactive())

      # Create ggplot object
      d <- SharedData$new(data_reactive(), ~province_name)
      p <- ggplot(d, aes(x=year_num, y=value, group = province_name,
                         text = paste("Province Name:", province_name, "<br>Value:", round(value, 1)))) +
        geom_line(alpha = 0.3) +
        geom_point(alpha = 0.3) +
        geom_line(data = data_reactive() %>% filter(province_name == "National"), color = "red", alpha = 1) +
        geom_text(data = data_reactive() %>%
                    filter(province_name == "National") %>%
                    slice(which.max(year_num)), aes(label = "National\nAverage"), nudge_x = 0.5, size = 3, color = "red") +
        ggtitle("Line plot by province") +
        labs(x="Year",
             y=selected_data()$subindicator_readable,
             subtitle = "Hover your cursor to highlight lines") +
        theme_minimal() +
        theme(plot.title = element_text(hjust = 0.5, size = 20),
              plot.subtitle = element_text(hjust = 0.5, size = 12)) +
        scale_x_continuous(breaks = x_axis_breaks_and_labels$breaks,
                           labels = x_axis_breaks_and_labels$labels)

      # Convert to ggplotly and add hover behavior
      ggplotly(p, tooltip = "text") %>%
        layout(
          hovermode = "closest",
          title = list(
            text = "Line plot by province<br><sub>Hover your cursor to highlight lines</sub>",
            font = list(size = 20)
          )
        ) %>%
        highlight(on = "plotly_hover", off = "plotly_doubleclick",
                  color = "blue", selected = attrs_selected(opacity = 1))
    })
  })
}



## To be copied in the UI
# mod_line_plot_ui("line_plot_1")

## To be copied in the server
# mod_line_plot_server("line_plot_1")
