
// SPRITES (arte pixel gerada no PixelLab, 128x128, 4 dir x 4 frames — normal e combate compartilham a mesma arte agora)
spr_normal = sprite_index;  // Pega o sprite atual (spr_player_parada, definido no editor)
spr_parada = spr_normal;
spr_andando = spr_player_andando;
spr_ataque = spr_player_ataque;  // pose de ataque parado (reação sutil — o golpe sai do notebook, ele só reage)
spr_ataque_andando = spr_player_ataque_andando;  // pose de ataque andando (atira com o notebook em movimento)
spr_combate = spr_parada;  // mantido por compatibilidade (troca de modo, carregamento de save)
spr_mochila = spr_ggh_mochila;  // Sprite com mochila (não alterado nesta atualização)

// --- ANIMAÇÃO DE ATAQUE (M1/M2 em combate — 8 frames por direção) ---
timer_ataque_anim = 0;
tempo_ataque_anim_max = 20; // ~0,33s
frames_ataque = 17; // v3 custom gera 16 frames de ação + 1 frame de referência (pose inicial) = 17

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

// TAMANHO DO PERSONAGEM (sprite agora é 128x128, 4x mais detalhado que antes). Só mexer neste
// número pra ajustar.
escala_personagem = 0.5625;
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

// STATUS NEGATIVOS (aplicados por inimigos — ex: especial da Vāelith paralisa e depois desnorteia)
paralisado = false;
paralisado_timer = 0;
desnorteado = false;
desnorteado_timer = 0;

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

// --- CARREGAMENTO DE SAVE (se veio da tela de título via "Saves") ---
if (variable_global_exists("save_pendente") && !is_undefined(global.save_pendente)) {
    var _d = global.save_pendente;

    x = _d.x;
    y = _d.y;
    VidaMax = _d.vida_max;
    Vida = clamp(_d.vida, 0, VidaMax);
    Stamina_maxima = _d.stamina_max;
    Stamina = clamp(_d.stamina, 0, Stamina_maxima);

    switch (_d.modo) {
        case "combate":
            modo_atual = "combate";
            modo_index = 1;
            sprite_index = spr_combate;
            break;
        case "mochila":
            modo_atual = "mochila";
            modo_index = 2;
            sprite_index = spr_mochila;
            break;
        default:
            modo_atual = "normal";
            modo_index = 0;
            sprite_index = spr_normal;
            break;
    }

    global.save_pendente = undefined;
}

// --- CELULAR (menu in-game, tecla P) ---
if (!instance_exists(obj_celular)) {
    instance_create_depth(0, 0, 0, obj_celular);
}