#' tippy UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_tippy_ui <- function(id){
  ns <- NS(id)
  tagList(
    h1("Tippy"),
    hr(),
    fluidRow(
      bs4Dash::bs4Card(
        title = "Filtros",
        width = 12,
        # linha 1
        fluidRow(
          # coluna 1 - filtro do ano
          column(
            width = 3,
            selectInput(
              inputId = ns("ano"),
              label = "Selecione um ano",
              choices = sort(unique(pnud$ano))
            )
          ),
          # coluna 2 - filtro da região
          column(
            width = 3,
            selectInput(
              inputId = ns("regiao"),
              label = "Selecione uma região",
              choices = sort(unique(pnud$regiao_nm))
            )
          ),
          # coluna 3 - filtro de estado -> vai ser atualizado no server com os
          # estados da região escolhida
          column(
            width = 3,
            selectInput(
              inputId = ns("uf"),
              label = "Selecione um estado",
              choices = c("Carregando..." =  "")
            )
          ),
          # coluna 4 - filtro de município -> vai ser atualizado no server com os
          # municípios do estado escolhido
          column(
            width = 3,
            selectInput(
              inputId = ns("muni"),
              label = "Selecione um município",
              choices = c("Carregando..." = "")
            )

          )
        ),
        # linha 2
        fluidRow(
          column(
            width = 2,
            offset = 5,
            # testando o pacote tippy
            # por alguma motivo existe um problema de compatibilidade entre o
            # css do bs4Dash e o pacote tippy, então ela acaba não aparecendo
            tippy::with_tippy(
              element = actionButton(
                inputId = ns("pesquisar"),
                label = "Pesquisar"
              ),
              tooltip = "Clique aqui"
            )

          )
        )
      )
    ),
    # espaço
    br(),
    # output
    reactable::reactableOutput(outputId = ns("tabela"))
  )
}

#' tippy Server Functions
#'
#' @noRd
mod_tippy_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    # atualizar escolha dos estados de acordo com a seleção da região
    observe({
      uf_escolhas <- pnud |>
        dplyr::filter(regiao_nm == input$regiao) |>
        dplyr::pull(uf_sigla)

      updateSelectInput(
        inputId = "uf",
        choices = uf_escolhas
      )
    })

    # atualizar escolha dos municípios de acordo com a uf escolhida
    observe({
      muni_escolhas <- pnud |>
        dplyr::filter(uf_sigla == input$uf) |>
        dplyr::select(muni_nm, muni_id) |>
        # deframe é para transformar a primeira coluna da tabela em um item
        # nomeado de uma lista e a segunda coluna o valor desse item, assim
        # poderemos passar o nome do município como filtro porém o que o filtro
        # vai efetivamente retornar é o código único do município
        tibble::deframe()

      updateSelectInput(
        inputId = "muni",
        choices = muni_escolhas
      )
    })

    # tabela filtrada -------------------------------------------------
    # gerar a pnud filtrada somente quando o botão de pesquisar for clicado
    pnud_filtrada <- eventReactive(input$pesquisar, {

      pnud |> dplyr::filter(
          ano == input$ano,
          muni_id == input$muni
        )
    })


    # output tabela ---------------------------------------------------
    output$tabela <- reactable::renderReactable({
      pnud_filtrada() |>
        dplyr::select(
          Município = muni_nm,
          População = pop,
          IDHM = idhm,
          `Esp. Vida` = espvida,
          `Renda per capita` = rdpc,
          GINI = gini
        ) |>
        reactable::reactable()
    })


  })
}

## To be copied in the UI
# mod_tippy_ui("tippy_1")

## To be copied in the server
# mod_tippy_server("tippy_1")
