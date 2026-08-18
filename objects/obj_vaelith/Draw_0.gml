/// @description Desenha a Vāelith, o nome dela e a barra de vida (só aparece depois que ela leva o primeiro dano)

draw_self();

// --- BALÃO DE FALA (introdução, antes da contagem regressiva) ---
if(em_introducao && fase_introducao == "fala") {
    var largura_balao = 240;
    var altura_balao = 64;
    var bx = x;
    var by = y - sprite_height/2 * escala_personagem - 76;

    draw_set_color(c_white);
    draw_roundrect_ext(bx - largura_balao/2, by - altura_balao/2, bx + largura_balao/2, by + altura_balao/2, 16, 16, false);
    draw_set_color(c_black);
    draw_roundrect_ext(bx - largura_balao/2, by - altura_balao/2, bx + largura_balao/2, by + altura_balao/2, 16, 16, true);

    // "Rabinho" do balão apontando pra ela
    draw_set_color(c_white);
    draw_triangle(bx - 10, by + altura_balao/2 - 1, bx + 10, by + altura_balao/2 - 1, bx, by + altura_balao/2 + 16, false);
    draw_set_color(c_black);
    draw_line(bx - 10, by + altura_balao/2, bx, by + altura_balao/2 + 16);
    draw_line(bx + 10, by + altura_balao/2, bx, by + altura_balao/2 + 16);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_black);
    draw_text_ext(bx, by, texto_fala, 16, largura_balao - 24);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

// Aviso visual do Especial carregando (telegraph), pra dar tempo do jogador reagir
if(especial_em_preparo) {
    draw_set_halign(fa_center);
    draw_set_color(c_red);
    draw_text(x, y - sprite_height/2 * escala_personagem - 34, "!");
    draw_set_halign(fa_left);
}

var jogador_perto = instance_exists(obj_player_1) && point_distance(x, y, obj_player_1.x, obj_player_1.y) <= alcance_barra_vida;

// Barrinha flutuante só antes da luta "oficial" começar (ela ainda não apresentou a barra de chefe no topo)
if((vida < vida_maxima || jogador_perto) && !introducao_feita) {
    var largura_barra = 70;
    var altura_barra = 7;
    var pos_x_barra = x - largura_barra/2;
    var pos_y_barra = y - sprite_height/2 * escala_personagem - 26;

    var vida_percent = vida / vida_maxima;

    draw_set_halign(fa_center);
    draw_set_color(c_maroon);
    draw_text(x, pos_y_barra - 14, nome);
    draw_set_halign(fa_left);

    // Fundo da barra
    draw_set_color(c_black);
    draw_rectangle(pos_x_barra, pos_y_barra, pos_x_barra + largura_barra, pos_y_barra + altura_barra, false);

    // Barra de vida
    draw_set_color(c_red);
    draw_rectangle(pos_x_barra, pos_y_barra, pos_x_barra + (largura_barra * vida_percent), pos_y_barra + altura_barra, false);

    // Contorno
    draw_set_color(c_white);
    draw_rectangle(pos_x_barra, pos_y_barra, pos_x_barra + largura_barra, pos_y_barra + altura_barra, true);
}
