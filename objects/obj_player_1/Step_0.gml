/// @description Lógica do jogador

// --- PAUSA ENQUANTO O CELULAR ESTÁ ABERTO ---
if (variable_global_exists("celular_aberto") && global.celular_aberto) exit;

// --- SALVAMENTO RÁPIDO (F5) — atalho, além do app "Menu > Salvar" no celular ---
if (keyboard_check_pressed(vk_f5)) {
    scr_save_write(1);
    show_debug_message("Jogo salvo (slot 1)");
}

// Timer de invulnerabilidade após dano
if(dano_recebido) {
    dano_timer--;
    if(dano_timer <= 0) {
        dano_recebido = false;
    }
}

// Timer da pose de ataque (notebook disparando o golpe do M1)
if(timer_ataque_anim > 0) timer_ataque_anim--;

// --- STATUS NEGATIVOS (paralisia e desnorteio, ex: especial da Vāelith) ---
if(paralisado) {
    paralisado_timer--;
    if(paralisado_timer <= 0) {
        paralisado = false;
    }
}
if(desnorteado) {
    desnorteado_timer--;
    if(desnorteado_timer <= 0) {
        desnorteado = false;
    }
}

if(paralisado) {
    image_blend = c_red;
} else if(desnorteado) {
    image_blend = c_fuchsia;
} else {
    image_blend = c_white;
}

// --- GERENCIAMENTO DE TIMERS DO DASH ---
if (!dash_disponivel) {
    dash_timer++;
    if (dash_timer >= dash_cooldown) {
        dash_disponivel = true;
        dash_timer = 0;
    }
}

// --- TROCA DE MODO COM TECLA T (CÍCLICA) ---
if(keyboard_check_pressed(ord("T"))) {
    // Avança para o próximo modo
    modo_index = (modo_index + 1) % 3;  // 0, 1, 2, volta para 0
    
    // Atualiza o modo e sprite baseado no índice
    switch(modo_index) {
        case 0:
            modo_atual = "normal";
            sprite_index = spr_normal;
            show_debug_message("Modo: NORMAL");
            break;
        case 1:
            modo_atual = "combate";
            sprite_index = spr_combate;
            show_debug_message("Modo: COMBATE");
            break;
        case 2:
            modo_atual = "mochila";
            sprite_index = spr_mochila;
            show_debug_message("Modo: MOCHILA");
            break;
    }
}

