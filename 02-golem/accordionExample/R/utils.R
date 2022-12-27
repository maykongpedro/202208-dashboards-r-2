
CalcularTotais <- function(categoria, periodo) {

    total_estimates |>
        # seleciona a coluna 'total_type' e todas as colunas que possuem
        # o texto do argumento 'periodo' no nome
        dplyr::select(total_type, dplyr::contains(periodo)) |>
        # renomeia a coluna 2
        dplyr::rename(emissions = 2) |>
        # filtra apenas o tipo alocado no argumento 'categoria'
        dplyr::filter(total_type == categoria) |>
        # resume a coluna emissões
        dplyr::transmute(
            emissoes = round(emissions, 2)
        ) |>
        # exporta como texto
        paste0(
            dplyr::case_when(
                periodo == "year" ~ " /ano",
                periodo == "month" ~ " /mês",
                TRUE ~ " /semana"
            )
        )

}



CalcularSubTotais <- function(categoria, periodo) {

    household_estimates |>
        dplyr::select(categories, subcategories, contains(periodo)) |>
        dplyr::rename(emissions = 3) |>
        dplyr::filter(categories == categoria) |>
        dplyr::arrange(subcategories) |>
        dplyr::group_by(subcategories) |>
        dplyr::summarise(
            emissions = sum(
                round(emissions, 2)
            )
        ) |>
        dplyr::rename(
            Subcategorias = subcategories,
            `Emissões` = emissions
        )

}

