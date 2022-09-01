#' reactable UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_reactable_ui <- function(id){
  ns <- NS(id)
  tagList(
    h1("Reactable"),
    hr(),
    # linha 1
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
    ),
    # espaço
    br(),
    # linha 2
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

#' reactable Server Functions
#'
#' @noRd
mod_reactable_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    # criar base com o top 10
    data_top_10 <- reactive({
      pnud |>
        dplyr::filter(ano == input$ano) |>
        dplyr::arrange(dplyr::desc(.data[[input$metrica]])) |>
        dplyr::slice(1:10) |>
        dplyr::select(
          muni_nm,
          one_of(input$metrica),
          espvida,
          idhm,
          rdpc,
          gini
        )
    })

    # output tabela
    output$tabela <- reactable::renderReactable({
      data_top_10() |> reactable::reactable(
        # para selecionar várias linhas na tabela
        selection = "multiple"
        )
    })


  })
}

## To be copied in the UI
# mod_reactable_ui("reactable_1")

## To be copied in the server
# mod_reactable_server("reactable_1")
