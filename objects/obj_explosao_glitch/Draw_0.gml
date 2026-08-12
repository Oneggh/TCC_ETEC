/// @description Desenha o burst: flash central + estilhaços glitch + anel se expandindo

var progresso = 1 - (tempo_vida / tempo_vida_max);
var alpha = 1 - progresso;
var raio_atual = raio_max * progresso;

// Flash branco central, rápido e intenso nos primeiros instantes
if(progresso < 0.35) {
    draw_set_color(c_white);
    draw_set_alpha((1 - progresso / 0.35) * 0.85);
    draw_circle(x, y, raio_max * 0.45 * (1 - progresso * 0.5), false);
    draw_set_alpha(1);
}

// Estilhaços glitch disparando para fora do centro (efeito de "estilhaçamento")
for (var i = 0; i < num_estilhacos; i++) {
    var comp = raio_atual * (0.7 + random(0.3));
    var base_x = x + lengthdir_x(comp * 0.35, angulos_estilhaco[i]);
    var base_y = y + lengthdir_y(comp * 0.35, angulos_estilhaco[i]);
    var ponta_x = x + lengthdir_x(comp, angulos_estilhaco[i]);
    var ponta_y = y + lengthdir_y(comp, angulos_estilhaco[i]);

    draw_set_color(cores[irandom(array_length(cores) - 1)]);
    draw_set_alpha(alpha);
    draw_line_width(base_x, base_y, ponta_x, ponta_y, 1 + alpha * 3);
}
draw_set_alpha(1);

// Anel glitch se expandindo por cima
draw_set_alpha(alpha * 0.6);
for(var i = 0; i < 3; i++) {
    draw_set_color(cores[irandom(array_length(cores) - 1)]);
    draw_circle(x + random(6) - 3, y + random(6) - 3, max(raio_atual - i * 6, 0), true);
}
draw_set_alpha(1);
