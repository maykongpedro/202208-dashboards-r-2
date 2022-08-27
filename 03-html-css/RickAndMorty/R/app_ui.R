#' The application User-Interface
#' 
#' @param request Internal parameter for `{shiny}`. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic 
    fluidPage(
      # título
      h1("Rick and Morty", align = "center"),
      # linha em branco
      hr(),
      # linha 1 com conteúdo
      fluidRow(
        column(
          width = 3,
          selectInput(
            inputId = "temporada",
            label = "Selecione a temporada:",
            choices = unique(dados$num_temporada) |> sort()
          )
        )
      ),
      
      # linha 2 - gráfico
      fluidRow(
        column(
          width = 2,
          # imagem
          img(
            src = "www/rick.png",
            # esse width deixa de ser necessário após o uso do css
            # width = "100%", # a imagem tem que ser 100% do tamanho disponível na coluna
            class = "img_rick_and_morty" # adicionar uma class para poder alterar no css
          )
        ),
        column(
          width = 10,
          # offset = 2, não é mais necessário pois a imagem já vai ocupar o espaço
          class = "areaGrafico", # adicionar uma cass para poder alterar o bg no css
          echarts4r::echarts4rOutput(
            outputId = "plot",
            height = "600px"            
          )
        )
      )
    )
  )
}

#' Add external Resources to the Application
#' 
#' This function is internally used to add external 
#' resources inside the Shiny application. 
#' 
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function(){
  
  add_resource_path(
    'www', app_sys('app/www')
  )
 
  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys('app/www'),
      app_title = 'RickAndMorty'
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert() 
  )
}

