#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic
    navbarPage("Iran Dashboard",

               header = tagList(
                 shinyWidgets::useShinydashboard()
               ),

               # 1st tab -----------------------------------------------------------------
               tabPanel("Interactive Map",
                        bootstrapPage(theme = shinythemes::shinytheme("flatly")),
                        sidebarLayout(
                          sidebarPanel(
                            mod_indicator_selection_ui("indicator_selection_1"),
                            mod_download_ui("download_1")
                          ),
                          mainPanel(
                            mod_map_ui("map_1", height = "calc(100vh - 80px) !important", width = "100%")
                          )
                        )
               ),
               # 2nd tab -----------------------------------------------------------------
               tabPanel("Comparison Maps",
                        bootstrapPage(theme = shinythemes::shinytheme("flatly")),
                        fluidPage(
                          fluidRow(
                            column(width = 6,
                                   mod_map_ui("map_2", height = "calc(100vh - 80px) !important", width = "50%", embed = T)
                            ),
                            column(width = 6,
                                   mod_map_ui("map_3", height = "calc(100vh - 80px) !important", width = "50%", embed = T))
                          )
                        )
               ),

               # 3rd tab -----------------------------------------------------------------
               tabPanel("Scatter Plot",
                        bootstrapPage(theme = shinythemes::shinytheme("flatly")),
                        sidebarLayout(
                          sidebarPanel(
                            mod_indicator_selection_ui("indicator_selection_4"),
                            mod_indicator_selection_ui("indicator_selection_5")
                          ),
                          mainPanel(
                            mod_scatter_plot_ui("scatter_plot_1")
                          )
                        )
               )
    )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "iranDashboard"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
