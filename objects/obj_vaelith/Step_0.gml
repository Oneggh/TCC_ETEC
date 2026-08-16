/// @description IA da Vāelith: patrulha/alerta/perseguir/atacar (base do obj_inimigo) + Habilidade (invocar
/// diabretes), Especial (paralisia + sangue desnorteante) e Básico (teleporte pelas costas + clone de sangue).

// --- VERIFICA SE MORREU ---
if(vida <= 0) {
    image_alpha -= 0.05;
    if(image_alpha <= 0) {
        instance_destroy();
    }
    exit;
}

// Timer da pose de ataque (golpe de espada)
if(timer_ataque_anim > 0) timer_ataque_anim--;

// --- EFEITO DE ACERTO (PISCAR AO LEVAR DANO) ---
if(piscadas_restantes > 0) {
    timer_efeito_acerto--;

    if(timer_efeito_acerto <= 0) {
        if(image_blend == c_lime) {
            image_blend = cor_original;
        } else {
            image_blend = c_lime;
            piscadas_restantes--;
        }
        timer_efeito_acerto = 9;
    }

    if(piscadas_restantes <= 0) {
        image_blend = cor_original;
        timer_efeito_acerto = 0;
    }
}

// Verifica invulnerabilidade
if(invulneravel) {
    invulneravel_timer--;
    if(invulneravel_timer <= 0) invulneravel = false;
}

// --- COOLDOWNS DAS 3 HABILIDADES ---
if(cooldown_habilidade > 0) cooldown_habilidade--;
if(cooldown_especial > 0) cooldown_especial--;
if(cooldown_basico > 0) cooldown_basico--;

// --- ESCOLHE O ALVO MAIS PRÓXIMO (jogador ou clone) ---
alvo_atual = noone;
var dist_alvo = 999999;

if(instance_exists(obj_player_1)) {
    var d = point_distance(x, y, obj_player_1.x, obj_player_1.y);
    dist_alvo = d;
    alvo_atual = obj_player_1;
}
with(obj_clone) {
    var d = point_distance(x, y, other.x, other.y);
    if(d < dist_alvo) {
        dist_alvo = d;
        other.alvo_atual = id;
    }
}

// --- HABILIDADE: invoca mini diabretes pra ajudar, enquanto estiver engajada em combate ---
if(alvo_atual != noone && cooldown_habilidade <= 0 && diabretes_vivos < diabretes_max) {
    var qtd_invocar = diabretes_max - diabretes_vivos;
    repeat(qtd_invocar) {
        var ang_spawn = random(360);
        var dist_spawn = 30 + random(20);
        var sx = x + lengthdir_x(dist_spawn, ang_spawn);
        var sy = y + lengthdir_y(dist_spawn, ang_spawn);

        var diabrete = instance_create_depth(sx, sy, depth, obj_diabrete);
        diabrete.dono = id;
        diabretes_vivos++;

        repeat(6) {
            var p_invoc = instance_create_depth(sx, sy, 0, obj_efeito_sangue);
            p_invoc.vel_x = random(3) - 1.5;
            p_invoc.vel_y = random(3) - 1.5;
        }
    }
    cooldown_habilidade = cooldown_habilidade_max;
}

var andando = false;

