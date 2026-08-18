/// @description UI de chefe: contagem regressiva de início de luta + barra de vida da Vāelith fixa no topo da tela

var gw = display_get_gui_width();
var gh = display_get_gui_height();

draw_set_font(-1);

// ==================== CONTAGEM REGRESSIVA (10 -> 1) ====================
if(em_introducao && fase_introducao == "contagem") {
    draw_set_alpha(0.45);
    draw_set_color(c_black);
    draw_rectangle(0, 0, gw, gh, false);
    draw_set_alpha(1);

    var cx = gw / 2;
    var cy = gh / 2;

    // Progresso do intervalo atual (0 = acabou de trocar de número, 1 = prestes a trocar)
    var _prog = 1 - (timer_contagem / contagem_intervalo);
    var _escala_num = 1.7 - _prog * 0.55; // nasce grande e encolhe até o próximo número
    var _cor_num = (contagem_valor <= 3) ? c_red : c_yellow; // últimos números ficam mais urgentes

    // Anéis pulsando atrás do número, dão a sensação de "tique" a cada troca
    draw_set_alpha(0.5 * (1 - _prog));
    draw_set_color(_cor_num);
    draw_circle(cx, cy, 60 + _prog * 60, true);
    draw_set_alpha(1);

    draw_set_color(c_black);
    draw_circle(cx, cy, 82, false);
    draw_set_color(_cor_num);
    draw_circle(cx, cy, 82, true);
    draw_circle(cx, cy, 78, true);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    // Título, com contorno preto
    var _titulo = "A luta começa em...";
    draw_set_color(c_black);
    draw_text_transformed(cx - 2, cy - 108, _titulo, 1.2, 1.2, 0);
    draw_text_transformed(cx + 2, cy - 108, _titulo, 1.2, 1.2, 0);
    draw_text_transformed(cx, cy - 110, _titulo, 1.2, 1.2, 0);
    draw_text_transformed(cx, cy - 106, _titulo, 1.2, 1.2, 0);
    draw_set_color(c_white);
    draw_text_transformed(cx, cy - 108, _titulo, 1.2, 1.2, 0);

    // Número grande, pulsando, com contorno preto grosso
    var _num = string(contagem_valor);
    draw_set_color(c_black);
    draw_text_transformed(cx - 3, cy, _num, _escala_num, _escala_num, 0);
    draw_text_transformed(cx + 3, cy, _num, _escala_num, _escala_num, 0);
    draw_text_transformed(cx, cy - 3, _num, _escala_num, _escala_num, 0);
    draw_text_transformed(cx, cy + 3, _num, _escala_num, _escala_num, 0);
    draw_set_color(_cor_num);
    draw_text_transformed(cx, cy, _num, _escala_num, _escala_num, 0);

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

// ==================== BARRA DE VIDA DE CHEFE (fixa no topo da tela) ====================
if(introducao_feita && vida > 0) {
    var _bw = min(gw * 0.6, 560);
    var _bh = 24;
    var _bx = gw / 2 - _bw / 2;
    var _by = 28;

    var _pct = vida / vida_maxima;
    var _pct_trail = vida_trail / vida_maxima;

    // Moldura externa
    draw_set_color(c_black);
    draw_rectangle(_bx - 5, _by - 5, _bx + _bw + 5, _by + _bh + 5, false);
    draw_set_color(make_colour_rgb(120, 25, 25));
    draw_rectangle(_bx - 5, _by - 5, _bx + _bw + 5, _by + _bh + 5, true);

    // Fundo vazio
    draw_set_color(make_colour_rgb(22, 6, 6));
    draw_rectangle(_bx, _by, _bx + _bw, _by + _bh, false);

    // Rastro de dano (amarelo) — mostra o quanto ela acabou de perder, encolhe devagar
    if(_pct_trail > _pct) {
        draw_set_color(c_yellow);
        draw_rectangle(_bx, _by, _bx + _bw * _pct_trail, _by + _bh, false);
    }

    // Vida atual (vermelho)
    draw_set_color(c_red);
    draw_rectangle(_bx, _by, _bx + _bw * _pct, _by + _bh, false);

    // Brilho sutil na metade de cima, pra dar volume à barra
    draw_set_alpha(0.18);
    draw_set_color(c_white);
    draw_rectangle(_bx, _by, _bx + _bw * _pct, _by + _bh / 2, false);
    draw_set_alpha(1);

    // Segmentos verticais (divide a barra em blocos, visual clássico de boss bar)
    draw_set_color(c_black);
    var _segmentos = 10;
    for(var i = 1; i < _segmentos; i++) {
        var _sx = _bx + (_bw / _segmentos) * i;
        draw_line(_sx, _by, _sx, _by + _bh);
    }

    // Contorno
    draw_set_color(c_white);
    draw_rectangle(_bx, _by, _bx + _bw, _by + _bh, true);

    // Nome dela acima da barra, com contorno
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    var _ny = _by - 6;
    draw_set_color(c_black);
    draw_text(gw / 2 - 1, _ny, nome);
    draw_text(gw / 2 + 1, _ny, nome);
    draw_text(gw / 2, _ny - 1, nome);
    draw_text(gw / 2, _ny + 1, nome);
    draw_set_color(c_white);
    draw_text(gw / 2, _ny, nome);

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
