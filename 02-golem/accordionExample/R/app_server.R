#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic


    # output$test_input <- renderText({
    #   input$period
    # })

    mod_accordion_server("accordion_year", period = "year")
    mod_accordion_server("accordion_month", period = "month")
    mod_accordion_server("accordion_week", period = "week")

    output$test_table <- renderTable({
        total_estimates
    })

}

