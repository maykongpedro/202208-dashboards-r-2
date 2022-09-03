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


    # output mapa -------------------------------------------------------------
    output$mapa <- leaflet::renderLeaflet({

      # criar tabela para o mapa
      tab_mapa <- pnud |>
        dplyr::filter(ano == filter_values()$ano) |>
        dplyr::group_by(uf_sigla) |>
        dplyr::summarise(
          media = mean(
            x = .data[[filter_values()$metrica]],
            na.rm = TRUE
          )
        ) |>
        # join com os dados geo -> essa etapa transoforma os dados em tibble
        dplyr::left_join(
          y = geo_estados,
          by = c("uf_sigla" = "abbrev_state")
        ) |>
        # transformar novamente para geo
        sf::st_as_sf()

      # criar vetor para as cores
      cores <- leaflet::colorNumeric(
        palette = rev(viridis::plasma(8)), # vetor de cores
        domain = tab_mapa$media # domínio/abrangência que a função vai alocar as cores
      )

        # jogar dados no mapa
      tab_mapa |>
        leaflet::leaflet() |>
        leaflet::addTiles() |>
        leaflet::addPolygons(
          layerId = ~uf_sigla, # necessário para ser utilizado no "click"
          fillColor = ~cores(media),
          color = "black",
          fillOpacity = 0.8,
          weight = 1,
          label = ~name_state
        ) |>
        leaflet::addLegend(
          pal = cores,
          values = ~media,
          opacity = 0.7,
          title = NULL,
          position = "bottomright"
        )
    })


    # output tabela -----------------------------------------------------------
    output$tabela <- reactable::renderReactable({

      # usar o browser para descobrir quais as possibilidades ao clicar dentro
      # dos shapes, e ir exploarando os inputs ativos na sessão
      # browser()


      # seleção de estado, começa com a seleção de um estado para poder filtrar
      # a tabela, conforme a seleção vai sendo feita o estado vai mudando
      estado <- input$mapa_shape_click$id # retorna o layerID do shape clicado

      if (is.null(estado)) {
        estado <- "RJ"
      }

      # filtrar base e organizar dados
      pnud |>
        dplyr::filter(
          uf_sigla == estado,
          ano == filter_values()$ano
        ) |>
        dplyr::arrange(dplyr::desc(.data[[filter_values()$metrica]])) |>
        dplyr::slice(1:10) |>
        dplyr::select(
          muni_nm,
          one_of(filter_values()$metrica),
          espvida,
          idhm,
          rdpc,
          gini
        ) |>
        # gerar a tabela
        reactable::reactable()


    })

  })
}

## To be copied in the UI
# mod_leaflet_ui("leaflet_1")

## To be copied in the server
# mod_leaflet_server("leaflet_1")
