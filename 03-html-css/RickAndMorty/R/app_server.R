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
            dplyr::mutate(
                titulo = stringr::str_glue(
                    "{num_dentro_temporada} - {titulo}"
                )
            ) |> 
            dplyr::arrange(dplyr::desc(num_dentro_temporada)) |> 
            echarts4r::e_chart(
                x = qtd_espectadores_EUA,
                reorder = FALSE
            ) |> 
            echarts4r::e_bar(serie = titulo) |> 
            echarts4r::e_y_axis(type = "category") |> 
            echarts4r::e_x_axis(
                name = "Número de espectadores nos EUA (em milhões)",
                # fonte: https://echarts.apache.org/en/option.html#xAxis.nameLocation
                nameLocation = "center",
                # fonte: https://echarts.apache.org/en/option.html#xAxis.nameGap
                nameGap = 30
            ) |> 
            echarts4r::e_legend(show = FALSE) |> 
            # fazer com que o eixo y mostre todas o nome completo
            echarts4r::e_grid(containLabel = TRUE)
            
    })
    
}