// --- PARALISIA (bloqueia movimento, dash e ataques por completo) ---
if (paralisado) {
    correndo = false; // não deixa o rastro/gasto de stamina de corrida "grudado" do frame anterior
    image_speed = 0.05;
    // frame 0 de cada bloco de 17 é a pose de referência (não faz parte do ciclo suave) — pula ela
    var frames_por_dir = (modo_atual == "mochila") ? 3 : 17;
    var frames_ciclo = (modo_atual == "mochila") ? 3 : 16;
    var offset_ciclo = (modo_atual == "mochila") ? 0 : 1;
    image_index = direcao_atual * frames_por_dir + offset_ciclo + (floor(current_time / 200) % frames_ciclo);
}
// --- KNOCKBACK ---
else if (knockback_ativo) {
    // Aplica o knockback
    if (!place_meeting(x + knockback_direcao_x * knockback_velocidade, y, obj_bloqueio)) {
        x += knockback_direcao_x * knockback_velocidade;
    }
    if (!place_meeting(x, y + knockback_direcao_y * knockback_velocidade, obj_bloqueio)) {
        y += knockback_direcao_y * knockback_velocidade;
    }
    
    knockback_timer--;
    if (knockback_timer <= 0) {
        knockback_ativo = false;
    }
    
    // PULA a movimentação normal durante o knockback
} else {
    // --- MOVIMENTAÇÃO NORMAL ---
    var dir_x = 0;
    var dir_y = 0;

    if keyboard_check(vk_right) || keyboard_check(ord("D")) dir_x = 1;
    if keyboard_check(vk_left)  || keyboard_check(ord("A")) dir_x = -1;
    if keyboard_check(vk_down)  || keyboard_check(ord("S")) dir_y = 1;
    if keyboard_check(vk_up)    || keyboard_check(ord("W")) dir_y = -1;

    // Desnorteada pelo sangue da Vāelith: movimento sai invertido
    if(desnorteado) {
        dir_x = -dir_x;
        dir_y = -dir_y;
    }

    // Verifica se está correndo (shift + movimento) e se tem stamina
    correndo = (keyboard_check(vk_shift) && (dir_x != 0 || dir_y != 0) && Stamina > 0);

    // CORREÇÃO: Normalizar a velocidade na diagonal
    var move_speed = speed_walk;
    if (correndo) move_speed = speed_walk * 1.5;

    // Se estiver se movendo nas duas direções (diagonal)
    if (dir_x != 0 && dir_y != 0) {
        move_speed = move_speed / 1.414;
    }

    // --- SISTEMA DE ATAQUE (M1 básico, M2 canalizado, G especial) — só no modo combate ---
    if(modo_atual == "combate") {
        var direcao_mira = point_direction(x, y, mouse_x, mouse_y);

        if(cooldown_m1 > 0) {
            cooldown_m1--;
        }
        if(cooldown_m2 > 0) {
            cooldown_m2--;
        }
        if(cooldown_especial > 0) {
            cooldown_especial--;
        }

        // --- M1: ataque básico "glitch" — explosão em área ao redor do mouse, sem custo de stamina ---
        if(mouse_check_button_pressed(mb_left) && cooldown_m1 <= 0 && !dash_em_andamento) {
            var raio_explosao = 55;
            var dano_m1 = 15;

            with(obj_vaelith) {
                if(point_distance(x, y, mouse_x, mouse_y) <= raio_explosao) {
                    vida = max(vida - dano_m1, 0);

                    invulneravel = true;
                    invulneravel_timer = invulneravel_duracao;

                    piscadas_restantes = 6;
                    timer_efeito_acerto = 9;
                    image_blend = c_lime;

                    instance_create_depth(x, y, 0, obj_efeito_acerto);
                }
            }
            with(obj_diabrete) {
                if(point_distance(x, y, mouse_x, mouse_y) <= raio_explosao) {
                    vida = max(vida - dano_m1, 0);

                    invulneravel = true;
                    invulneravel_timer = invulneravel_duracao;

                    piscadas_restantes = 6;
                    timer_efeito_acerto = 9;
                    image_blend = c_lime;

                    instance_create_depth(x, y, 0, obj_efeito_acerto);
                }
            }

            instance_create_depth(mouse_x, mouse_y, 0, obj_explosao_glitch);

            cooldown_m1 = cooldown_m1_max;
            squash_timer = squash_timer_max; // "pop" rápido no personagem ao disparar
            timer_ataque_anim = tempo_ataque_anim_max; // mostra a pose de ataque (notebook disparando)
        }

        // --- M2: raio canalizado — dano contínuo, gasta stamina, segue o mouse, empurra a cada 2s ---
        if(mouse_check_button_pressed(mb_right) && !dash_em_andamento && !canalizando_m2 && cooldown_m2 <= 0 && Stamina > 0) {
            canalizando_m2 = true;

            // O raio sai da altura do notebook (preso no peito), não do centro do corpo
            var offset_y_notebook = -20 * escala_personagem;

            raio_m2 = instance_create_depth(x, y + offset_y_notebook, 0, obj_projetil);
            raio_m2.origem = id;
            raio_m2.offset_y = offset_y_notebook;
            raio_m2.direcao = direcao_mira;
            instance_create_depth(x, y + offset_y_notebook, 0, obj_explosao_glitch); // flash do disparo saindo do notebook
            raio_m2.dano_continuo = true;
            raio_m2.tempo_vida = 999999; // dura enquanto o botão estiver segurado
            raio_m2.intervalo_dano = 6;
            raio_m2.dano_por_frame = 2;
            raio_m2.comprimento = 220;
            raio_m2.segmentos = 26;
            raio_m2.intensidade_glitch = 3;
            raio_m2.forca_empurrao = 14;
            raio_m2.intervalo_knockback = 120; // empurrão forte a cada 2s

            squash_timer = squash_timer_max; // "pop" rápido ao começar a canalizar
        }

        if(canalizando_m2) {
            if(mouse_check_button(mb_right) && instance_exists(raio_m2) && Stamina > 0 && !dash_em_andamento) {
                // Continua mirando no mouse em tempo real e gastando stamina
                raio_m2.direcao = point_direction(x, y, mouse_x, mouse_y);

                Stamina = max(Stamina - (gasto_stamina_m2_por_segundo / 60), 0);
                stamina_delay = 0;
            } else {
                // Soltou o botão, ficou sem stamina ou entrou em dash: encerra o canal
                canalizando_m2 = false;
                cooldown_m2 = cooldown_m2_max;
                if(instance_exists(raio_m2)) {
                    raio_m2.tempo_vida = 6; // fecha suavemente em vez de sumir seco
                }
                raio_m2 = noone;
            }
        }

        // --- G: especial — invoca um clone com a vida atual e cura ao máximo ---
        if(keyboard_check_pressed(ord("G")) && cooldown_especial <= 0) {
            var clone = instance_create_depth(x, y, 0, obj_clone);
            clone.vida = Vida;
            clone.vida_maxima = VidaMax;
            clone.direcao_atual = direcao_atual;

            Vida = VidaMax;
            cooldown_especial = cooldown_especial_max;

            show_debug_message("CLONE INVOCADO! Vida herdada: " + string(clone.vida));
        }
    } else if(canalizando_m2) {
        // Saiu do modo combate com o M2 ativo: encerra o canal
        canalizando_m2 = false;
        cooldown_m2 = cooldown_m2_max;
        if(instance_exists(raio_m2)) {
            raio_m2.tempo_vida = 6;
        }
        raio_m2 = noone;
    }

    // --- CONTROLE DO DASH ---
    if (dash_em_andamento) {
        // Durante o dash
        dash_duracao--;
        
        // Move na direção do dash
        if (!place_meeting(x + dash_direcao_x * dash_velocidade, y, obj_bloqueio)) {
            x += dash_direcao_x * dash_velocidade;
        }
        if (!place_meeting(x, y + dash_direcao_y * dash_velocidade, obj_bloqueio)) {
            y += dash_direcao_y * dash_velocidade;
        }
        
        // Mantém o sprite parado durante o dash (normal e combate compartilham o mesmo sprite de 4 frames/direção)
        if(modo_atual != "mochila") {
            switch (direcao_atual) {
                case 0: image_index = 2; break;
                case 1: image_index = 19; break;
                case 2: image_index = 36; break;
                case 3: image_index = 53; break;
            }
        }
        image_speed = 0;

        // Esticado na direção do dash (sensação de velocidade, tipo linha de movimento)
        if(dash_direcao_x != 0) {
            image_xscale = 1.3 * escala_personagem;
            image_yscale = 0.85 * escala_personagem;
        } else {
            image_xscale = 0.85 * escala_personagem;
            image_yscale = 1.3 * escala_personagem;
        }

        // Termina o dash
        if (dash_duracao <= 0) {
            dash_em_andamento = false;
            dash_invulneravel = false;
            image_speed = 0.3;
        }
    } else {
        // --- ATIVAÇÃO DO DASH ---
        if (keyboard_check_pressed(ord("Q")) && dash_disponivel && !dash_em_andamento && !canalizando_m2) {
            // VERIFICA SE TEM STAMINA SUFICIENTE
            if(Stamina >= 20) {
                // Prepara o dash
                dash_em_andamento = true;
                dash_disponivel = false;
                dash_duracao = 10;
                dash_timer = 0;
                
                // Define a direção do dash
                switch (direcao_atual) {
                    case 0: // Baixo
                        dash_direcao_x = 0;
                        dash_direcao_y = 1;
                        break;
                    case 1: // Esquerda
                        dash_direcao_x = -1;
                        dash_direcao_y = 0;
                        break;
                    case 2: // Direita
                        dash_direcao_x = 1;
                        dash_direcao_y = 0;
                        break;
                    case 3: // Cima
                        dash_direcao_x = 0;
                        dash_direcao_y = -1;
                        break;
                }
                
                // Ativa invulnerabilidade
                dash_invulneravel = true;
                
                // Gasta stamina ao dar dash
                Stamina = max(Stamina - 20, 0);
                
                // Congela animação
                image_speed = 0;
            }
        }
        
        // --- MOVIMENTAÇÃO NORMAL COM COLISÃO ---
        // Move na horizontal
        if (dir_x != 0) {
            if (!place_meeting(x + dir_x * move_speed, y, obj_bloqueio)) {
                x += dir_x * move_speed;
            }
        }

        // Move na vertical
        if (dir_y != 0) {
            if (!place_meeting(x, y + dir_y * move_speed, obj_bloqueio)) {
                y += dir_y * move_speed;
            }
        }

        // --- ANIMAÇÃO ---
        var andando = (dir_x != 0 || dir_y != 0);

        if(modo_atual == "mochila") {
            // Mochila ainda usa o sprite antigo (spr_ggh_mochila), 3 frames por direção — não alterado nesta atualização
            if (andando) {
                image_speed = 0.3;

                if (dir_y > 0) {
                    image_index = 0 + (image_index % 3);
                    direcao_atual = 0;
                }
                else if (dir_y < 0) {
                    image_index = 9 + (image_index % 3);
                    direcao_atual = 3;
                }
                else if (dir_x < 0) {
                    image_index = 3 + (image_index % 3);
                    direcao_atual = 1;
                }
                else if (dir_x > 0) {
                    image_index = 6 + (image_index % 3);
                    direcao_atual = 2;
                }

            } else {
                // Idle "respirando": cicla devagar pelos 3 frames de parado da direção atual
                image_speed = 0.05;
                image_index = direcao_atual * 3 + (image_index % 3);
            }
        } else {
            // Normal e combate compartilham a mesma arte agora (spr_parada/spr_andando/spr_ataque,
            // gerada no PixelLab), 4 frames por direção. M1/M2 em combate mostram a pose de ataque
            // (o golpe sai do notebook) por cima da animação de parado/andando.
            if (andando) {
                if (dir_y > 0) direcao_atual = 0;
                else if (dir_x < 0) direcao_atual = 1;
                else if (dir_x > 0) direcao_atual = 2;
                else if (dir_y < 0) direcao_atual = 3;
            }

            if ((timer_ataque_anim > 0 || canalizando_m2) && andando) {
                sprite_index = spr_ataque_andando;
                image_speed = 0;

                if (timer_ataque_anim > 0) {
                    var fase_ataque = 1 - (timer_ataque_anim / tempo_ataque_anim_max);
                    image_index = direcao_atual * frames_ataque + min(floor(fase_ataque * frames_ataque), frames_ataque - 1);
                } else {
                    image_index = direcao_atual * frames_ataque + 1 + (floor(current_time / 100) % (frames_ataque - 1));
                }
            } else if (timer_ataque_anim > 0 || canalizando_m2) {
                sprite_index = spr_ataque;
                image_speed = 0;

                if (timer_ataque_anim > 0) {
                    // Burst do M1: percorre os frames uma vez só, do início ao fim
                    var fase_ataque = 1 - (timer_ataque_anim / tempo_ataque_anim_max);
                    image_index = direcao_atual * frames_ataque + min(floor(fase_ataque * frames_ataque), frames_ataque - 1);
                } else {
                    // Canal do M2: cicla os frames em loop enquanto o botão estiver segurado
                    // (pula o frame 0 = pose de referência, não faz parte do ciclo suave)
                    image_index = direcao_atual * frames_ataque + 1 + (floor(current_time / 100) % (frames_ataque - 1));
                }
            } else if (andando) {
                sprite_index = spr_andando;
                image_speed = 0;
                // pula o frame 0 (pose de referência) — cicla só os 16 frames de andar de verdade
                image_index = direcao_atual * 17 + 1 + (floor(current_time / 60) % 16);
            } else {
                // Idle "respirando": cicla devagar pelos 16 frames de parado da direção atual (pula o frame 0)
                sprite_index = spr_parada;
                image_speed = 0.05;
                image_index = direcao_atual * 17 + 1 + (floor(current_time / 150) % 16);
            }
        }

        // --- BOUNCE AO ANDAR + RESPIRO PARADO + "POP" DE ATAQUE ---
        var escala_x = 1;
        var escala_y = 1;

        if(andando) {
            // Um "baque" a cada passo (mochila ainda usa 3 frames/direção; normal e combate usam 16, sem contar o frame de referência)
            var frames_ciclo_passo = (modo_atual == "mochila") ? 3 : 16;
            var fase_passo = (image_index % frames_ciclo_passo) / frames_ciclo_passo;
            var bounce = abs(sin(fase_passo * pi * 2));
            escala_y = 1 - bounce * 0.06;
            escala_x = 1 + bounce * 0.04;
        } else {
            // Respiro sutil parado, além da troca de frames já existente
            escala_y = 1 + sin(current_time * 0.003) * 0.015;
        }

        // "Pop" rápido ao disparar M1/M2, decaindo sozinho
        if(squash_timer > 0) {
            squash_timer--;
            var t = squash_timer / squash_timer_max;
            escala_x *= 1 + t * 0.18;
            escala_y *= 1 - t * 0.18;
        }

        image_xscale = escala_x * escala_personagem;
        image_yscale = escala_y * escala_personagem;
    }
}

