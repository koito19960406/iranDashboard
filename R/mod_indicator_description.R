#' indicator_description UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_indicator_description_ui <- function(id){
  ns <- NS(id)
  tagList(
    p(strong("Indicator decription:")),
    verbatimTextOutput(ns("description")),
    tags$head(tags$style(paste0("#", ns("description"), "{color:black; font-size:12px; font-style:italic;
              overflow-y:scroll; max-height: 120px; background: white;}")))
  )
}

#' indicator_description Server Functions
#'
#' @noRd
mod_indicator_description_server <- function(id, data_reactive){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    # Define a named vector of descriptions
    indicator_description <- c(
      "WAP" = "Working age population rate refers to the percentage of the working-age population in a province that is currently employed or seeking employment.",
      "lfp" = "Labor force participation rate is the percentage of the working-age population that is either employed or unemployed and actively seeking employment.",
      "educ_none" = "Education attainment level rate: none refers to the percentage of the working-age population in a province with no formal education.",
      "educ_primary" = "Education attainment level rate: primary education refers to the percentage of the working-age population in a province with a primary level of education.",
      "educ_secondary" = "Education attainment level rate: secondary education refers to the percentage of the working-age population in a province with a secondary level of education.",
      "educ_tertiary" = "Education attainment level rate: tertiary education refers to the percentage of the working-age population in a province with a tertiary level of education.",
      "employrate" = "Employment rate refers to the percentage of the working-age population that is currently employed.",
      "unemprate" = "Unemployment rate refers to the percentage of the labor force that is currently unemployed and actively seeking employment.",
      "youth_unemprate" = "Youth unemployment rate refers to the percentage of young people (aged 15-24) in the labor force that are currently unemployed and actively seeking employment.",
      "youth_terciary_unemprate" = "Youth unemployment rate among those with tertiary education refers to the percentage of young people (aged 15-24) with tertiary education that are currently unemployed and actively seeking employment.",
      "longterm_unemprate" = "Long-term unemployment rate refers to the percentage of the labor force that has been unemployed for 12 months or more.",
      "underemployment_rate" = "Underemployment rate refers to the percentage of the labor force that is employed part-time but would like to work full-time.",
      "agri_employ_share" = "Employment share: agriculture refers to the percentage of the working-age population that is employed in agriculture.",
      "industry_employ_share" = "Employment share: industry refers to the percentage of the working-age population that is employed in industry.",
      "service_employ_share" = "Employment share: service refers to the percentage of the working-age population that is employed in the service sector.",
      "public_share" = "Employment share: public refers to the percentage of the working-age population that is employed in the public sector.",
      "wage_sal_share" = "Employment share: wage refers to the percentage of the working-age population that is employed in jobs that pay a wage.",
      "self_emp_nonag_share" = "Employment share: non-agriculture self-employment refers to the percentage of the working-age population that is self-employed outside of the agriculture sector.",
      "self_emp_share" = "Employment share: self-employment refers to the percentage of the working-age population that is self-employed.",
      "self_emp_agri_share" = "Employment share: agriculture self-employment refers to the percentage of the working-age population that is self-employed in the agriculture sector.",
      "unpaidworker_share" = "Employment share: unpaid worker refers to the percentage of the working-age population that works without pay in a family enterprise or on their own household farm.",
      "pipedwater" = "Piped water refers to the percentage of households in a province with access to piped water.",
      "electricity" = "Electricity refers to the percentage of households in a province with access to electricity.",
      "sewage" = "Sewage refers to the percentage of households in a province with access to improved sanitation facilities.",
      "poor365" = "Poor 365 refers to the percentage of the population living below the poverty line of under 3.65 2017 dollars a day PPP",
      "poor685" = "Poor 685 refers to the percentage of the population living below the poverty line of under 6.85 2017 dollars a day PPP",
      "bottom40" = "Bottom 40 refers to the percentage of the population with the lowest income, ranked from lowest to highest, and representing the bottom 40% of the income distribution.",
      "bottom20" = "Bottom 20 refers to the percentage of the population with the lowest income, ranked from lowest to highest, and representing the bottom 20% of the income distribution."
    )

    # Create a reactive expression for the explanation text
    explanation <- reactive({
      req(data_reactive())
      indicator_name <- data_reactive()$subindicator

      # Look up the explanation text in the subindicator_names list
      indicator_description[indicator_name]
    })

    # Output the explanation text
    output$description <- renderText({
      explanation()
    })
  })
}

## To be copied in the UI
# mod_indicator_description_ui("indicator_description_1")

## To be copied in the server
# mod_indicator_description_server("indicator_description_1")
