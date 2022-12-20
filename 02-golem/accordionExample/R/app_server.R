#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic

    mod_accordion_server("accordion_1")

    output$test_table <- renderTable({
        total_estimates
    })

}

