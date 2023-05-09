#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @importFrom shinythemes shinytheme
#' @importFrom shinyWidgets useShinydashboard
#' @import shinydashboard
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic
    navbarPage("Iran Dashboard",

               header = tagList(
                 useShinydashboard()
               ),

              # login -------------------------------------------------------------------
              tabPanel("Log In",
                       bootstrapPage(theme = shinytheme("flatly")),
                       # Add the login module to your UI
                       mod_login_ui("login_module")
              ),


               # 1st tab -----------------------------------------------------------------
               tabPanel("Interactive Map",
                        bootstrapPage(theme = shinytheme("flatly")),
                        sidebarLayout(
                          sidebarPanel(
                            mod_indicator_selection_ui("indicator_selection_1"),
                            mod_year_selection_ui("year_selection_1"),
                            mod_indicator_description_ui("indicator_description_1"),
                            mod_download_ui("download_1")
                          ),
                          mainPanel(
                            mod_map_ui("map_1", height = "calc(100vh - 80px) !important", width = "100%")
                          )
                        )
               ),
               # 2nd tab -----------------------------------------------------------------
               tabPanel("Comparison Maps",
                        bootstrapPage(theme = shinytheme("flatly")),
                        sidebarLayout(
                          sidebarPanel(
                            div(h3("Select a variable for the left map: ")),
                            mod_indicator_selection_ui("indicator_selection_2"),
                            mod_year_selection_ui("year_selection_2"),
                            mod_indicator_description_ui("indicator_description_2"),
                            div(h3("Select a variable for the right map: ")),
                            mod_indicator_selection_ui("indicator_selection_3"),
                            mod_year_selection_ui("year_selection_3"),
                            mod_indicator_description_ui("indicator_description_3"),
                          ),
                          mainPanel(
                            fluidRow(
                              column(width = 6,
                                     mod_map_ui("map_2", height = "calc(100vh - 80px) !important", width = "50%")
                              ),
                              column(width = 6,
                                     mod_map_ui("map_3", height = "calc(100vh - 80px) !important", width = "50%"))
                            )
                          )
                        )
               ),

               # 3rd tab -----------------------------------------------------------------
               tabPanel("Scatter Plot",
                        bootstrapPage(theme = shinytheme("flatly")),
                        sidebarLayout(
                          sidebarPanel(
                            div(h3("Select variable #1: ")),
                            mod_indicator_selection_ui("indicator_selection_4"),
                            mod_year_selection_ui("year_selection_4"),
                            mod_indicator_description_ui("indicator_description_4"),
                            div(h3("Select variable #2: ")),
                            mod_indicator_selection_ui("indicator_selection_5"),
                            mod_year_selection_ui("year_selection_5"),
                            mod_indicator_description_ui("indicator_description_5"),
                          ),
                          mainPanel(
                            mod_scatter_plot_ui("scatter_plot_1", height = "calc(100vh - 130px) !important")
                          )
                        )
               ),

              # 4th tab -----------------------------------------------------------------
              tabPanel("Line Plot",
                       bootstrapPage(theme = shinytheme("flatly")),
                       sidebarLayout(
                         sidebarPanel(
                           div(h3("Select variable: ")),
                           mod_indicator_selection_ui("indicator_selection_6"),
                           mod_indicator_description_ui("indicator_description_6"),
                         ),
                         mainPanel(
                           mod_line_plot_ui("line_plot_1", height = "calc(100vh - 130px) !important")
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
