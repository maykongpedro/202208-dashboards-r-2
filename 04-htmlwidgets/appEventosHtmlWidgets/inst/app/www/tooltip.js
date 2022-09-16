
// Obter o elemento html referente ao filtro de ano
var target_ano = document.getElementById("filtro_ano")

// Buscar id do input inspecionando o botão na página web
tippy('#tippy_1-pesquisar', {
        content: 'Clique aqui',

        // Passar um elemento que ative a tooltip
        // fonte: https://atomiks.github.io/tippyjs/v6/all-props/#triggertarget
        triggerTarget: target_ano,

        // Trocar para que a tooltip apareça somente quando o input é clicado
        // fonte: https://atomiks.github.io/tippyjs/v6/all-props/#triggertarget
        trigger: "click"

      });
