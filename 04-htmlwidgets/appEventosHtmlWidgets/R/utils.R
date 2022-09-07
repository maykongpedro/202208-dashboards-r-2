
# para capturar o código da função tooltip foi necessário digitar o nome da função
# no console sem os parentêses necessários para receber argumentos
nossa_e_tooltip <-
  function (e,
            trigger = c("item", "axis"),
            # retirar o formatter da função
            # formatter = NULL,
            ...)
  {
    if (missing(e)) {
      stop("must pass e", call. = FALSE)
    }
    tooltip <- list(trigger = trigger[1], ...)

    # retirar tudo que se usava de referencia o formatter, assim todo javascript
    # que for lançado como argumento adicional irá direto para a próxima etapa
    # if (!is.null(formatter)) {
    #   if (inherits(formatter, "item_formatter") || inherits(formatter,
    #                                                         "pie_formatter") ||
    #       inherits(formatter, "JS_EVAL")) {
    #     tooltip$formatter <- formatter
    #   }
    #   if (inherits(formatter, "pointer_formatter")) {
    #     tooltip$axisPointer$label <- formatter
    #   }
    # }

    if (!e$x$tl) {
      e$x$opts$tooltip <- tooltip
    }
    else {
      e$x$opts$baseOption$tooltip <- tooltip
    }
    e
  }
