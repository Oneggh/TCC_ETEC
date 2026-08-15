/// @description Helpers de desenho de UI reaproveitados pela tela de título e pelo celular

function ui_desenhar_botao(_x1, _y1, _x2, _y2, _texto, _hover) {
    var _cor_fundo = _hover ? make_color_rgb(90, 60, 140) : make_color_rgb(40, 24, 64);
    var _cor_borda = _hover ? c_yellow : c_white;

    draw_set_alpha(0.85);
    draw_set_color(_cor_fundo);
    draw_roundrect_ext(_x1, _y1, _x2, _y2, 16, 16, false);

    draw_set_alpha(1);
    draw_set_color(_cor_borda);
    draw_roundrect_ext(_x1, _y1, _x2, _y2, 16, 16, true);

    draw_set_color(c_black);
    draw_text((_x1 + _x2) / 2 + 1, (_y1 + _y2) / 2 + 1, _texto);
    draw_set_color(_hover ? c_yellow : c_white);
    draw_text((_x1 + _x2) / 2, (_y1 + _y2) / 2, _texto);
}

function ui_desenhar_slider(_x1, _x2, _y, _valor, _rotulo) {
    draw_set_color(c_white);
    draw_set_alpha(1);
    draw_set_halign(fa_left);
    draw_text(_x1, _y - 26, _rotulo + ": " + string(round(_valor * 100)) + "%");
    draw_set_halign(fa_center);

    draw_set_color(make_color_rgb(60, 40, 90));
    draw_line_width(_x1, _y, _x2, _y, 6);

    var _hx = lerp(_x1, _x2, _valor);
    draw_set_color(c_aqua);
    draw_line_width(_x1, _y, _hx, _y, 6);

    draw_set_color(c_white);
    draw_circle(_hx, _y, 9, false);
}
