

# Example 1 ---------------------------------------------------------------
# Fonte: https://appsilon.github.io/data.validator/articles/data_validator.html

library(assertr)
library(dplyr)
library(data.validator)

report <- data_validation_report()

validate(mtcars) |>
    validate_cols(description = "vs and am values equal 0 or 2 only",
                  in_set(c(0, 2)), vs, am) |>
    validate_cols(description = "vs and am values should equal 3 or 4",
                  skip_chain_opts = TRUE,
                  error_fun = warning_append, in_set(c(3, 4)), gear, carb) |>
    validate_rows(description = "Each row sum for am:vs columns is less or equal 1",
                  rowSums, within_bounds(0, 1), vs:am) |>
    validate_cols(description = "For wt and qsec we have: abs(col) < 2 * sd(col)",
                  within_n_sds(2), wt, qsec) |>
    validate_if(description = "Column drat has only positive values",
                drat > 0) |>
    validate_if(description = "Column drat has only values larger than 3",
                drat > 3) |> 
    add_results(report)

report

report |> save_report(
    output_file = "20220917_report_exampe.html",
    output_dir = "outros/"
    )

report <- NULL

# Example 2 ---------------------------------------------------------------
# Fonte: https://github.com/Appsilon/data.validator/tree/master/examples/minimal_example

# Data comes from tidy tuesday
beer_states <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-03-31/beer_states.csv')

# See data structure
beer_states |> dplyr::glimpse()

# Create report
report <- data.validator::data_validation_report()

# Validate pipeline
beer_states |> 
    data.validator::validate() |> 
    data.validator::validate_cols(
        # description = "No NA's inside barrels column", 
        description = "Nao pode haver 'NAs' na coluna 'barrels'", 
        assertr::not_na, # using function of assertr packcage to be more easy
        cols = barrels  # cols to do this validation
    ) |> 
    data.validator::validate_if(
        # description = "Check if year is in correct range (2008, 2018)", 
        description = "Checar se o ano está no intervalo correto (2008, 2018)",
        year >= 2008 && year <= 2018 # do the validation using the column name directly
        ) |> 
    # add to the report
    data.validator::add_results(report)

report

report |> data.validator::save_report(
    output_file = "20220917_report_exampe_2.html",
    output_dir = "outros/"
    # success = FALSE # don't show te success validations
    )



# Example 3 ---------------------------------------------------------------
# Fonte: https://github.com/Appsilon/data.validator/blob/master/examples/sample_validations/example.R


validator <- data.validator::data_validation_report()

