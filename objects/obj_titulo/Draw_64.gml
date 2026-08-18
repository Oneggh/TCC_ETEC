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

// ================= ESTRELAS (fundo, dá profundidade ao céu) =================
draw_set_color(c_white);
for (var i = 0; i < array_length(estrelas); i++) {
    var _e = estrelas[i];
    var _tw = 0.25 + 0.75 * (0.5 + 0.5 * sin(current_time * 0.001 * _e.vel + _e.fase));
    draw_set_alpha(_tw * 0.8);
    draw_circle(_e.x, _e.y, _e.tam, false);
}
draw_set_alpha(1);

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

// ================= CRISTAL (pixel art gerada, spr_titulo_cristal) =================
// Posição com leve deslocamento em direção ao cursor (cristal_tilt), como se fosse uma gema de verdade
var _cx = _l.cristal_x + cristal_tilt_x;
var _cy = _l.cristal_y + cristal_bob_y + cristal_tilt_y;
var _r = cristal_raio * cristal_escala;
var _glow = 0.5 + 0.5 * sin(current_time * 0.0025);

if (_r > 1) {
    // Camadas de brilho atrás do cristal (glow), reforçadas quando o mouse passa por cima
    draw_set_color(c_aqua);
    draw_set_alpha(0.10 + _glow * 0.08 + cristal_hover_glow * 0.14);
    draw_circle(_cx, _cy, _r * 2.4, false);
    draw_set_alpha(0.14 + _glow * 0.10 + cristal_hover_glow * 0.16);
    draw_circle(_cx, _cy, _r * 1.7, false);
    draw_set_alpha(1);

    // Sprite do cristal (128px de largura nativa, metade = 64 -> escala 1 cobre o raio base)
    var _escala_sprite = (_r / 64) * (1 + cristal_hover_glow * 0.08);
    draw_sprite_ext(spr_titulo_cristal, 0, _cx, _cy, _escala_sprite, _escala_sprite, cristal_rotacao, c_white, 1);
}

// Anéis de energia que expandem e somem quando o cristal é clicado
for (var i = 0; i < array_length(cliques_efeito); i++) {
    var _ce = cliques_efeito[i];
    var _t2 = _ce.vida / _ce.vida_max;
    draw_set_color(c_white);
    draw_set_alpha((1 - _t2) * 0.7);
    draw_circle(_ce.x, _ce.y, lerp(_r, _r * 4, _t2), true);
}
draw_set_alpha(1);

// Dica de clique (só no estado "cristal"), fica mais viva quando o mouse passa por cima
if (estado == "cristal") {
    draw_set_color(cristal_hover_glow > 0.4 ? c_yellow : c_white);
    draw_set_alpha((0.55 + 0.25 * sin(current_time * 0.004)) + cristal_hover_glow * 0.3);
    draw_text_transformed(_cx, _cy + _r + 40, "Clique no cristal", 1.2 + cristal_hover_glow * 0.15, 1.2 + cristal_hover_glow * 0.15, 0);
    draw_set_alpha(1);
}

// ================= TÍTULO DO JOGO =================
draw_set_alpha(1);
var _titulo_y = _l.gh * 0.10;
var _titulo_glow = 0.5 + 0.5 * sin(current_time * 0.002);

// Glow atrás do texto, cor combinando com o cristal
draw_set_color(make_color_rgb(138, 92, 255));
draw_set_alpha(0.25 + _titulo_glow * 0.12);
draw_text_transformed(_l.cx, _titulo_y, "CRYSTAL BORN", 2.5, 2.5, 0);
draw_set_alpha(1);

// Contorno preto, dá peso e legibilidade sobre o fundo
draw_set_color(c_black);
draw_text_transformed(_l.cx - 2, _titulo_y, "CRYSTAL BORN", 2.3, 2.3, 0);
draw_text_transformed(_l.cx + 2, _titulo_y, "CRYSTAL BORN", 2.3, 2.3, 0);
draw_text_transformed(_l.cx, _titulo_y - 2, "CRYSTAL BORN", 2.3, 2.3, 0);
draw_text_transformed(_l.cx, _titulo_y + 2, "CRYSTAL BORN", 2.3, 2.3, 0);

// Corpo do texto
draw_set_color(c_white);
draw_text_transformed(_l.cx, _titulo_y, "CRYSTAL BORN", 2.3, 2.3, 0);

// Subtítulo discreto
draw_set_color(make_color_rgb(190, 198, 255));
draw_set_alpha(0.8);
draw_text_transformed(_l.cx, _titulo_y + 42, "um RPG de cristal e sombra", 1, 1, 0);
draw_set_alpha(1);

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
