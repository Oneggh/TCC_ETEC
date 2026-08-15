/// @description Controlador da tela de título (cristal + menu)

estado = "cristal"; // "cristal" | "menu" | "saves" | "opcoes"

// --- Cristal ---
cristal_raio = 68;
cristal_escala = 0;      // nasce crescendo
cristal_escala_alvo = 1;
cristal_bob_y = 0;

// --- Partículas manuais (espaço de GUI) ---
particulas = [];
particula_timer = 0;

// --- Fade de entrada / transição de sala ---
fade_alpha = 1;
fade_modo = "entrando"; // "entrando" | "nenhum" | "saindo"
fade_destino = noone;
fade_timer = 0;
fade_duracao = 30;

// --- Menu principal ---
menu_botoes = ["Iniciar", "Saves", "Opcoes", "Sair"];
menu_hover = -1;
menu_abertura = 0;

// --- Tela de Saves ---
saves_hover = -1;
saves_voltar_hover = false;

// --- Tela de Opções ---
opcoes_voltar_hover = false;
opcoes_fullscreen_hover = false;
opcoes_slider_arrastando = -1; // -1 nenhum, 0 = música, 1 = sfx

// --- Carrega opções salvas em disco (cria padrões se não existir) ---
scr_options_load();
window_set_fullscreen(global.opt_fullscreen);

// ================= LAYOUT COMPARTILHADO (Step e Draw usam a mesma função) =================
calcular_layout = function() {
    var _gw = display_get_gui_width();
    var _gh = display_get_gui_height();
    var _cx = _gw / 2;

    var _l = {
        gw: _gw,
        gh: _gh,
        cx: _cx,
        cristal_x: _cx,
        cristal_y: _gh * 0.32,
        painel_y0: _gh * 0.52,
    };

    // Botões do menu principal
    _l.menu_btn_w = 260;
    _l.menu_btn_h = 52;
    _l.menu_gap = 16;
    _l.menu_rects = [];
    for (var i = 0; i < array_length(menu_botoes); i++) {
        var _y1 = _l.painel_y0 + i * (_l.menu_btn_h + _l.menu_gap);
        array_push(_l.menu_rects, {
            x1: _cx - _l.menu_btn_w / 2, y1: _y1,
            x2: _cx + _l.menu_btn_w / 2, y2: _y1 + _l.menu_btn_h,
        });
    }

    // Slots de save
    _l.slot_w = 320;
    _l.slot_h = 64;
    _l.slot_gap = 14;
    _l.slot_rects = [];
    for (var i = 0; i < 3; i++) {
        var _y1s = _l.painel_y0 + i * (_l.slot_h + _l.slot_gap);
        array_push(_l.slot_rects, {
            x1: _cx - _l.slot_w / 2, y1: _y1s,
            x2: _cx + _l.slot_w / 2, y2: _y1s + _l.slot_h,
        });
    }
    var _saves_voltar_y = _l.painel_y0 + 3 * (_l.slot_h + _l.slot_gap) + 10;
    _l.saves_voltar = {
        x1: _cx - 80, y1: _saves_voltar_y,
        x2: _cx + 80, y2: _saves_voltar_y + 44,
    };

    // Opções
    _l.slider_w = 260;
    _l.slider_x1 = _cx - _l.slider_w / 2;
    _l.slider_x2 = _cx + _l.slider_w / 2;
    _l.slider_musica_y = _l.painel_y0 + 30;
    _l.slider_sfx_y = _l.painel_y0 + 110;
    _l.checkbox = { x1: _cx - 104, y1: _l.painel_y0 + 160, x2: _cx - 76, y2: _l.painel_y0 + 188 };

    var _opcoes_voltar_y = _l.painel_y0 + 220;
    _l.opcoes_voltar = {
        x1: _cx - 80, y1: _opcoes_voltar_y,
        x2: _cx + 80, y2: _opcoes_voltar_y + 44,
    };

    return _l;
};
