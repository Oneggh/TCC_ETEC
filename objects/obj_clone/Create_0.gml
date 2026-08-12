/// @description Inicializa o clone aliado (vida ajustada pelo obj_player_1 logo após a criação)

sprite_index = spr_ggh;
image_speed = 0.3;
gpu_set_texfilter(false);

// Vida (sobrescrita com a vida do jogador no momento da invocação)
vida = 100;
vida_maxima = 100;

// Movimento e combate
velocidade = 2.5;
alcance_ataque = 140;

alvo = noone;
timer_busca = 0;
timer_busca_max = 20;

timer_ataque = 0;
timer_ataque_max = 40;

direcao_atual = 0;

// Invulnerabilidade após levar dano
invulneravel = false;
invulneravel_timer = 0;
invulneravel_duracao = 20;

// Efeito de acerto (pisca ao ser atingido)
piscadas_restantes = 0;
timer_efeito_acerto = 0;
cor_original = c_aqua; // tom azulado sutil pra diferenciar do jogador
image_blend = cor_original;

// Controla se a explosão de partículas da morte já foi disparada (só uma vez)
morte_efeito_disparado = false;