if(alvo_atual == noone) {
    // Nenhum alvo no mapa: volta a patrulhar
    estado = "patrulha";
    timer_movimento = 0;
} else {
    // --- ESPECIAL: entra em preparo se estiver pronta, engajada e com o jogador no alcance ---
    if((estado == "perseguir" || estado == "atacar") && cooldown_especial <= 0
       && alvo_atual.object_index == obj_player_1 && dist_alvo <= alcance_especial) {
        estado = "especial";
        especial_em_preparo = true;
        especial_telegraph_timer = especial_telegraph_duracao;
    }

    switch(estado) {
        case "patrulha":
            // Avistou um alvo: entra em alerta antes de sair perseguindo
            if(dist_alvo < distancia_visao) {
                estado = "alerta";
                timer_reacao = timer_reacao_max;
                break;
            }

            // Lógica de patrulha com movimento suave
            if(timer_movimento <= 0 && timer_pausa <= 0) {
                direcao_atual = irandom(3);
                timer_movimento = timer_movimento_max;
                timer_pausa = timer_pausa_max;
            }

            if(timer_movimento > 0) {
                timer_movimento--;
                andando = true;

                switch(direcao_atual) {
                    case 0: // baixo
                        if (!place_meeting(x, y + speed_walk, obj_bloqueio)) y += speed_walk;
                        break;
                    case 1: // esquerda
                        if (!place_meeting(x - speed_walk, y, obj_bloqueio)) x -= speed_walk;
                        break;
                    case 2: // direita
                        if (!place_meeting(x + speed_walk, y, obj_bloqueio)) x += speed_walk;
                        break;
                    case 3: // cima
                        if (!place_meeting(x, y - speed_walk, obj_bloqueio)) y -= speed_walk;
                        break;
                }
            } else {
                timer_pausa--;
            }
            break;

        case "alerta":
            // Pequena pausa de reação antes de partir para a perseguição
            if(dist_alvo > distancia_visao * 1.5) {
                estado = "patrulha";
                break;
            }

            timer_reacao--;
            if(timer_reacao <= 0) {
                estado = "perseguir";
            }
            break;

        case "especial":
            // --- Paralisa o alvo e usa o sangue pra deixá-lo desnorteado, depois de um breve telegraph ---
            if(!instance_exists(alvo_atual)) {
                estado = "perseguir";
                especial_em_preparo = false;
                image_blend = cor_original;
                break;
            }
            if(dist_alvo > distancia_visao * 1.5) {
                estado = "patrulha";
                especial_em_preparo = false;
                image_blend = cor_original;
                break;
            }

            // Pulsa entre vermelho vivo e a cor original, avisando o golpe que vem
            image_blend = ((especial_telegraph_timer div 4) % 2 == 0) ? c_red : cor_original;

            especial_telegraph_timer--;
            if(especial_telegraph_timer <= 0) {
                especial_em_preparo = false;
                image_blend = cor_original;

                if(alvo_atual.object_index == obj_player_1
                   && point_distance(x, y, alvo_atual.x, alvo_atual.y) <= alcance_especial) {
                    var jogador_especial = alvo_atual;

                    jogador_especial.paralisado = true;
                    jogador_especial.paralisado_timer = paralisia_duracao;
                    jogador_especial.desnorteado = true;
                    jogador_especial.desnorteado_timer = paralisia_duracao + desnorte_duracao;

                    // O knockback do jogador não roda enquanto ele está paralisado, então sem isso
                    // ela ficaria colada nele acertando vários golpes seguidos sem nenhum espaçamento
                    // (era isso que estava causando o combo quase-hitkill). Dá uma imunidade a dano
                    // cobrindo a maior parte da paralisia, deixando no máximo 1 golpe conectar no
                    // fim da janela — pune o jogador por levar o especial, mas não é mais um combo livre.
                    jogador_especial.dano_recebido = true;
                    jogador_especial.dano_timer = paralisia_duracao - 35;

                    repeat(16) {
                        var p_esp = instance_create_depth(jogador_especial.x, jogador_especial.y, 0, obj_efeito_sangue);
                        p_esp.vel_x = random(6) - 3;
                        p_esp.vel_y = random(6) - 3;
                        p_esp.tempo_vida = 20;
                        p_esp.tamanho = 3 + random(4);
                    }
                }

                cooldown_especial = cooldown_especial_max;
                estado = "perseguir";
            }
            break;

        case "perseguir":
            if(dist_alvo > distancia_visao * 1.5) {
                estado = "patrulha";
                break;
            }

            if(dist_alvo < distancia_ataque) {
                estado = "atacar";
                timer_ataque = 0;
                break;
            }

            // --- BÁSICO: teletransporte pelas costas do alvo usando sangue, deixando uma cópia de sangue pra trás ---
            if(cooldown_basico <= 0 && dist_alvo >= alcance_teleporte_min && dist_alvo <= alcance_teleporte_max) {
                var vetores_direcao = [[0, 1], [-1, 0], [1, 0], [0, -1]]; // baixo, esquerda, direita, cima
                var dir_alvo_tp = alvo_atual.direcao_atual;
                var atras_x = -vetores_direcao[dir_alvo_tp][0];
                var atras_y = -vetores_direcao[dir_alvo_tp][1];

                var offset_teleporte = 46;
                var destino_x = alvo_atual.x + atras_x * offset_teleporte;
                var destino_y = alvo_atual.y + atras_y * offset_teleporte;

                if(!place_meeting(destino_x, destino_y, obj_bloqueio)) {
                    // Cópia de sangue no lugar onde ela estava antes de se teletransportar
                    var clone_sangue = instance_create_depth(x, y, depth + 1, obj_rastro_jogador);
                    clone_sangue.sprite_index = sprite_index;
                    clone_sangue.image_index = image_index;
                    clone_sangue.image_xscale = image_xscale;
                    clone_sangue.image_yscale = image_yscale;
                    clone_sangue.image_blend = make_colour_rgb(120, 10, 20);
                    clone_sangue.alpha_inicial = 0.9;
                    clone_sangue.tempo_vida = 40;

                    repeat(10) {
                        var p_saida = instance_create_depth(x, y, 0, obj_efeito_sangue);
                        p_saida.vel_x = random(4) - 2;
                        p_saida.vel_y = random(4) - 2;
                    }

                    x = destino_x;
                    y = destino_y;

                    var ddx_tp = alvo_atual.x - x;
                    var ddy_tp = alvo_atual.y - y;
                    if(abs(ddx_tp) > abs(ddy_tp)) {
                        direcao_atual = (ddx_tp > 0) ? 2 : 1;
                    } else {
                        direcao_atual = (ddy_tp > 0) ? 0 : 3;
                    }

                    repeat(10) {
                        var p_chegada = instance_create_depth(x, y, 0, obj_efeito_sangue);
                        p_chegada.vel_x = random(4) - 2;
                        p_chegada.vel_y = random(4) - 2;
                    }

                    // Golpe garantido ao chegar atrás do alvo
                    var dist_pos_tp = point_distance(x, y, alvo_atual.x, alvo_atual.y);
                    if(dist_pos_tp <= distancia_ataque + 30) {
                        timer_ataque_anim = tempo_ataque_anim_max; // mostra o golpe de espada
                        if(alvo_atual.object_index == obj_player_1) {
                            var jogador_tp = alvo_atual;
                            if(!jogador_tp.dano_recebido && !jogador_tp.dash_invulneravel) {
                                jogador_tp.Vida = max(jogador_tp.Vida - dano_basico, 0);

                                with(jogador_tp) {
                                    knockback_direcao_x = x - other.x;
                                    knockback_direcao_y = y - other.y;

                                    var length = sqrt(knockback_direcao_x * knockback_direcao_x +
                                                     knockback_direcao_y * knockback_direcao_y);
                                    if (length > 0) {
                                        knockback_direcao_x /= length;
                                        knockback_direcao_y /= length;
                                    }

                                    knockback_direcao_x *= other.knockback_forca;
                                    knockback_direcao_y *= other.knockback_forca;

                                    knockback_ativo = true;
                                    knockback_timer = knockback_duracao;
                                    dano_recebido = true;
                                    dano_timer = dano_duracao;
                                }
                            }
                        } else if(alvo_atual.object_index == obj_clone) {
                            var clone_tp = alvo_atual;
                            if(!clone_tp.invulneravel) {
                                clone_tp.vida = max(clone_tp.vida - dano_basico, 0);
                                clone_tp.invulneravel = true;
                                clone_tp.invulneravel_timer = clone_tp.invulneravel_duracao;
                                clone_tp.piscadas_restantes = 6;
                                clone_tp.timer_efeito_acerto = 9;
                                clone_tp.image_blend = c_lime;
                            }
                        }
                    }

                    cooldown_basico = cooldown_basico_max;
                    estado = "atacar";
                    timer_ataque = timer_ataque_max;
                    break;
                } else {
                    cooldown_basico = 20; // destino bloqueado, tenta de novo em breve
                }
            }

            // --- Perseguição normal (quando o teleporte não está disponível/no alcance) ---
            var dir_x = alvo_atual.x - x;
            var dir_y = alvo_atual.y - y;
            var angulo = point_direction(0, 0, dir_x, dir_y);

            var new_x = x + lengthdir_x(speed_walk, angulo);
            var new_y = y + lengthdir_y(speed_walk, angulo);

            if (!place_meeting(new_x, new_y, obj_bloqueio)) {
                x = new_x;
                y = new_y;
            } else {
                if (!place_meeting(new_x, y, obj_bloqueio)) x = new_x;
                if (!place_meeting(x, new_y, obj_bloqueio)) y = new_y;
            }
            andando = true;

            // Direção predominante em relação ao alvo (baixo/esquerda/direita/cima)
            if(abs(dir_x) > abs(dir_y)) {
                direcao_atual = (dir_x > 0) ? 2 : 1;
            } else {
                direcao_atual = (dir_y > 0) ? 0 : 3;
            }
            break;

        case "atacar":
            if(dist_alvo > distancia_ataque) {
                estado = "perseguir";
                break;
            }

            timer_ataque--;
            if(timer_ataque <= 0) {
                timer_ataque = timer_ataque_max;

                var dist_ataque = point_distance(x, y, alvo_atual.x, alvo_atual.y);
                if(dist_ataque <= distancia_ataque + 20) {
                    timer_ataque_anim = tempo_ataque_anim_max; // mostra o golpe de espada

                    if(alvo_atual.object_index == obj_player_1) {
                        // --- ATACA O JOGADOR (vida, invulnerabilidade e knockback próprios) ---
                        var jogador = alvo_atual;
                        if(!jogador.dano_recebido && !jogador.dash_invulneravel) {
                            jogador.Vida = max(jogador.Vida - dano, 0);

                            with(jogador) {
                                knockback_direcao_x = x - other.x;
                                knockback_direcao_y = y - other.y;

                                var length = sqrt(knockback_direcao_x * knockback_direcao_x +
                                                 knockback_direcao_y * knockback_direcao_y);
                                if (length > 0) {
                                    knockback_direcao_x /= length;
                                    knockback_direcao_y /= length;
                                }

                                knockback_direcao_x *= other.knockback_forca;
                                knockback_direcao_y *= other.knockback_forca;

                                knockback_ativo = true;
                                knockback_timer = knockback_duracao;
                                dano_recebido = true;
                                dano_timer = dano_duracao;
                            }
                        }
                    } else if(alvo_atual.object_index == obj_clone) {
                        // --- ATACA O CLONE (vida e piscar próprios, sem sistema de knockback) ---
                        var clone_alvo = alvo_atual;
                        if(!clone_alvo.invulneravel) {
                            clone_alvo.vida = max(clone_alvo.vida - dano, 0);
                            clone_alvo.invulneravel = true;
                            clone_alvo.invulneravel_timer = clone_alvo.invulneravel_duracao;
                            clone_alvo.piscadas_restantes = 6;
                            clone_alvo.timer_efeito_acerto = 9;
                            clone_alvo.image_blend = c_lime;

                            // Pequeno empurrão, já que o clone não tem sistema de knockback próprio
                            var kb_ang = point_direction(x, y, clone_alvo.x, clone_alvo.y);
                            clone_alvo.x += lengthdir_x(6, kb_ang);
                            clone_alvo.y += lengthdir_y(6, kb_ang);
                        }
                    }
                }
            }

            // Move devagar em direção ao alvo
            var angulo_atacar = point_direction(x, y, alvo_atual.x, alvo_atual.y);
            var new_x_atacar = x + lengthdir_x(speed_walk * 0.2, angulo_atacar);
            var new_y_atacar = y + lengthdir_y(speed_walk * 0.2, angulo_atacar);

            if (!place_meeting(new_x_atacar, new_y_atacar, obj_bloqueio)) {
                x = new_x_atacar;
                y = new_y_atacar;
            }
            break;
    }
}

