/// @description Fagulha RGB (quadrada ou triangular) — só efeito visual

tempo_vida = 12;
tempo_vida_max = tempo_vida;

vel_x = 0;
vel_y = 0;
tamanho = 3 + random(3);

cor_faisca = c_white; // definida por quem cria (vermelho, verde ou azul)
forma = irandom(1); // 0 = quadrado, 1 = triângulo
