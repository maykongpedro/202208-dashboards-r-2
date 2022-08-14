#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic

  observe({

    # filtrar poluentes de acordo com a estação
    opcoes <- cetesb |>
      dplyr::filter(estacao_cetesb == input$estacao) |>
      dplyr::pull(poluente) |>
      unique()

    # atualizar o select input com a nova lista
    updateSelectInput(
      inputId = "poluente",
      choices = opcoes
    )
  })

  output$grafico <- echarts4r::renderEcharts4r({
    req(input$poluente) # precisa da escolha do poluente pra rodar

    cetesb |>
      dplyr::filter(
        estacao_cetesb == input$estacao,
        poluente == input$poluente
      ) |>
      dplyr::group_by(data) |>
      dplyr::summarise(media = mean(concentracao, na.rm = TRUE)) |>
      echarts4r::e_chart(x = data) |>
      echarts4r::e_line(serie = media)
    
  })
}
