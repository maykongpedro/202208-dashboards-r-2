#' accordion_title_content UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_accordion_title_content_ui <- function(id, active_ind = FALSE){
  ns <- NS(id)
  tagList(

    # 1.1 título
    div(
      # definir se vai aparece ativo ou não
      class = ifelse(active_ind == TRUE, "title active", "title"),
      h4(
        class = "ui dividing header",
        div(
          class = "ui grid",
          div(
            class = "two column row",
            # texto à esquerda
            div(
              class = "left floated column",
              textOutput(ns("titulo_cabecalho"), inline = TRUE)
            ),
            # texto à direita
            div(
              class = "right floated column",
              style = "text-align: right",
              textOutput(outputId = ns("total"))
            )
          )
        )
      )
    ),

    # 1.2 conteúdo
    div(
      class = ifelse(active_ind == TRUE, "content active", "content"),
      div(
        # adicionar cor
        class = "ui teal inverted segment",
        # adicionar a tabela com o subtotal por categoria
        tableOutput(outputId = ns("subtotal"))
      )
    ),

  )
}

#' accordion_title_content Server Functions
#'
#' @noRd
mod_accordion_title_content_server <- function(id, category, period){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    # gera o título do cabeçalho
    output$titulo_cabecalho <- renderText({
      glue::glue("Total {category}: ")
    })

    # gera o valor total com o sufixo correto
    output$total <- renderText({
        CalcularTotais(categoria = category, period = period)
    })

    # gera o subtotal com o sufixo correto
    output$subtotal <- renderTable(
      # fazer a tabela usar 100% do espaço disponível
      width = "100%",
      # remover título das colunas
      colnames = FALSE, {

        # calcular sub total e gerar tabela
        CalcularSubTotais(categoria = category, periodo = period)
    })


    # Necessário adicionar essa opção para o accordion funcionar de maneira adequada
    outputOptions(output, "subtotal", suspendWhenHidden = FALSE)

  })
}

## To be copied in the UI
# mod_accordion_title_content_ui("accordion_title_content_1")

## To be copied in the server
# mod_accordion_title_content_server("accordion_title_content_1")
