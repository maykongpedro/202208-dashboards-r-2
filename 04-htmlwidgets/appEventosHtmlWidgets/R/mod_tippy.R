#' tippy UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_tippy_ui <- function(id){
  ns <- NS(id)
  tagList(
 
  )
}
    
#' tippy Server Functions
#'
#' @noRd 
mod_tippy_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_tippy_ui("tippy_1")
    
## To be copied in the server
# mod_tippy_server("tippy_1")
