/// @description Desenha a tela de título (fundo, cristal, partículas, menus e fade)

var _l = calcular_layout();

draw_set_font(-1);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// ================= FUNDO EM GRADIENTE =================
draw_set_alpha(1);
draw_rectangle_color(
    0, 0, _l.gw, _l.gh,
    make_color_rgb(26, 15, 46), make_color_rgb(26, 15, 46),
    make_color_rgb(5, 3, 10), make_color_rgb(5, 3, 10),
    false
);

// Escurecida gradual na parte de baixo, pra dar contraste ao painel de menu
draw_primitive_begin(pr_trianglelist);
var _vy_top = _l.gh * 0.42;
var _vy_bot = _l.gh;
draw_vertex_color(0, _vy_top, c_black, 0);
draw_vertex_color(_l.gw, _vy_top, c_black, 0);
draw_vertex_color(_l.gw, _vy_bot, c_black, 0.55);
draw_vertex_color(0, _vy_top, c_black, 0);
draw_vertex_color(_l.gw, _vy_bot, c_black, 0.55);
draw_vertex_color(0, _vy_bot, c_black, 0.55);
draw_primitive_end();

// ================= PARTÍCULAS (atrás do cristal) =================
for (var i = 0; i < array_length(particulas); i++) {
    var _p = particulas[i];
    var _t = _p.vida / _p.vida_max;
    draw_set_alpha((1 - _t) * 0.8);
    draw_set_color(c_aqua);
    draw_circle(_p.x, _p.y, _p.tam, false);
}
draw_set_alpha(1);

// ================= CRISTAL =================
var _cx = _l.cristal_x;
var _cy = _l.cristal_y + cristal_bob_y;
var _r = cristal_raio * cristal_escala;
var _glow = 0.5 + 0.5 * sin(current_time * 0.0025);

if (_r > 1) {
    // Camadas de brilho (glow)
    draw_set_color(c_aqua);
    draw_set_alpha(0.10 + _glow * 0.08);
    draw_circle(_cx, _cy, _r * 2.4, false);
    draw_set_alpha(0.14 + _glow * 0.10);
    draw_circle(_cx, _cy, _r * 1.7, false);
    draw_set_alpha(1);

    // Corpo facetado do cristal (hexágono alongado, 6 triângulos a partir do centro)
    var _pontos = [
        [0, -_r * 1.35],
        [_r * 0.62, -_r * 0.35],
        [_r * 0.42, _r * 0.9],
        [0, _r * 1.35],
        [-_r * 0.42, _r * 0.9],
        [-_r * 0.62, -_r * 0.35],
    ];
    var _cores = [
        make_color_rgb(255, 230, 176),
        make_color_rgb(255, 179, 236),
        make_color_rgb(201, 139, 255),
        make_color_rgb(138, 92, 255),
        make_color_rgb(95, 127, 255),
        make_color_rgb(127, 214, 255),
    ];

    draw_primitive_begin(pr_trianglelist);
    for (var i = 0; i < 6; i++) {
        var _p1 = _pontos[i];
        var _p2 = _pontos[(i + 1) mod 6];

        draw_vertex_color(_cx, _cy, c_white, 1);
        draw_vertex_color(_cx + _p1[0], _cy + _p1[1], _cores[i], 1);
        draw_vertex_color(_cx + _p2[0], _cy + _p2[1], _cores[(i + 1) mod 6], 1);
    }
    draw_primitive_end();

    // Brilho pulsante no centro
    draw_set_color(c_white);
    draw_set_alpha(0.5 + _glow * 0.4);
    draw_circle(_cx, _cy, _r * 0.25, false);
    draw_set_alpha(1);
}

// Dica de clique (só no estado "cristal")
if (estado == "cristal") {
    draw_set_color(c_white);
    draw_set_alpha(0.55 + 0.25 * sin(current_time * 0.004));
    draw_text_transformed(_cx, _cy + _r + 40, "Clique no cristal", 1.2, 1.2, 0);
    draw_set_alpha(1);
}

// ================= TÍTULO DO JOGO =================
draw_set_alpha(1);
draw_set_color(c_white);
draw_text_transformed(_l.cx, _l.gh * 0.10, "RPG", 3, 3, 0);

// ================= PAINÉIS =================
if (estado == "menu") {
    draw_set_alpha(menu_abertura);
    for (var i = 0; i < array_length(_l.menu_rects); i++) {
        var _rm = _l.menu_rects[i];
        ui_desenhar_botao(_rm.x1, _rm.y1, _rm.x2, _rm.y2, menu_botoes[i], menu_hover == i);
    }
    draw_set_alpha(1);
} else if (estado == "saves") {
    for (var i = 0; i < 3; i++) {
        var _rs = _l.slot_rects[i];
        var _slot = i + 1;
        var _label = "Slot " + string(_slot) + ": Vazio";

        if (scr_save_exists(_slot)) {
            var _info = scr_save_read(_slot);
            _label = "Slot " + string(_slot) + " - " + _info.sala + " (" + _info.data + ")";
        }

        ui_desenhar_botao(_rs.x1, _rs.y1, _rs.x2, _rs.y2, _label, saves_hover == i);
    }

    var _rv = _l.saves_voltar;
    ui_desenhar_botao(_rv.x1, _rv.y1, _rv.x2, _rv.y2, "Voltar", saves_voltar_hover);
} else if (estado == "opcoes") {
    ui_desenhar_slider(_l.slider_x1, _l.slider_x2, _l.slider_musica_y, global.opt_musica, "Musica");
    ui_desenhar_slider(_l.slider_x1, _l.slider_x2, _l.slider_sfx_y, global.opt_sfx, "Efeitos");

    var _cb = _l.checkbox;
    draw_set_alpha(1);
    draw_set_color(opcoes_fullscreen_hover ? c_yellow : c_white);
    draw_rectangle(_cb.x1, _cb.y1, _cb.x2, _cb.y2, true);
    if (global.opt_fullscreen) {
        draw_line_width(_cb.x1, _cb.y1, _cb.x2, _cb.y2, 2);
        draw_line_width(_cb.x1, _cb.y2, _cb.x2, _cb.y1, 2);
    }
    draw_set_halign(fa_left);
    draw_text(_cb.x2 + 12, (_cb.y1 + _cb.y2) / 2, "Tela cheia");
    draw_set_halign(fa_center);

    var _rv2 = _l.opcoes_voltar;
    ui_desenhar_botao(_rv2.x1, _rv2.y1, _rv2.x2, _rv2.y2, "Voltar", opcoes_voltar_hover);
}

// ================= FADE DE ENTRADA/SAÍDA =================
if (fade_alpha > 0) {
    draw_set_alpha(fade_alpha);
    draw_set_color(c_black);
    draw_rectangle(0, 0, _l.gw, _l.gh, false);
    draw_set_alpha(1);
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
