#' plotly UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_plotly_ui <- function(id){
  ns <- NS(id)
  tagList(
    bs4Dash::bs4Card(
      title = "Filtro",
      width = 12,
      selectInput(
        inputId = ns("ano"),
        label = "Selecione um ano",
        choices = sort(unique(pnud$ano)),
        width = "25%" # para não ocupar toda a linha
      )
    ),
    fluidRow(
      column(
        width = 8,
        plotly::plotlyOutput(outputId = ns("grafico"))
      ),
      column(
        width = 4,
        reactable::reactableOutput(ns("tabela"))
      )
    )
  )
}

#' plotly Server Functions
#'
#' @noRd
mod_plotly_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    # criar base filtrada -----------------------------------------------------
    pnud_filtrada <- reactive({
      pnud |>
        dplyr::filter(ano == input$ano)
    })

    # output gráfico plotly ---------------------------------------------------
    output$grafico <- plotly::renderPlotly({
      p <- pnud_filtrada() |>
        ggplot2::ggplot() +
        ggplot2::aes(
          x = rdpc,
          y = espvida
        ) +
        ggplot2::geom_point()

      plotly::ggplotly(p)

    })


    # output tabela -----------------------------------------------------------
    output$tabela <- reactable::renderReactable({
      # para verificar o que retorna quando os pontos dos gráfico são clicados
      # print(plotly::event_data("plotly_click"))

      # salvar o ponto que foi clicado
      ponto_selecionado <- plotly::event_data("plotly_click")


      # condicional para exibir a tabela somente se um ponto for selcionado
      if (is.null(ponto_selecionado)) {
        NULL
      } else {
        pnud_filtrada() |>
          # cortar somente a linha que representa o número do ponto selecionado
          dplyr::slice(ponto_selecionado$pointNumber) |>
          dplyr::select(
            muni_nm,
            rdpc,
            espvida,
            idhm,
            gini) |>
          dplyr::mutate(# transformar todas as colunas em character para não ter problemas ao
            # empihlar os dados na próxima etapa
            dplyr::across(
              .fns = as.character
            )
          ) |>
          tidyr::pivot_longer(
            cols = dplyr::everything(),
            names_to = "var",
            values_to = "val"
          ) |>
          reactable::reactable(# renomear colunas exibidas na tabela
            columns = list(
              var = reactable::colDef(name = ""),
              val = reactable::colDef(name = "")
            ))
      }

    })


  })
}

## To be copied in the UI
# mod_plotly_ui("plotly_ui_1")

## To be copied in the server
# mod_plotly_server("plotly_ui_1")
