#' login UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
#' @importFrom shinyauthr loginUI
mod_login_ui <- function(id){
  ns <- NS(id)
  tagList(
    loginUI(ns("login")),
    uiOutput(ns("conditional_panel"))
  )
}

#' login Server Functions
#'
#' @noRd
#' @importFrom shinyauthr loginServer
mod_login_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    credentials <- loginServer(
      id = "login",
      data = user_base,
      user_col = user,
      pwd_col = password,
      sodium_hashed = TRUE
    )
    # Render the conditional panel based on user_auth
    output$conditional_panel <- renderUI({
      if (credentials()$user_auth) {
        div(
          class = "alert alert-success",
          strong("You successfully logged in!")
        )
      }
    })

    return(reactive(credentials()$user_auth))
  })
}

## To be copied in the UI
# mod_login_ui("login_1")

## To be copied in the server
# mod_login_server("login_1")
