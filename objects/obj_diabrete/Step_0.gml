/// @description IA do mini diabrete: persegue e ataca o alvo mais próximo (jogador ou clone), some depois de um tempo

// Morreu?
if(vida <= 0) {
    if(!morte_efeito_disparado) {
        morte_efeito_disparado = true;

        repeat(8) {
            var frag = instance_create_depth(x, y, 0, obj_faisca_rgb);
            frag.cor_faisca = make_colour_rgb(180, 20, 20);
            frag.tamanho = 3 + random(3);
            frag.tempo_vida = 10 + irandom(8);
            frag.tempo_vida_max = frag.tempo_vida;

            var ang_frag = random(360);
            var vel_frag = 1 + random(2.5);
            frag.vel_x = lengthdir_x(vel_frag, ang_frag);
            frag.vel_y = lengthdir_y(vel_frag, ang_frag);
        }
    }

    image_alpha -= 0.08;
    if(image_alpha <= 0) instance_destroy();
    exit;
}

// Invocação temporária: se dissipa sozinho depois de um tempo, sem precisar morrer em combate
tempo_vida--;
if(tempo_vida <= 0) {
    image_alpha -= 0.05;
    if(image_alpha <= 0) instance_destroy();
    exit;
}

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
    }
}

if(invulneravel) {
    invulneravel_timer--;
    if(invulneravel_timer <= 0) invulneravel = false;
}

// --- BUSCA DE ALVO (jogador ou clone, o mais próximo) ---
timer_busca--;
if(timer_busca <= 0 || !instance_exists(alvo)) {
    timer_busca = timer_busca_max;

    var dist_min = 999999;
    var proximo = noone;

    if(instance_exists(obj_player_1)) {
        dist_min = distance_to_object(obj_player_1);
        proximo = obj_player_1;
    }
    with(obj_clone) {
        var d = distance_to_object(other);
        if(d < dist_min) {
            dist_min = d;
            proximo = id;
        }
    }
    alvo = proximo;
}

// --- PERSEGUIÇÃO E ATAQUE ---
if(alvo != noone && instance_exists(alvo)) {
    var dist = point_distance(x, y, alvo.x, alvo.y);
    var ang = point_direction(x, y, alvo.x, alvo.y);

    if(dist > alcance_ataque) {
        image_speed = 0.4;

        var new_x = x + lengthdir_x(velocidade, ang);
        var new_y = y + lengthdir_y(velocidade, ang);

        if (!place_meeting(new_x, new_y, obj_bloqueio)) {
            x = new_x;
            y = new_y;
        } else if (!place_meeting(new_x, y, obj_bloqueio)) {
            x = new_x;
        } else if (!place_meeting(x, new_y, obj_bloqueio)) {
            y = new_y;
        }

        image_xscale = (lengthdir_x(1, ang) < 0 ? -1 : 1) * 1.6;
    } else {
        image_speed = 0.15;

        timer_ataque--;
        if(timer_ataque <= 0) {
            timer_ataque = timer_ataque_max;

            if(alvo.object_index == obj_player_1) {
                var jogador = alvo;
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

                        knockback_direcao_x *= 0.8;
                        knockback_direcao_y *= 0.8;

                        knockback_ativo = true;
                        knockback_timer = knockback_duracao;
                        dano_recebido = true;
                        dano_timer = dano_duracao;
                    }
                }
            } else if(alvo.object_index == obj_clone) {
                var clone_alvo = alvo;
                if(!clone_alvo.invulneravel) {
                    clone_alvo.vida = max(clone_alvo.vida - dano, 0);
                    clone_alvo.invulneravel = true;
                    clone_alvo.invulneravel_timer = clone_alvo.invulneravel_duracao;
                    clone_alvo.piscadas_restantes = 6;
                    clone_alvo.timer_efeito_acerto = 9;
                    clone_alvo.image_blend = c_lime;
                }
            }
        }
    }
} else {
    image_speed = 0.1;
}

// Mantém dentro da sala
x = clamp(x, 10, room_width - 10);
y = clamp(y, 10, room_height - 10);

vida = clamp(vida, 0, vida_maxima);
