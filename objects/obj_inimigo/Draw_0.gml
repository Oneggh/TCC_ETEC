/// @description Desenha o inimigo

// Desenha o inimigo
draw_self();

// Barra de vida (só aparece se o inimigo já levou dano)
if(vida < vida_maxima) {
    var largura_barra = 50;
    var altura_barra = 6;
    var pos_x_barra = x - largura_barra/2;
    var pos_y_barra = y - sprite_height/2 - 15;

    var vida_percent = vida / vida_maxima;

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