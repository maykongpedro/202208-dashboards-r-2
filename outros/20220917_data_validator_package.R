

# Example 1 ---------------------------------------------------------------
# Fonte: https://appsilon.github.io/data.validator/articles/data_validator.html

library(assertr)
library(dplyr)
library(data.validator)

report <- data_validation_report()

validate(mtcars) %>%
    validate_cols(description = "vs and am values equal 0 or 2 only",
                  in_set(c(0, 2)), vs, am) %>%
    validate_cols(description = "vs and am values should equal 3 or 4",
                  skip_chain_opts = TRUE,
                  error_fun = warning_append, in_set(c(3, 4)), gear, carb) %>%
    validate_rows(description = "Each row sum for am:vs columns is less or equal 1",
                  rowSums, within_bounds(0, 1), vs:am) %>%
    validate_cols(description = "For wt and qsec we have: abs(col) < 2 * sd(col)",
                  within_n_sds(2), wt, qsec) %>%
    validate_if(description = "Column drat has only positive values",
                drat > 0) %>%
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










