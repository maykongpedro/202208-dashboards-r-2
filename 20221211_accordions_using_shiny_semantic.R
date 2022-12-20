

# Load all ----------------------------------------------------------------
library(shiny)
library(shiny.semantic)

# carregando módulos enquanto não transformo esse script em projeto
source("02-golem/accordion_module.R")


# Get data ----------------------------------------------------------------
household_estimates <- readr::read_csv("https://raw.githubusercontent.com/taylorrodgers/public_datasets/main/household_carbon_estimates.csv")
total_estimates <- readr::read_csv("https://raw.githubusercontent.com/taylorrodgers/public_datasets/main/total_household_estimates.csv")

# ver estrutura
household_estimates |> dplyr::glimpse()
total_estimates |> dplyr::glimpse()


# ui ----------------------------------------------------------------------

ui <- shiny.semantic::semanticPage(
  h2("Exemplo de Accordions"),
  
  
  # exempl de círculo aleatório para testar css
  # div(
  #     class = "ui inverted circular segment",
  #     h2(
  #         class = "ui inverted header", 
  #         "Buy Now",
  #         div(
  #             class = "sub header",
  #             "$10,99"
  #         )
  #     )
  # ),
  # br(),
  
  div(
      # classe para controlar a posição dos itens, é como uma shiny::column()
      class = "ui stackable grid",
      
      div(
          class = "three wide column",
          style = "min-width: 350px;",
          # adicionando módulo
          accordionMasterUI("accordion")
      ),
  
      div(
          class = "four wide column",
          h3("Total por categoria"),
          div(
              class = "ui raised segment",
              style = "min-width: 550px;",
              tableOutput(outputId = "test_table")
          )
      )
  )
)

server <- function(input, output, session) {
    
    # adicionando módulo
    accordionMasterServer("accordion")
    
    output$test_table <- renderTable({
        total_estimates
    })
    
}

shinyApp(ui, server)