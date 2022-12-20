#' accordion UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_accordion_ui <- function(id){
  ns <- NS(id)
  tagList(

    # h2 e h3 são utilizados para definir como os títulos irão aparecer
    div(
      # escolha dessa classe por conta da borda fina que ela forma nos objetos
      class = "ui segment",
      # título 3
      h3("Estimativa de carbono por ano"),
      # título 3
      h3(
        class = "ui grey sub header",
        "Total de emissões de CO2"
      ),
      # título 2
      h2("KPI Placeholder"),
      # espaço em branco
      br(),

      # accordion
      div(
        class = "ui accordion",

        # 1.1 título
        div(
          class = "title active",
          h4(class = "ui dividing header", "Viagem")
        ),

        # 1.2 conteúdo
        div(
          class = "content active",
          p("Conteúdo Placeholder")
        ),

        # 2.1 título
        div(
          class = "title",
          h4(class = "ui dividing header", "Habitação")
        ),

        # 2.2 conteúdo
        div(
          class = "content",
          p("Conteúdo Placeholder")
        )
      )
    )

  )
}

#' accordion Server Functions
#'
#' @noRd
mod_accordion_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

  })
}

## To be copied in the UI
# mod_accordion_ui("accordion_1")

## To be copied in the server
# mod_accordion_server("accordion_1")
