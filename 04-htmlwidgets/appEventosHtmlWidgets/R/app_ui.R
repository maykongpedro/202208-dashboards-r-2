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
    bs4Dash::bs4DashPage(
      bs4Dash::bs4DashNavbar(title = "HTMLWIDGETS"),
      bs4Dash::bs4DashSidebar(
        bs4Dash::bs4SidebarMenu(
          bs4Dash::bs4SidebarMenuItem(
            text = "Reactable",
            tabName = "reactable",
            icon = icon("table")
          ),
          bs4Dash::bs4SidebarMenuItem(
            text = "Leaflet",
            tabName = "leaflet",
            icon = icon("map")
          ),
          bs4Dash::bs4SidebarMenuItem(
            text = "Plotly",
            tabName = "plotly",
            icon = icon("line-chart")
          ),
          bs4Dash::bs4SidebarMenuItem(
            text = "Echarts",
            tabName = "echarts",
            icon = icon("bar-chart")
          ),
          bs4Dash::bs4SidebarMenuItem(
            text = "Tippy",
            tabName = "tippy",
            icon = icon("help")
          ),
          bs4Dash::bs4SidebarMenuItem(
            text = "Reactable com SQL",
            tabName = "reactable_sql",
            icon = icon("table")
          )
        )
      ),
      bs4Dash::bs4DashBody(
        bs4Dash::bs4TabItems(
          bs4Dash::bs4TabItem(
            tabName = "reactable",
            # adicionar módulo reactable_ui
            mod_reactable_ui("reactable_1")
          ),
          bs4Dash::bs4TabItem(
            # adicionar módulo leaflet__ui
            tabName = "leaflet",
            mod_leaflet_ui("leaflet_1")
          ),
          bs4Dash::bs4TabItem(
            tabName = "plotly",
            # adicionar módulo plotly_ui
            mod_plotly_ui("plotly_ui_1")
          ),
          bs4Dash::bs4TabItem(
            tabName = "echarts",
            # adicionar módulo echarts_ui
            mod_echarts_ui("echarts_1")
          ),
          bs4Dash::bs4TabItem(
            tabName = "tippy",
            # adicionar módulo tippy_ui
            mod_tippy_ui("tippy_1")
          ),
          bs4Dash::bs4TabItem(
            tabName = "reactable_sql",
            # adicionar módulo reactable_db_ui
            mod_reactable_db_ui("reactable_db_1")
          )
        ),
        # adicionar scripts necessários para poder usar a biblioteca javascript
        # de tooltip customizável
        # fonte: https://atomiks.github.io/tippyjs/v6/getting-started/
        tags$script(
          src = "https://unpkg.com/@popperjs/core@2"
        ),
        tags$script(
          src = "https://unpkg.com/tippy.js@6"
        ),
        # adicionar script customizável JS que possui uma tooltip alterada
        tags$script(
          src = "www/tooltip.js"
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
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(),
    # Necessário desativas essa parte para o script customizado JS não ser carregado
    # automaticamente ao iniciar o app, pois se não seria carregador no header,
    # porém a biblioteca javascript da tooltip diz que a importação delas deve
    # ocorrer antes
    # bundle_resources(
    #   path = app_sys("app/www"),
    #   app_title = "appEventosHtmlWidgets"
    # )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
