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

    # obter filtros -----------------------------------------------------------
    filter_values <- mod_filtro_server("filtro_1")

    # criar base com o top 10 ------------------------------------
    data_top_10 <- reactive({
      pnud |>
        dplyr::filter(ano == filter_values()$ano) |>
        dplyr::arrange(dplyr::desc(.data[[filter_values()$metrica]])) |>
        dplyr::slice(1:10)

    })

    # output tabela ----------------------------------------------
    output$tabela <- reactable::renderReactable({
      data_top_10() |>
        dplyr::select(
          muni_nm,
          one_of(filter_values()$metrica),
          espvida,
          idhm,
          rdpc,
          gini
        ) |>
        reactable::reactable(
          # para selecionar várias linhas na tabela
          selection = "multiple",
          defaultSelected = 1 # para sempre começar com a linha 1 selecionada
        )
    })


    # output mapa -------------------------------------------------
    # dentro desse output temos um problema de reatividade, pois ela é acionada
    # nas linhas selecionadas e no "data_top_10", o que força o mapa a rodar 2x,
    # caso esse processo de construção do mapa demorasse, seria necessário realizar
    # um ajuste de reatividade mais complexo. Uma ideia do professor seria criar
    # um botão que fizesse o filtro, assim tudo seria ativado somente quando o
    # botão fosse acionado.
    # Para esse caso um 'isolate' não funcionaria pois impede a reatividade de um
    # dos itens funcionar, e precisamos que os dois itens reativos funcionem...
    output$mapa <- leaflet::renderLeaflet({
      # obter linhas selecionadas da tabela, o retorno é um vetor com o índice
      # de cada linha selecionada
      linhas_selecionadas <- reactable::getReactableState(
        outputId = "tabela",
        name = "selected"
      )

      # para a primeira rodada onde nada é selecionado ele não faz nada
      if (is.null(linhas_selecionadas)) {
        NULL
      } else {
        # plotar o mapa
        data_top_10() |>
          dplyr::slice(linhas_selecionadas) |>
          leaflet::leaflet() |>
          leaflet::addTiles() |>
          leaflet::addAwesomeMarkers(
            lng = ~ lon,
            lat = ~ lat,
            label = ~ muni_nm
          )
      }

    })

  })
}

## To be copied in the UI
# mod_reactable_ui("reactable_1")

## To be copied in the server
# mod_reactable_server("reactable_1")
