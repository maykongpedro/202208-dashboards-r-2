#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic

   # fazer conexão com o banco de dados
   conexao <- RSQLite::dbConnect(RSQLite::SQLite(), "pnud_min.sqlite")

   # obter todos os dados e adicionálos em um objeto
   # essa não é uma boa prática pois acaba carrengando a base toda
   # tbl_pnud <- dplyr::tbl(conexao, "pnud") |> dplyr::collect()

   # apenas fazer conexão sem trazer todos os dados
   tbl_pnud <- dplyr::tbl(conexao, "pnud")

  mod_reactable_db_server("reactable_db_1", tbl_pnud)
  mod_reactable_server("reactable_1")
  mod_leaflet_server("leaflet_1")
  mod_plotly_server("plotly_ui_1")
  mod_echarts_server("echarts_1")
  mod_tippy_server("tippy_1")

}
