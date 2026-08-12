/// @description Desenha o mini fragmento colorido (quadrado ou triângulo)

var alpha = tempo_vida / tempo_vida_max;
var tam = tamanho;

draw_set_color(cor_faisca);
draw_set_alpha(alpha);

if(forma == 0) {
    draw_rectangle(x - tam * 0.5, y - tam * 0.5, x + tam * 0.5, y + tam * 0.5, false);
} else {
    draw_triangle(x, y - tam * 0.6, x - tam * 0.6, y + tam * 0.5, x + tam * 0.6, y + tam * 0.5, false);
}

draw_set_alpha(1);
