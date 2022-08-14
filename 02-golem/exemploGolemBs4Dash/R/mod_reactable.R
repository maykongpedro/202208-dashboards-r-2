#' reactable UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_reactable_ui <- function(id) {
  ns <- NS(id)
  tagList(
    h1("Reactable"),
    fluidRow(
      bs4Dash::bs4Card(
        title = "Filtros",
        width = 12,
        fluidRow(
          column(
            width = 4,
            selectInput(
              inputId = ns("ano"),
              label = "Selecione o ano",
              choices = unique(sort(pnud$ano))
            )
          ),
          column(
            width = 4,
            selectInput(
              inputId = ns("metrica"),
              label = "Selecione a métrica",
              choices = c("idhm", "espvida", "rdpc", "gini")
            )
          )
        )
      )
    ),
    fluidRow(
      column(
        width = 12,
        reactable::reactableOutput(ns("tabela_rt"))
      )
    )
  )
}

#' reactable Server Functions
#'
#' @noRd
mod_reactable_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    # reactable ---------------------------------------------------------------

    output$tabela_rt <- reactable::renderReactable({
      pnud |>
        dplyr::filter(ano == input$ano) |>
        dplyr::arrange(dplyr::across(input$metrica, dplyr::desc)) |>
        dplyr::slice(1:10) |>
        dplyr::select(
          muni_nm,
          uf_sigla,
          input$metrica,
          idhm,
          espvida,
          rdpc,
          gini
        ) |>
        reactable::reactable(
          striped = TRUE,
          searchable = TRUE,
          filterable = TRUE,
          bordered = TRUE,
          highlight = TRUE,
          # defaultPageSize = 5,
          theme = reactable::reactableTheme(
            stripedColor = "grey"
          ),
          defaultColDef = reactable::colDef(
            align = "right"
          ),
          columns = list(
            muni_nm = reactable::colDef(
              align = "center"
            )
          )
        )
    })
  })
}

## To be copied in the UI
# mod_reactable_ui("reactable_1")

## To be copied in the server
# mod_reactable_server("reactable_1")
