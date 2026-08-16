/// @description Desenha a Vāelith, o nome dela e a barra de vida (só aparece depois que ela leva o primeiro dano)

draw_self();

// Aviso visual do Especial carregando (telegraph), pra dar tempo do jogador reagir
if(especial_em_preparo) {
    draw_set_halign(fa_center);
    draw_set_color(c_red);
    draw_text(x, y - sprite_height/2 * escala_personagem - 34, "!");
    draw_set_halign(fa_left);
}

var jogador_perto = instance_exists(obj_player_1) && point_distance(x, y, obj_player_1.x, obj_player_1.y) <= alcance_barra_vida;

if(vida < vida_maxima || jogador_perto) {
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
