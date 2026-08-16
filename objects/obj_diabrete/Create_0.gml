/// @description Mini diabrete — invocado pela Habilidade da Vāelith, ajuda ela em combate por um tempo limitado

// === SPRITE (PLACEHOLDER) ===
// spr_enemy1 (mesmo bichinho pequeno já usado pelos inimigos comuns) tingido de vermelho-sangue.
image_speed = 0.5;
gpu_set_texfilter(false);
mask_index = sprite_index;

cor_original = make_colour_rgb(180, 20, 20);
image_blend = cor_original;

image_xscale = 1.6;
image_yscale = 1.6;

// === QUEM A INVOCOU (definido por quem cria, pra avisar quando ela morrer/expirar) ===
dono = noone;

// === VIDA ===
vida_maxima = 30;
vida = vida_maxima;
invulneravel = false;
invulneravel_timer = 0;
invulneravel_duracao = 15;

// === COMBATE ===
velocidade = 3.2;
alcance_ataque = 34;
dano = 6;
timer_ataque = 0;
timer_ataque_max = 50;

// === ALVO ===
alvo = noone;
timer_busca = 0;
timer_busca_max = 20;

// === INVOCAÇÃO TEMPORÁRIA: some sozinho depois de um tempo, mesmo sem morrer ===
tempo_vida = 600; // ~10s

// === EFEITO DE ACERTO ===
piscadas_restantes = 0;
timer_efeito_acerto = 0;

morte_efeito_disparado = false;