mtcars |> 
    # iniciar pipeline de validação
    data.validator::validate() |>
    
    # checar se existe NAs dentro de algumas colunas
    data.validator::validate_cols(
        description = "No NA's inside mpg:carb columns",
        predicate = assertr::not_na,
        mpg:carb
    ) |>
    
    # checar se os valores são iguais a 0 ou 2 em duas colunas
    data.validator::validate_cols(
        description = "vs and am values equal 0 or 2 only", 
        predicate = assertr::in_set(c(0, 2)), 
        vs, 
        am
    ) |>
    
    # checar se os valores são iguais a 3 ou 4 em duas colunas
    data.validator::validate_cols(
        description = "vs and am values should equal 3 or 4",
        skip_chain_opts = TRUE,
        error_fun = assertr::warning_append, # warning (aviso apenas)
        predicate = assertr::in_set(c(3, 4)),
        gear,
        carb
    ) |>
    
    # checar se a soma das linhas de cada coluna detro de um range de colunas é 
    # menor ou igual a 2
    data.validator::validate_rows(
        description = "Each row sum for am:vs columns is less or equal 2",
        rowSums, 
        assertr::within_bounds(0, 2), 
        vs:am
    ) |>
    
    # checar se a soma das linhas de cada coluna detro de um range de colunas é 
    # menor ou igual a 1
    data.validator::validate_rows(
        description = "Each row sum for am:vs columns is less or equal 1",
        rowSums, 
        assertr::within_bounds(0, 1), 
        vs:am
    ) |>
    
    # checar uma coluna usando o desvio padrão dos dados
    data.validator::validate_cols(
        description = "For wt and qsec we have: abs(col) < 4 * sd(col)", 
        assertr::within_n_sds(4), 
        wt, 
        qsec
    ) |>
    
    # checar uma coluna usando o desvio padrão dos dados
    data.validator::validate_cols(
        description = "For wt and qsec we have: abs(col) < 2 * sd(col)", 
        assertr::within_n_sds(2), 
        wt, 
        qsec
    ) |>
    
    # validação estatística das linhas (distância da mediana)
    data.validator::validate_rows(
        description = "Using mpg:carb mahalanobis distance for each observation is within 30 median absolute deviations from the median",
        row_reduction_fn = assertr::maha_dist,
        assertr::within_n_mads(30),
        mpg:carb
    ) |>
    
    # validação estatística das linhas (distância da mediana)
    data.validator::validate_rows(
        description = "Using mpg:carb mahalanobis distance for each observation is within 3 median absolute deviations from the median",
        row_reduction_fn = assertr::maha_dist,
        assertr::within_n_mads(3),
        mpg:carb
    ) |>
    
    # checar se uma coluna possui apenas valores positivos
    data.validator::validate_if(
        description = "Column drat has only positive values", 
        drat > 0
    ) |>
    
    # checar se uma coluna possui apenas valores maiores que 3
    data.validator::validate_if(
        description = "Column drat has only values larger than 3", 
        drat > 3
    ) |>
    
    # adicionar resultados no objeto de validação
    data.validator::add_results(validator)

# exibir relatório no console
data.validator::get_results(validator)

# exportar relatório
validator |> data.validator::save_report(
    output_file = "20220918_validation_report_example_3.html",
    output_dir = "outros/"
)

# abrir relatório no navegador
browseURL("outros/20220918_validation_report_example_3.html")


# exportar relatório bruto
validator |> data.validator::save_report(
    output_file = "20220918_validation_report_example_3_raw.html",
    ui_constructor = data.validator::render_raw_report_ui,
    output_dir = "outros/"
    )

# abrir relatório no navegador
browseURL("outros/20220918_validation_report_example_3_raw.html")


# exportar relatório em csv
validator |> data.validator::save_results(
    file_name = "outros/20220918_results_example_3.csv"
    )

# exportar relatório em txt
validator |> data.validator::save_summary(
    file_name = "outros/20220918_validation_log_example_3.txt"
    )



# Example 4 ---------------------------------------------------------------
# Fonte: https://github.com/Appsilon/data.validator/blob/master/examples/shiny_app/shiny_example.R

ui <- shiny::fluidPage(
    shiny::uiOutput("validation")
)

server <- function(input, output, session) {
    report <- data.validator::data_validation_report()
    
    mtcars |> 
        data.validator::validate(name = "Verifying cars dataset") |>
        data.validator::validate_if(drat > 0, description = "Column drat has only positive values") |>
        data.validator::validate_cols(assertr::in_set(c(0, 2)), vs, am, description = "vs and am values equal 0 or 2 only") |>
        data.validator::validate_cols(assertr::within_n_sds(1), mpg, description = "mpg within 1 sds") |>
        data.validator::validate_rows(assertr::num_row_NAs, assertr::within_bounds(0, 2), vs, am, mpg, description = "not too many NAs in rows") |>
        data.validator::validate_rows(assertr::maha_dist, assertr::within_n_mads(10), dplyr::everything(), description = "maha dist within 10 mads") |>
        data.validator::add_results(report)
    
    output$validation <- shiny::renderUI({
        data.validator::render_semantic_report_ui(data.validator::get_results(report))
    })
}

shiny::shinyApp(ui, server)



























