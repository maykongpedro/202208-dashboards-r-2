

# Load all ----------------------------------------------------------------
library(shiny)
library(shiny.semantic)


# Get data ----------------------------------------------------------------
household_estimates <- read_csv("https://raw.githubusercontent.com/taylorrodgers/public_datasets/main/household_carbon_estimates.csv")
total_estimates <- read_csv("https://raw.githubusercontent.com/taylorrodgers/public_datasets/main/total_household_estimates.csv")

# ver estrutura
household_estimates |> dplyr::glimpse()
total_estimates |> dplyr::glimpse()


# ui ----------------------------------------------------------------------

ui <- shiny.semantic::semanticPage(
  h2("Exemplo de Accordions"),
  div(
      class = "ui stackable grid",
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
    
    output$test_table <- renderTable({
        total_estimates
    })
    
}

shinyApp(ui, server)