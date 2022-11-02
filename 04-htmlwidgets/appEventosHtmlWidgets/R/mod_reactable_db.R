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
    h1("Reactable"),
    hr(),

    # linha 1 -----------------------------------------------------------------
    fluidRow(
      bs4Dash::bs4Card(
        title = "Filtros",
        width = 12,
        # linha
        fluidRow(
          # coluna 1
          column(
            width = 4,
            selectInput(
              inputId = ns("ano"),
              label = "Selecione um ano",
              # Não puxa direto da base pois na teoria a base não existe, o que
              # existe é apenas a conexão com os dados, esse output teria que ser
              # um uiOutput ou as escolhas precisão ser criadas manualmente como
              # na próxima linha
              # choices = unique(pnud$ano),
              choices = c(1991, 2000, 2010),
              width = "90%"
            )
          ),
          # coluna 2
          column(
            width = 4,
            selectInput(
              inputId = ns("metrica"),
              label = "Selecione uma métrica",
              choices = c(
                "IDHM" = "idhm",
                "Expectativa de vida" = "espvida",
                "Renda per capita" = "rdpc",
                "Índice de GINI" = "gini"
              ),
              width = "90%"
            )
          )
        )
      )
    ),

    # espaço
    br(),

    # linha 2 -----------------------------------------------------------------
    fluidRow(
      # coluna 1
      column(
        width = 6,
        reactable::reactableOutput(outputId = ns("tabela"))
      ),
      # coluna 2
      column(
        width = 6,
        leaflet::leafletOutput(ns("mapa"))
      )
    )
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
