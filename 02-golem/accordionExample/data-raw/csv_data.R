## code to prepare `csv_data` dataset goes here

household_estimates <- readr::read_csv("https://raw.githubusercontent.com/taylorrodgers/public_datasets/main/household_carbon_estimates.csv")
total_estimates <- readr::read_csv("https://raw.githubusercontent.com/taylorrodgers/public_datasets/main/total_household_estimates.csv")


usethis::use_data(household_estimates, overwrite = TRUE)
usethis::use_data(total_estimates, overwrite = TRUE)