// --- RASTRO (afterimage) AO CORRER OU DAR DASH ---
if(dash_em_andamento || correndo) {
    timer_rastro--;
    if(timer_rastro <= 0) {
        timer_rastro = dash_em_andamento ? 2 : 5;

        var rastro = instance_create_depth(x, y, depth + 1, obj_rastro_jogador);
        rastro.sprite_index = sprite_index;
        rastro.image_index = image_index;
        rastro.image_xscale = image_xscale;
        rastro.image_yscale = image_yscale;
        rastro.image_blend = dash_em_andamento ? c_aqua : c_white;
        rastro.alpha_inicial = dash_em_andamento ? 0.5 : 0.25;
    }
} else {
    timer_rastro = 0;
}

// --- SISTEMA DE STAMINA COMPLETO ---
// Gasto de stamina ao correr
if(correndo && Stamina > 0) {
    Stamina = max(Stamina - 0.5, 0);
    stamina_delay = 0;
}

// Recuperação de stamina (não recupera enquanto canaliza o M2, senão ele briga com o gasto)
if(!correndo && !dash_em_andamento && !canalizando_m2 && Stamina < Stamina_maxima) {
    stamina_delay++;
    if(stamina_delay > 30) {
        Stamina = min(Stamina + 0.2, Stamina_maxima);
    }
} else if(!correndo && !dash_em_andamento && !canalizando_m2) {
    stamina_delay = 0;
}

// Verifica se pode gastar stamina
pode_gastar_stamina = (Stamina > 0);

// Se stamina for 0, não pode correr
if(Stamina <= 0) {
    correndo = false;
}

// --- EFEITO VISUAL DE INVULNERABILIDADE ---
if (dash_invulneravel || dano_recebido) {
    image_alpha = 0.5 + (sin(current_time * 0.1) * 0.3);
} else {
    image_alpha = 1;
}

// --- VERIFICA MORTE E RESPAWN ---
if(Vida <= 0) {
    respawn = true;
}

// Processa respawn
if respawn {
    x = 930;
    y = 330;
    Vida = VidaMax;
    Stamina = Stamina_maxima;
    modo_atual = "normal";
    modo_index = 0;
    sprite_index = spr_normal;
    respawn = false;
}

// --- GARANTE QUE VALORES NÃO FIQUEM FORA DOS LIMITES ---
Vida = clamp(Vida, 0, VidaMax);
Stamina = clamp(Stamina, 0, Stamina_maxima);