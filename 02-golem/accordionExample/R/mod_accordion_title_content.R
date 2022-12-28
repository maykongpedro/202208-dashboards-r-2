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
        textOutput(outputId = ns("total"))
      )
    ),

    # 1.2 conteúdo
    div(
      class = ifelse(active_ind == TRUE, "content active", "content"),
      # p("Conteúdo Placeholder") # foi substituído pela tabela
      tableOutput(outputId = ns("subtotal"))
    ),

  )
}

#' accordion_title_content Server Functions
#'
#' @noRd
mod_accordion_title_content_server <- function(id, category, period){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    output$total <- renderText({
      glue::glue(
        "Total {category}: {CalcularTotais(categoria = category, period = period)}"
      )
    })


    output$subtotal <- renderTable({
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
