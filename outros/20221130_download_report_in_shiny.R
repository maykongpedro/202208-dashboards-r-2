
library(shiny)
library(data.validator)
library(magrittr)
library(assertr)


# Criar report ------------------------------------------------------------

report <- data_validation_report()
validate(mtcars, name = "Verifying cars dataset") %>%
    validate_if(drat > 0, description = "Column drat has only positive values") %>%
    validate_cols(in_set(c(0, 2)), vs, am, description = "vs and am values equal 0 or 2 only") %>%
    validate_cols(within_n_sds(1), mpg, description = "mpg within 1 sds") %>%
    validate_rows(num_row_NAs, within_bounds(0, 2), vs, am, mpg, description = "not too many NAs in rows") %>%
    validate_rows(maha_dist, within_n_mads(10), everything(), description = "maha dist within 10 mads") %>%
    add_results(report)


# Ui ----------------------------------------------------------------------

ui <- fluidPage(
    
    theme = bslib::bs_theme(version = 4),
    tabsetPanel(
        
        tabPanel(
            "Baixar relatório",
            h2("Download do relatório"),
            hr(),
            fluidRow(
                column(
                    width = 2,
                    downloadButton(
                        outputId = "baixar_relatorio",
                        label = "Download relatório"
                    )
                )
            )
        ),
        
        tabPanel(
            "Visualizar relatório",
            uiOutput("validation")
        )
    )
)


# Server ------------------------------------------------------------------

server <- function(input, output, session) {
    
    output$baixar_relatorio <- downloadHandler(
        
        filename = "relatorio.html",
        
        content = function(file){
            
            # Ambas tentativas salvam o arquivo html com um nome aleatório no
            # diretório principal do app, porém o que quero é que faça o download.
            
            # Tentativa 1: usando a função para salver o relatório. Não funciona
            data.validator::save_report(
                report = report,
                output_file = file,
            )
            
            # Tentativa 2: criar arquivo temporário e salvar. Não funciona.
            # arquivo_html <- tempfile(
            #     fileext = ".html"
            # )
            # 
            # data.validator::save_report(
            #     report = report,
            #     output_file = arquivo_html,
            # )
            
        }
        
    )
    
    output$validation <- renderUI({
        render_semantic_report_ui(get_results(report))
    })
    
}

shinyApp(ui, server)