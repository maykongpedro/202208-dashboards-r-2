#' leaflet UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_leaflet_ui <- function(id){
  ns <- NS(id)
  tagList(
 
  )
}
    
#' leaflet Server Functions
#'
#' @noRd 
mod_leaflet_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_leaflet_ui("leaflet_1")
    
## To be copied in the server
# mod_leaflet_server("leaflet_1")
