#' accordion UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_accordion_ui <- function(id, period){
  ns <- NS(id)
  tagList(

    # carregar javascript para que o click no accordion funcione
    # shiny::tags$script(src = "www/accordion.js"), # nao funcionou
    shiny::tags$script(
      "$(document).ready(function() {
       $('.ui.accordion').accordion();
       })"
    ),

    # h2 e h3 são utilizados para definir como os títulos irão aparecer
    div(
      # escolha dessa classe por conta da borda fina que ela forma nos objetos
      class = "ui segment",
      # título 3
      h3(
        paste0(
          "Estimativa de carbono",
          dplyr::case_when(
            period == "year" ~ " por ano",
            period == "month" ~ " por mês",
            TRUE ~ " por semana"
          )
        )
      ),
      # título 3
      h3(
        class = "ui grey sub header",
        "Total de emissões de CO2"
      ),
      # título 2
      div(
        class = "ui grid",
        div(
          class = "four column row",
          # coluna 1
          div(
            class = "column",
            h2(
              class = "ui dividing header", # cria uma pequena linha embaixo do título
              textOutput(outputId = ns("total_geral"))
            )
          ),
          # coluna 2
          div(
            class = "column",
            shiny::strong(
              paste0(
                dplyr::case_when(
                  period == "year" ~ " /ano",
                  period == "month" ~ " /mês",
                  TRUE ~ " /semana"
                )
              )
            )
          )
        )
      ),


      # espaço em branco
      br(),

      # accordion
      div(
        class = "ui accordion",

        # 1.1 título
        div(
          class = "title active",
          h4(
            class = "ui dividing header",
            textOutput(outputId = ns("viagem_total"))
            )
        ),

        # 1.2 conteúdo
        div(
          class = "content active",
          # p("Conteúdo Placeholder") # foi substituído pela tabela
          tableOutput(outputId = ns("viagens_subtotal"))
        ),

        # 2.1 título
        div(
          class = "title",
          h4(
            class = "ui dividing header",
            textOutput(outputId = ns("hospedagem_total"))
            )
        ),

        # 2.2 conteúdo
        div(
          class = "content",
          # p("Conteúdo Placeholder") # foi substituído pela tabela
          tableOutput(outputId = ns("hospedagem_subtotal"))
        )
      )
    )

  )
}

#' accordion Server Functions
#'
#' @noRd
mod_accordion_server <- function(id, period){
  moduleServer( id, function(input, output, session){
    ns <- session$ns


    output$total_geral <- renderText({
      total_estimates |>
        dplyr::select(total_type, dplyr::contains(period)) |>
        dplyr::rename(emissions = 2) |>
        dplyr::filter(total_type == "Grand") |>
        dplyr::transmute(
          total_geral = round(emissions, 2)
        ) |>
        paste0()
    })


    output$viagem_total <- renderText({
      CalcularTotais(categoria = "Travel", periodo = period)
    })


    output$viagens_subtotal <- renderTable({
      CalcularSubTotais(categoria = "Travel", periodo = period)
    })


    output$hospedagem_total <- renderText({
      CalcularTotais(categoria = "Housing", periodo = period)
    })


    output$hospedagem_subtotal <- renderTable({
      CalcularSubTotais(categoria = "Housing", periodo = period)
    })


    # Necessário adicionar essa opção para o accordion funcionar de maneira adequada
    outputOptions(output, "hospedagem_subtotal", suspendWhenHidden = FALSE)


  })
}

## To be copied in the UI
# mod_accordion_ui("accordion_1")

## To be copied in the server
# mod_accordion_server("accordion_1")
