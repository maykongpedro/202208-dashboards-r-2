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
    shiny.semantic::semanticPage(
      h2("Exemplo de Accordions"),

      # mod_additional_css_itens_ui("additional_css_itens_1"),

      br(),

      # selectInput(
      #   inputId = "period",
      #   label = "Selecione o período:",
      #   choices = c(
      #     "Ano" = "year",
      #     "Mês" = "month",
      #     "Semana" = "week"
      #   )
      # ),
      # textOutput(outputId = "test_input"),

      div(
        # classe para controlar a posição dos itens, é como uma shiny::column()
        class = "ui stackable grid",

        div(
          class = "four wide computer eight wide tablet sixteen wide mobile column",
          # style = "min-width: 350px;",
          mod_accordion_ui("accordion_year", period = "year")
        ),

        div(
          class = "four wide computer eight wide tablet sixteen wide mobile column",
          mod_accordion_ui("accordion_month", period = "month")
        ),

        div(
          class = "four wide computer eight wide tablet sixteen wide mobile column",
          mod_accordion_ui("accordion_week", period = "week")
        ),

        div(
          class = "two column row",
          div(
            class = "four wide column",
            h3("Total por categoria"),
            div(
              class = "ui raised segment",
              style = "min-width: 550px;",
              tableOutput(outputId = "test_table")
            )
          )
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
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "accordionExample"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
