#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic
  # 1st tab -----------------------------------------------------------------
  selected_data_1 <- mod_indicator_selection_server("indicator_selection_1")
  mod_map_server("map_1", selected_data_1)
  mod_download_server("download_1")

  # 2nd tab -----------------------------------------------------------------
  selected_data_2 <- mod_indicator_selection_server("map_2")
  mod_map_server("map_2", selected_data_2)
  selected_data_3 <- mod_indicator_selection_server("map_3")
  mod_map_server("map_3", selected_data_3)

  # 3rd tab -----------------------------------------------------------------
  selected_data_4 <- mod_indicator_selection_server("indicator_selection_4")
  selected_data_5 <- mod_indicator_selection_server("indicator_selection_5")
  mod_scatter_plot_server("scatter_plot_1", selected_data_4, selected_data_5)
}
