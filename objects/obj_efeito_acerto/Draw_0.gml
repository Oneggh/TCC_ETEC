/// @description Desenha partícula verde
draw_set_color(c_lime);
draw_set_alpha(tempo_vida / 10);
draw_circle(x, y, tamanho, true);
draw_set_alpha(1);