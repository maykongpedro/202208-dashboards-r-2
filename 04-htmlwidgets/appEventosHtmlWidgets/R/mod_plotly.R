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
    plotly::plotlyOutput(outputId = ns("grafico"))
  )
}

#' plotly Server Functions
#'
#' @noRd
mod_plotly_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    output$grafico <- plotly::renderPlotly({
      p <- pnud |>
        dplyr::filter(ano == input$ano) |>
        ggplot2::ggplot() +
        ggplot2::aes(
          x = rdpc,
          y = espvida
        ) +
        ggplot2::geom_point()

      plotly::ggplotly(p)

    })


  })
}

## To be copied in the UI
# mod_plotly_ui("plotly_ui_1")

## To be copied in the server
# mod_plotly_server("plotly_ui_1")
