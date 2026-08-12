// === CONFIGURAÇÕES BÁSICAS ===
sprite_index = spr_enemy1;
image_speed = 1;
speed_walk = 3;

// === POSIÇÃO INICIAL ===
x = 1400;
y = 500;

// === VIDA ===
vida_maxima = 100;
vida = vida_maxima;
invulneravel = false;
invulneravel_timer = 0;
invulneravel_duracao = 30;

// === DIREÇÃO E ANIMAÇÃO ===
direcao = 1;
direcao_atual = 2;

// === COMPORTAMENTO ===
estado = "patrulha";
distancia_visao = 200;
distancia_ataque = 40;

// === TIMERS ===
timer_movimento = 0;
timer_movimento_max = 120;
timer_pausa = 0;
timer_pausa_max = 60;
timer_ataque = 0;
timer_ataque_max = 30;

// === REAÇÃO (pequena pausa ao avistar um alvo, antes de sair perseguindo) ===
timer_reacao = 0;
timer_reacao_max = 30;

// === ALVO ATUAL (jogador ou clone, o que estiver mais perto — recalculado a cada Step) ===
alvo_atual = noone;

// === CORREÇÕES ===
image_xscale = 2.5;
image_yscale = 2.5;
mask_index = sprite_index;

// === KNOCKBACK E DANO ===
knockback_forca = 1;
dano = 10;

// === EFEITO DE ACERTO (PISCAR VERDE) ===
timer_efeito_acerto = 0;
piscadas_restantes = 0;
cor_original = c_white;
image_blend = cor_original;

// === EFEITO DE LENTIDÃO (ao ser atingido por um ataque 100% carregado) ===
efeito_lentidao = false;
timer_lentidao = 0;
velocidade_original = speed_walk;
