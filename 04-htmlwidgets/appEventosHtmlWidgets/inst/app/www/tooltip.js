
// Obter o elemento html referente ao filtro de ano
var target_ano = document.getElementById("filtro_ano");
var target_regiao = document.getElementById("filtro_regiao");
var target_estado = document.getElementById("filtro_estado");
var target_muni = document.getElementById("filtro_muni");

// Buscar id do input inspecionando o botão na página web
tippy('#tippy_1-pesquisar', {
        content: 'Clique aqui!',

        // Passar um elemento que ative a tooltip
        // fonte: https://atomiks.github.io/tippyjs/v6/all-props/#triggertarget
        triggerTarget: [target_ano, target_regiao, target_estado, target_muni],

        // Trocar para que a tooltip apareça somente quando o input é clicado
        // fonte: https://atomiks.github.io/tippyjs/v6/all-props/#triggertarget
        trigger: "click",

        // Impede a tooltip de desaparecer após o click
        // fonte: https://atomiks.github.io/tippyjs/v6/all-props/#hideonclick
        hideOnClick: false,

        // Exibe a tooltip no lado direito, o padrão é exibir em cima
        // fonte: https://atomiks.github.io/tippyjs/v6/all-props/#placement
        placement: "right"
  });


// Capturar o botão de pesquisar em uma variável para poder controlar os eventos
var botao = document.getElementById("tippy_1-pesquisar");

// Captura o evento 'onclick' do botão pesquisar
botao.onclick = function() {
  // fonte: https://atomiks.github.io/tippyjs/v6/methods/#hideall
  tippy.hideAll();
}
