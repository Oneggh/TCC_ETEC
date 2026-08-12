/// @description Lógica do inimigo

// --- VERIFICA SE MORREU ---
if(vida <= 0) {
    image_alpha -= 0.05;
    if(image_alpha <= 0) {
        instance_destroy();
    }
    exit;
}

// --- EFEITO DE ACERTO (PISCAR VERDE) ---
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

if(alvo_atual == noone) {
    // Nenhum alvo no mapa: volta a patrulhar
    estado = "patrulha";
    timer_movimento = 0;
} else {
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

                if(direcao_atual == 1) image_xscale = -abs(image_xscale);
                if(direcao_atual == 2) image_xscale = abs(image_xscale);
            } else {
                timer_pausa--;
            }
            break;

        case "alerta":
            // Pequena pausa de reação antes de partir para a perseguição
            image_speed = 0;

            if(dist_alvo > distancia_visao * 1.5) {
                estado = "patrulha";
                break;
            }

            timer_reacao--;
            if(timer_reacao <= 0) {
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

            if(abs(dir_x) > abs(dir_y)) {
                if(dir_x > 0) {
                    image_xscale = abs(image_xscale);
                    direcao_atual = 2;
                } else {
                    image_xscale = -abs(image_xscale);
                    direcao_atual = 1;
                }
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

// Animação
if(estado != "alerta") {
    image_speed = 0.5;
}

// --- EFEITO DE LENTIDÃO (QUANDO ATINGIDO POR ATAQUE 100%) ---
if(efeito_lentidao) {
    timer_lentidao--;

    speed_walk = velocidade_original * 0.50;
    image_speed = 0.2;

    if(timer_lentidao <= 0) {
        efeito_lentidao = false;
        speed_walk = velocidade_original;
        image_speed = 0.5;
    }
} else {
    speed_walk = velocidade_original;
}
