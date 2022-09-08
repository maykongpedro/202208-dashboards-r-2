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

    # obter filtros -----------------------------------------------------------
    filter_values <- mod_filtro_server("filtro_1")


    # output gráfico ---------------------------------------------------------
    output$grafico <- echarts4r::renderEcharts4r({

      # criar uma função javascript personalizada para exibir uma tooltip
      tooltip <- htmlwidgets::JS(
        glue::glue(
          "function (params) {
          // printar o objeto params na página para poder identificar o que preciso capturar
          console.log(params);

          // criar variável que recebe o atributo name do 'params'
          tx = params.name + '<br>' + '{{filter_values()$metrica}}: ' + params.value[1];

          // retorna a variável tx
          return(tx)
        }",
        .open = "{{", # trocar a notação do glue para nao gerar problemas com o javascript
        .close = "}}" # trocar a notação do glue para nao gerar problemas com o javascript
      )
      )

      pnud |>
        dplyr::filter(ano == filter_values()$ano) |>
        dplyr::group_by(uf_sigla) |>
        dplyr::summarise(
          media = mean(.data[[filter_values()$metrica]]),
          media = round(media, 2) # arredondar para duas casas decimais
        ) |>
        dplyr::arrange(dplyr::desc(media)) |>
        echarts4r::e_chart(x = uf_sigla) |>
        echarts4r::e_bar(serie = media, legend = FALSE) |>
        # echarts4r::e_tooltip()
        nossa_e_tooltip(
          # testando uma string aleatória
          # formatter = "texto",

          # essa primeira tentativa funciona porém não retorna o resultado esperado,
          # porque o value é uma concateção do eixo x e y
          # gerando o texto que irá aparecer na tooltip
          # formatter = glue::glue(
          #
          #   # fonte: https://echarts.apache.org/en/option.html#tooltip.formatter
          #   "{b}<br>[filter_values()$metrica]: {c}",
          #   .open = "[", # trocar a notação do glue para nao gerar problemas ao lançar o texto
          #   .close = "]" # trocar a notação do glue para nao gerar problemas ao lançar o texto
          # )

          # segunda tentativa usando uma função javascript
          formatter = tooltip

        )

    })

  })
}

## To be copied in the UI
# mod_echarts_ui("echarts_1")

## To be copied in the server
# mod_echarts_server("echarts_1")
