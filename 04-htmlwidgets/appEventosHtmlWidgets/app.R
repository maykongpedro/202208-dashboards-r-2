# Launch the ShinyApp (Do not remove this comment)
# To deploy, run: rsconnect::deployApp()
# Or use the blue button on top of this file

pkgload::load_all(export_all = FALSE,helpers = FALSE,attach_testthat = FALSE)

# é opcional, usado para controlar o que vai ser enviado pra nuvem ou nao
# algo como: se essa opção estiver como TRUE, leva arquivo X ou não
options( "golem.app.prod" = TRUE)

# original:
# appEventosHtmlWidgets::run_app() # add parameters here (if any)
# alterado: (não há necessidade do nome do pacote)
run_app() # add parameters here (if any)
