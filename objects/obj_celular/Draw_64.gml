/// @description Desenha o celular (fundo escurecido, corpo do aparelho, apps)

if (estado == "fechado" && abertura < 0.01) exit;

var _l = calcular_layout();

draw_set_font(-1);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Fundo escurecido por trás do celular
draw_set_alpha(0.55 * abertura);
draw_set_color(c_black);
draw_rectangle(0, 0, _l.gw, _l.gh, false);

// Corpo do aparelho (nasce de um ponto no centro e cresce até o tamanho final)
var _esc = abertura;
var _cx1 = lerp(_l.cx, _l.corpo_x1, _esc);
var _cy1 = lerp(_l.cy, _l.corpo_y1, _esc);
var _cx2 = lerp(_l.cx, _l.corpo_x2, _esc);
var _cy2 = lerp(_l.cy, _l.corpo_y2, _esc);

draw_set_alpha(abertura);
draw_set_color(make_color_rgb(20, 14, 30));
draw_roundrect_ext(_cx1, _cy1, _cx2, _cy2, 28, 28, false);
draw_set_color(c_white);
draw_roundrect_ext(_cx1, _cy1, _cx2, _cy2, 28, 28, true);

// Tela
var _tx1 = lerp(_l.cx, _l.tela_x1, _esc);
var _ty1 = lerp(_l.cy, _l.tela_y1, _esc);
var _tx2 = lerp(_l.cx, _l.tela_x2, _esc);
var _ty2 = lerp(_l.cy, _l.tela_y2, _esc);

draw_set_color(make_color_rgb(30, 18, 48));
draw_rectangle(_tx1, _ty1, _tx2, _ty2, false);

if (abertura > 0.9) {
    // Botão de fechar/voltar
    var _rf = _l.fechar;
    draw_set_color(c_white);
    draw_set_alpha(1);
    draw_text((_rf.x1 + _rf.x2) / 2, (_rf.y1 + _rf.y2) / 2, "X");

    if (estado == "home") {
        draw_set_color(c_white);
        draw_text(_l.cx, _l.tela_y1 + 26, "Celular");

        for (var i = 0; i < array_length(apps); i++) {
            var _r = _l.app_rects[i];
            ui_desenhar_botao(_r.x1, _r.y1, _r.x2, _r.y2, apps[i], app_hover == i);
        }
    } else if (estado == "menu_app") {
        draw_set_color(c_white);
        draw_text(_l.cx, _l.tela_y1 + 26, "Menu");

        for (var i = 0; i < array_length(_l.menu_rects); i++) {
            var _r = _l.menu_rects[i];
            ui_desenhar_botao(_r.x1, _r.y1, _r.x2, _r.y2, menu_botoes[i], menu_hover == i);
        }

        if (mensagem_timer > 0) {
            draw_set_color(c_lime);
            draw_set_alpha(min(1, mensagem_timer / 20));
            draw_text(_l.cx, _l.tela_y2 - 30, mensagem_feedback);
        }
    } else if (estado == "placeholder") {
        draw_set_color(c_white);
        draw_set_alpha(1);
        draw_text(_l.cx, _l.tela_y1 + 26, placeholder_titulo);
        draw_set_alpha(0.7);
        draw_text(_l.cx, _l.cy, "Em breve");
    }
}

draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
