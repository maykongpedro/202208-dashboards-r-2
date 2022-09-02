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
    h1("Leaflet"),
    hr(),

    # linha 1 -----------------------------------------------------------------
    # como estou chamando um módulo dentro de outro módulo, o input precisa
    # conter o 'ns'
    mod_filtro_ui(ns("filtro_1")),

    # espaço
    br(),

    # linha 2 -----------------------------------------------------------------
    fluidRow(
      # coluna 1
      column(
        width = 6,
        leaflet::leafletOutput(ns("mapa"))
      ),

      # coluna 2
      column(
        width = 6,
        reactable::reactableOutput(outputId = ns("tabela"))
      )
    )
  )
}

#' leaflet Server Functions
#'
#' @noRd
mod_leaflet_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    # obter filtros -----------------------------------------------------------
    filter_values <- mod_filtro_server("filtro_1")


  })
}

## To be copied in the UI
# mod_leaflet_ui("leaflet_1")

## To be copied in the server
# mod_leaflet_server("leaflet_1")
