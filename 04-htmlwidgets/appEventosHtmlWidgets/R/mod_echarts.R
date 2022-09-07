#' echarts UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_echarts_ui <- function(id){
  ns <- NS(id)
  tagList(
    h1("Echarts"),
    hr(),

    # Linha 1 -----------------------------------------------------------------
    mod_filtro_ui(ns("filtro_1")),

    br(),


    # Linha 2 -----------------------------------------------------------------
    fluidRow(
      column(
        width = 12,
        echarts4r::echarts4rOutput(outputId = ns("grafico"))
      )
    )

  )
}

#' echarts Server Functions
#'
#' @noRd
mod_echarts_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

  })
}

## To be copied in the UI
# mod_echarts_ui("echarts_1")

## To be copied in the server
# mod_echarts_server("echarts_1")
