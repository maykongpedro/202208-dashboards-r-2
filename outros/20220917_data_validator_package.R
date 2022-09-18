
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



