#' reactable_db UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_reactable_db_ui <- function(id){
  ns <- NS(id)
  tagList(
 
  )
}
    
#' reactable_db Server Functions
#'
#' @noRd 
mod_reactable_db_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_reactable_db_ui("reactable_db_1")
    
## To be copied in the server
# mod_reactable_db_server("reactable_db_1")
