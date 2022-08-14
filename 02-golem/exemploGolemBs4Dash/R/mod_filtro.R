#' filtro UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_filtro_ui <- function(id){
  ns <- NS(id)
  tagList(
    fluidRow(
      bs4Dash::bs4Card(
        title = "Filtros",
        width = 12,
        fluidRow(
          column(
            width = 4,
            selectInput(
              inputId = ns("ano"),
              label = "Selecione o ano",
              choices = unique(sort(pnud$ano))
            )
          ),
          column(
            width = 4,
            selectInput(
              inputId = ns("metrica"),
              label = "Selecione a métrica",
              choices = c("idhm", "espvida", "rdpc", "gini")
            )
          )
        )
      )
    ),
  )
}

#' filtro Server Functions
#'
#' @noRd
mod_filtro_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    # para retornar os inputs existem duas formas, a primeira
    # é a que eu já conhecia por ter precisado antes:
    # return(
    #   list(
    #     ano = reactive({input$ano}),
    #     metrica = reactive({input$metrica})
    #   )
    # )

    # a segunda é o que o prof mostrou em aula, assim usamos
    # a função reative apenas uma vez.
    return(
      reactive({
        list(
          ano = input$ano,
          metrica = input$metrica
        )
      })
    )

  })
}

## To be copied in the UI
# mod_filtro_ui("filtro_1")

## To be copied in the server
# mod_filtro_server("filtro_1")
