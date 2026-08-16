/// @description Luz ambiente de dia ensolarado (banho quente suave, sem contraste agressivo)

// Sol alto: um leve brilho quente por cima de tudo, bem sutil — nada de tint escuro.
cor_sol = make_colour_rgb(255, 238, 196);
alpha_sol = 0.10;

// Desenha por cima de tudo no espaço da sala (depth bem negativo = na frente)
depth = -100000;
