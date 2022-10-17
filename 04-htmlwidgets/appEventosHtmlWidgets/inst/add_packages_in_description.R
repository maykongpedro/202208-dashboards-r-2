
# pacotes necessários para adicionar na lista de dependências
pacotes <- c( "bs4Dash" , "dplyr" , "echarts4r" , "ggplot2" , "glue" , "htmlwidgets",
             "leaflet" , "plotly" , "reactable" , "sf" , "tibble" , "tidyr" , "viridis")

# adicionar no arquivo DESCRIPTION
purrr::walk(pacotes, usethis::use_package)
