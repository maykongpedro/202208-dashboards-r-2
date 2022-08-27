#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function( input, output, session ) {
  # Your application server logic 
  
    output$plot <- echarts4r::renderEcharts4r({
        
        dados |> 
            dplyr::filter(num_temporada == input$temporada) |> 
            echarts4r::e_chart(x = qtd_espectadores_EUA) |> 
            echarts4r::e_bar(serie = titulo) |> 
            echarts4r::e_y_axis(type = "category" )
        
    })
    
}
