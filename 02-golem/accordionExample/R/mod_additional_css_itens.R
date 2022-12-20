#' additional_css_itens UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_additional_css_itens_ui <- function(id){
  ns <- NS(id)
  tagList(

    # exemplo de círculo aleatório para testar css
    div(
        class = "ui inverted circular segment",
        h2(
            class = "ui inverted header",
            "Buy Now",
            div(
                class = "sub header",
                "$10,99"
            )
        )
    )

  )
}

#' additional_css_itens Server Functions
#'
#' @noRd
mod_additional_css_itens_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

  })
}

## To be copied in the UI
# mod_additional_css_itens_ui("additional_css_itens_1")

## To be copied in the server
# mod_additional_css_itens_server("additional_css_itens_1")
