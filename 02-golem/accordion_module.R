


accordionMasterUI <- function(id) {
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
          br()
      )
      
  )
}



accordionMasterServer <- function(id) {
  moduleServer(
    id,
    function(input, output, session) {
      
    }
  )
}