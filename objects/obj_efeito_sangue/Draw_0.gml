/// @description Desenha a partícula de sangue
draw_set_color(make_colour_rgb(140, 10, 20));
draw_set_alpha(tempo_vida / 14);
draw_circle(x, y, tamanho, true);
draw_set_alpha(1);
