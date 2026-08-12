
// SPRITES
spr_normal = sprite_index;  // Pega o sprite atual (personagem normal)
spr_combate = spr_ggh_attack;  // Sprite de combate
spr_mochila = spr_ggh_mochila;  // Sprite com mochila

// MODOS
modo_atual = "normal";
modos = ["normal", "combate", "mochila"];  // Lista de modos
modo_index = 0;  // Índice do modo atual

// MOVIMENTO
speed_walk = 4;
image_speed = 0;
frames_por_direcao = 3;
pode_andar = true;
gpu_set_texfilter(false);

// TAMANHO DO PERSONAGEM (a sprite é 32x32; isso deixa ele maior na tela, mais perto do
// tamanho dos inimigos, que já são exibidos em 2.5x). Só mexer neste número pra ajustar.
escala_personagem = 1.5;
image_xscale = escala_personagem;
image_yscale = escala_personagem;

respawn = false;

ultima_dir_x = 0;
ultima_dir_y = 1;
direcao_atual = 0;

// VIDA
VidaMax = 100;
Vida = VidaMax;

// STAMINA (única declaração)
Stamina = 100;
Stamina_maxima = 100;
pode_gastar_stamina = true;
stamina_delay = 0;

// DASH
dash_disponivel = true;
dash_em_andamento = false;
dash_velocidade = 12;
dash_duracao = 10;
dash_timer = 0;
dash_cooldown = 72;
dash_direcao_x = 0;
dash_direcao_y = 0;
dash_invulneravel = false;

// DANO E INVULNERABILIDADE
dano_recebido = false;
dano_timer = 0;
dano_duracao = 20;

// KNOCKBACK
knockback_ativo = false;
knockback_velocidade = 8;
knockback_direcao_x = 0;
knockback_direcao_y = 0;
knockback_duracao = 15;
knockback_timer = 0;

// CORRENDO
correndo = false;

// SISTEMA DE ATAQUE (M1 = básico, M2 = raio canalizado, G = especial)
// M1: ataque básico "glitch", hit único, mira no mouse, sem custo, com cooldown curto
cooldown_m1 = 0;
cooldown_m1_max = 12; // ~0.2s

// M2: raio canalizado, gasta stamina enquanto segurado, segue o mouse em tempo real
canalizando_m2 = false;
raio_m2 = noone; // instância do raio contínuo enquanto o M2 está ativo
gasto_stamina_m2_por_segundo = 15;
cooldown_m2 = 0;
cooldown_m2_max = 30; // 0,5s — evita ficar ligando e desligando o canal repetidamente

// G: especial — invoca um clone com a vida atual e cura ao máximo
cooldown_especial = 0;
cooldown_especial_max = 300; // 5s

// --- POLIMENTO VISUAL (juice): bounce ao andar, "pop" nos ataques, rastro ao correr/dashar ---
squash_timer = 0;
squash_timer_max = 8;
timer_rastro = 0;