// Mantém dentro da sala
x = clamp(x, 10, room_width - 10);
y = clamp(y, 10, room_height - 10);

// --- ANIMAÇÃO (spr_vaelith_ataque no golpe, spr_vaelith_andando andando, spr_vaelith_parada parada — 16 frames, bem fluido) ---
if(timer_ataque_anim > 0) {
    sprite_index = spr_vaelith_ataque;
    image_speed = 0;
    var fase_ataque_va = 1 - (timer_ataque_anim / tempo_ataque_anim_max);
    image_index = direcao_atual * frames_ataque + min(floor(fase_ataque_va * frames_ataque), frames_ataque - 1);
} else if(andando) {
    sprite_index = spr_vaelith_andando;
    image_speed = 0;
    // pula o frame 0 (pose de referência) — cicla só os 16 frames de andar de verdade
    image_index = direcao_atual * 17 + 1 + (floor(current_time / 60) % 16);
} else if(estado == "alerta" || estado == "especial") {
    // Respira parado, sem trocar de frame, enquanto reage/prepara o especial
    sprite_index = spr_vaelith_parada;
    image_index = direcao_atual * 17;
} else {
    // Idle "respirando": cicla devagar pelos 16 frames de parado da direção atual (pula o frame 0)
    sprite_index = spr_vaelith_parada;
    image_index = direcao_atual * 17 + 1 + (floor(current_time / 150) % 16);
}

// --- EFEITO DE LENTIDÃO (QUANDO ATINGIDA POR ATAQUE 100% CARREGADO) ---
if(efeito_lentidao) {
    timer_lentidao--;

    speed_walk = velocidade_original * 0.50;

    if(timer_lentidao <= 0) {
        efeito_lentidao = false;
        speed_walk = velocidade_original;
    }
} else {
    speed_walk = velocidade_original;
}
