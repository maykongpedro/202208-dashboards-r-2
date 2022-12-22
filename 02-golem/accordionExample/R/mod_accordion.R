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
      h3("Estimativa de carbono por ano"),
      # título 3
      h3(
        class = "ui grey sub header",
        "Total de emissões de CO2"
      ),
      # título 2
      h2(
        textOutput(outputId = ns("total_geral"))
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
        dplyr::filter(total_type == "Grand") |>
        dplyr::transmute(
          total_geral = round(yearly_emissions, 2)
        ) |>
        paste0()
    })


    period <- "year"
    output$viagem_total <- renderText({
      total_estimates |>
        # seleciona a coluna 'total_type' e todas as colunas que possuem 'year' no nome
        dplyr::select(total_type, dplyr::contains(period)) |>
        # renomeia a coluna 2
        dplyr::rename(emissions = 2) |>
        # filtra apenas o tipo 'travel'
        dplyr::filter(total_type == "Travel") |>
        # resume a coluna emissões
        dplyr::transmute(
          emissoes = round(emissions, 2)
        ) |>
        # exporta como texto
        paste0("/ano")
    })


    output$viagens_subtotal <- renderTable({
      household_estimates |>
        dplyr::select(categories, subcategories, contains(period)) |>
        dplyr::rename(emissions = 3) |>
        dplyr::filter(categories == "Travel") |>
        dplyr::arrange(subcategories) |>
        dplyr::group_by(subcategories) |>
        dplyr::summarise(
          emissions = sum(
            round(emissions, 2)
          )
        ) |>
        dplyr::rename(
          Subcategorias = subcategories,
          `Emissões` = emissions
        )
    })


    output$hospedagem_total <- renderText({
      total_estimates |>
        dplyr::select(total_type, dplyr::contains(period)) |>
        dplyr::filter(total_type == "Housing") |>
        dplyr::transmute(
          emissoes = round(yearly_emissions, 2)
        ) |>
        paste0("/ano")
    })


    output$hospedagem_subtotal <- renderTable({
      household_estimates |>
        dplyr::select(categories, subcategories, contains(period)) |>
        dplyr::rename(emissions = 3) |>
        dplyr::filter(categories == "Housing") |>
        dplyr::arrange(subcategories) |>
        dplyr::group_by(subcategories) |>
        dplyr::summarise(
          emissions = sum(
            round(emissions, 2)
          )
        ) |>
        dplyr::rename(
          Subcategorias = subcategories,
          `Emissões` = emissions
        )
    })


    # Necessário adicionar essa opção para o accordion funcionar de maneira adequada
    outputOptions(output, "hospedagem_subtotal", suspendWhenHidden = FALSE)


  })
}

## To be copied in the UI
# mod_accordion_ui("accordion_1")

## To be copied in the server
# mod_accordion_server("accordion_1")
