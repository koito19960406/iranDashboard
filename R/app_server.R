#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic
  # # login ------------------------------------------------------------------
  # # Call the login module server function
  # logged_in <- mod_login_server("login_module")
  #
  # observe({
  #   req(logged_in())
    # 1st tab -----------------------------------------------------------------
    selected_data_1 <- mod_indicator_selection_server("indicator_selection_1")
    selected_year_data_1 <- mod_year_selection_server("year_selection_1", selected_data_1)
    mod_indicator_description_server("indicator_description_1", selected_year_data_1)
    mod_map_server("map_1", selected_year_data_1)
    mod_download_server("download_1")

    # 2nd tab -----------------------------------------------------------------
    # 1st map
    selected_data_2 <- mod_indicator_selection_server("indicator_selection_2")
    selected_year_data_2 <- mod_year_selection_server("year_selection_2", selected_data_2)
    mod_indicator_description_server("indicator_description_2", selected_year_data_2)
    mod_map_server("map_2", selected_year_data_2)
    # 2nd map
    selected_data_3 <- mod_indicator_selection_server("indicator_selection_3")
    selected_year_data_3 <- mod_year_selection_server("year_selection_3", selected_data_3)
    mod_indicator_description_server("indicator_description_3", selected_year_data_3)
    mod_map_server("map_3", selected_year_data_3, pal_raw = c("#ffffcc", "#a1dab4", "#41b6c4", "#2c7fb8", "#253494", "#081d58"))

    # 3rd tab -----------------------------------------------------------------
    # 1st variable
    selected_data_4 <- mod_indicator_selection_server("indicator_selection_4")
    selected_year_data_4 <- mod_year_selection_server("year_selection_4", selected_data_4)
    mod_indicator_description_server("indicator_description_4", selected_year_data_4)
    # 2nd variable
    selected_data_5 <- mod_indicator_selection_server("indicator_selection_5")
    selected_year_data_5 <- mod_year_selection_server("year_selection_5", selected_data_5)
    mod_indicator_description_server("indicator_description_5", selected_year_data_5)
    mod_scatter_plot_server("scatter_plot_1", selected_year_data_4, selected_year_data_5)

    # 4th tab -----------------------------------------------------------------
    selected_data_6 <- mod_indicator_selection_server("indicator_selection_6")
    mod_indicator_description_server("indicator_description_6", selected_data_6)
    mod_line_plot_server("line_plot_1", selected_data_6)
  # })
}
