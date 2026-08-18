/// @description Vāelith — inimiga única (demônia guerreira/invocadora). Base pronta pra receber Básico/Especial/Habilidade depois.

nome = "Vāelith";

// === SPRITE (arte pixel gerada no PixelLab: spr_vaelith_parada / spr_vaelith_andando, 4 dir x 8 frames) ===
sprite_index = spr_vaelith_parada;
image_speed = 0;
gpu_set_texfilter(false);
mask_index = sprite_index;

cor_original = c_white; // sem tingimento — usa a cor real do sprite; ainda usada pro flash de acerto/telegraph
image_blend = cor_original;

escala_personagem = 0.6; // sprite agora é 128x128 (4x mais detalhado); escala aumentada pra ela
                          // aparecer maior na tela (ela é bem mais alta que os inimigos comuns, ~2,00m no lore)
image_xscale = escala_personagem;
image_yscale = escala_personagem;

// === VIDA ===
vida_maxima = 250;
vida = vida_maxima;
vida_trail = vida_maxima; // "rastro" de dano na barra de chefe — some devagar, atrás da vida atual
invulneravel = false;
invulneravel_timer = 0;
invulneravel_duracao = 30;

// === DIREÇÃO E ANIMAÇÃO (0=baixo, 1=esquerda, 2=direita, 3=cima — 8 frames por direção) ===
direcao_atual = 0;

// === COMPORTAMENTO (mesmos estados do obj_inimigo: patrulha/alerta/perseguir/atacar) ===
estado = "patrulha";
speed_walk = 3;
distancia_visao = 220;
distancia_ataque = 45;

// === TIMERS ===
timer_movimento = 0;
timer_movimento_max = 120;
timer_pausa = 0;
timer_pausa_max = 60;
timer_ataque = 0;
timer_ataque_max = 35;

// === REAÇÃO (pequena pausa ao avistar um alvo, antes de sair perseguindo) ===
timer_reacao = 0;
timer_reacao_max = 30;

// === ALVO ATUAL (jogador ou clone, o que estiver mais perto — recalculado a cada Step) ===
alvo_atual = noone;

// === DANO E KNOCKBACK (ataque de contato genérico; vira placeholder pros 3 ataques dela) ===
dano = 9;
knockback_forca = 1.4;

// === BARRA DE VIDA: aparece quando o jogador chega perto, mesmo com ela ainda com vida cheia ===
alcance_barra_vida = 220;

// === EFEITO DE ACERTO (PISCAR AO LEVAR DANO) ===
timer_efeito_acerto = 0;
piscadas_restantes = 0;

// === EFEITO DE LENTIDÃO (ao ser atingida por um ataque 100% carregado do jogador) ===
efeito_lentidao = false;
timer_lentidao = 0;
velocidade_original = speed_walk;

// === HABILIDADE: invoca mini diabretes pra ajudar em combate ===
diabretes_vivos = 0;
diabretes_max = 2;
cooldown_habilidade = 90; // pequeno atraso antes da primeira invocação
cooldown_habilidade_max = 480; // ~8s

// === ESPECIAL: paralisa e usa o sangue pra deixar o alvo desnorteado ===
cooldown_especial = 180; // atraso inicial maior, é o golpe mais forte dela
cooldown_especial_max = 600; // ~10s
alcance_especial = 260;
especial_telegraph_duracao = 30; // ~0,5s "carregando" antes de soltar — dá tempo do jogador reagir/fugir
especial_telegraph_timer = 0;
especial_em_preparo = false;
paralisia_duracao = 90; // ~1,5s totalmente travada
desnorte_duracao = 180; // ~3s de movimento invertido, depois da paralisia

// === BÁSICO: teletransporte pelas costas do alvo usando sangue, deixando uma cópia de sangue no lugar antigo ===
cooldown_basico = 60;
cooldown_basico_max = 150; // ~2,5s
alcance_teleporte_min = 90;
alcance_teleporte_max = 420;
dano_basico = 12;

// === ANIMAÇÃO DE ATAQUE (golpe de espada, spr_vaelith_ataque — toca ao acertar no "atacar" ou no teleporte do Básico) ===
timer_ataque_anim = 0;
tempo_ataque_anim_max = 20; // ~0,33s
frames_ataque = 17; // v3 custom gera 16 frames de ação + 1 frame de referência = 17

// === INTRODUÇÃO: jogador aperta E perto dela, ela fala e uma contagem regressiva na tela dá início à luta ===
// (só acontece uma vez — depois disso ela reage normalmente por avistamento, como sempre)
introducao_feita = false;
em_introducao = false;
fase_introducao = ""; // "fala" ou "contagem"
alcance_interacao = 80; // distância máxima do jogador pra apertar E e ela falar
texto_fala = "Ora, ora... um intruso. Vamos ver do que você é capaz.";
timer_fala = 0;
fala_duracao = 150; // ~2,5s de balão de fala antes da contagem começar
contagem_valor = 10;
timer_contagem = 0;
contagem_intervalo = 30; // ~0,5s por número (10 -> 1 = 5s)
