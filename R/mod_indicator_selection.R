#' indicator_selection UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_indicator_selection_ui <- function(id){
  ns <- NS(id)
  tagList(
    selectInput(ns("data_type"), "Data Type:",
                choices = c("Labor Force" = "labor_force", "Welfare" = "welfare"),
                selected = "Labor Force"),
    uiOutput(ns("subindicator_dropdown"))
  )
}

#' indicator_selection Server Functions
#'
#' @noRd
#' @importFrom dplyr mutate select mutate_at vars all_of rowwise ungroup across c_across
mod_indicator_selection_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    # Define a named list with better-looking names for the subindicators
    subindicator_names <- list(
      labor_force = c("Working Age Population Rate" = "WAP",
                      "Labor Force Participation Rate" = "lfp",
                      "Education Attainment Level Rate: None" = "educ_none",
                      "Education Attainment Level Rate: Primary Education" = "educ_primary",
                      "Education Attainment Level Rate: Secondary Education" = "educ_secondary",
                      "Education Attainment Level Rate: Tertirary Education" = "educ_tertiary",
                      "Employment Rate" = "employrate",
                      "Unemployment Rate" = "unemprate",
                      "Unemployment Rate among Youth" = "youth_unemprate",
                      "Unemployment Rate among Youth with Tertiary Education" = "youth_terciary_unemprate",
                      "Long-term Unemployment Rate" = "longterm_unemprate",
                      "Under-employment Rate" = "underemployment_rate",
                      "Employment Share: Agriculture" = "agri_employ_share",
                      "Employment Share: Indutry" = "industry_employ_share",
                      "Employment Share: Service" = "service_employ_share",
                      "Employment Share: Public" = "public_share",
                      "Employment Share: Wage" = "wage_sal_share",
                      "Employment Share: Non-agriculture Self-employment" = "self_emp_nonag_share",
                      "Employment Share: Self-employment" = "self_emp_share",
                      "Employment Share: Agriculture Self-employment" = "self_emp_agri_share",
                      "Employment Share: Unpaid Worker" = "unpaidworker_share"
      ),
      welfare = c("Piped Water" = "pipedwater",
                  "Electricity" = "electricity",
                  "Sewage" = "sewage",
                  "Poor 365" = "poor365",
                  "Poor 685" = "poor685",
                  "Bottom 40" = "bottom40",
                  "Bottom 20" = "bottom20")
    )

    # Update the subindicator dropdown based on selected data type
    output$subindicator_dropdown <- renderUI({
      req(input$data_type)
      selectInput(session$ns("subindicator"), "Sub-indicator:",
                  choices = subindicator_names[[input$data_type]],
                  selected = subindicator_names[[input$data_type]][1])
    })

    subindicator_readable <- reactive({
      # Get the readable names for the current data_type
      readable_names <- names(subindicator_names[[input$data_type]])

      # Find the index of the selected subindicator
      selected_index <- which(subindicator_names[[input$data_type]] == input$subindicator)

      # Get the readable name for the selected subindicator
      readable_names[selected_index]
    })

    # Filter the data based on the selected subindicator and years
    selected_data <- reactive({
      req(input$data_type, input$subindicator)
      shapefile_list[[input$data_type]][[input$subindicator]]
    })

    # Return the selected data type, subindicator, years, and filtered data
    return(reactive({
      req(selected_data(), input$data_type, input$subindicator)
      list(
        data_type = input$data_type,
        subindicator = input$subindicator,
        subindicator_readable = subindicator_readable(),
        data = selected_data()
        )
      })%>%  #putting preselected inputs in cache
        bindCache(input$data_type,input$subindicator)
      )
  })
}

## To be copied in the UI
# mod_indicator_selection_ui("indicator_selection_1")

## To be copied in the server
# mod_indicator_selection_server("indicator_selection_1")
