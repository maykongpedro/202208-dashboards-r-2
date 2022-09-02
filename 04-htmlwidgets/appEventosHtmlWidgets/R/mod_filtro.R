#' filtro UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_filtro_ui <- function(id){
  ns <- NS(id)
  tagList(
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
              choices = unique(pnud$ano),
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
    )
  )
}

#' filtro Server Functions
#'
#' @noRd
mod_filtro_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    valores_do_filtro <- reactive({

      list(
        ano = input$ano,
        metrica = input$metrica
      )

    })

  })
}

## To be copied in the UI
# mod_filtro_ui("filtro_1")

## To be copied in the server
# mod_filtro_server("filtro_1")
