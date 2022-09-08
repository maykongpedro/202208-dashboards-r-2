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

        # é necessário usar o glue para conseguir capturar o input "metrica", caso
        # não houvesse nenhum vetor em R a ser adicionado, não haveri necessidade
        # de usar o glue
        glue::glue(
          "function (params) {
          // printar o objeto params na página para poder identificar o que preciso capturar
          console.log(params);

          // criar variável que recebe o atributo name do 'params'
          // uma alternativa para arredondar valores diretament pelo javascript
          // é usar a função parseFloat(numero).toFixed(qtd_casas_decimais)
          // a tag <br> é para gerar um espaço, já a tag <b> é para deixar o texto em negrito
          // params.name adiciona o nome do eixo x selecionado
          // params.marker adiciona a bolinha antes do nome da métrica
          // params.value[1] captura o segundo índice dos valores da série, o primeiro item é a UF
          tx = params.name + '<br>' + params.marker + '<b>{{filter_values()$metrica}}<b>: ' + params.value[1];

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
          formatter = tooltip,

          # alterar a cor da borda , caso fosse mais de uma série no gráfico,
          # esse argumento iria receber um vetor de cores
          borderColor = "purple",

          # alterar a cor de fundo da tooltip
          backgroundColor  =  "yellow"

        ) |>
        echarts4r::e_color(color = "purple") # alterar cor do gráfico

    })

  })
}

## To be copied in the UI
# mod_echarts_ui("echarts_1")

## To be copied in the server
# mod_echarts_server("echarts_1")
