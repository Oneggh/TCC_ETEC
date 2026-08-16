/// @description IA do clone: persegue e ataca inimigos com o raio glitch (própria mira e ritmo)

// Morreu?
if(vida <= 0) {
    // Explosão de fragmentos RGB, uma única vez, assim que a vida chega a 0
    if(!morte_efeito_disparado) {
        morte_efeito_disparado = true;

        var cores_morte = [c_red, c_lime, c_blue];
        repeat(16) {
            var frag = instance_create_depth(x, y, 0, obj_faisca_rgb);
            frag.cor_faisca = cores_morte[irandom(2)];
            frag.tamanho = 4 + random(4);
            frag.tempo_vida = 14 + irandom(10);
            frag.tempo_vida_max = frag.tempo_vida;

            var ang_frag = random(360);
            var vel_frag = 1.5 + random(3);
            frag.vel_x = lengthdir_x(vel_frag, ang_frag);
            frag.vel_y = lengthdir_y(vel_frag, ang_frag);
        }
    }

    image_alpha -= 0.05;
    if(image_alpha <= 0) {
        instance_destroy();
    }
    exit;
}

// Efeito de acerto (pisca ao ser atingido)
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
    if(invulneravel_timer <= 0) {
        invulneravel = false;
    }
}

// --- BUSCA DE ALVO ---
timer_busca--;
if(timer_busca <= 0 || !instance_exists(alvo)) {
    timer_busca = timer_busca_max;

    var dist_min = 999999;
    var proximo = noone;
    with(obj_vaelith) {
        var d = distance_to_object(other);
        if(d < dist_min) {
            dist_min = d;
            proximo = id;
        }
    }
    with(obj_diabrete) {
        var d = distance_to_object(other);
        if(d < dist_min) {
            dist_min = d;
            proximo = id;
        }
    }
    alvo = proximo;
}

// --- PERSEGUIÇÃO, ANIMAÇÃO E ATAQUE ---
if(alvo != noone && instance_exists(alvo)) {
    var dist = point_distance(x, y, alvo.x, alvo.y);
    var ang = point_direction(x, y, alvo.x, alvo.y);
    var ddx = alvo.x - x;
    var ddy = alvo.y - y;

    // Direção predominante em relação ao alvo (mesma disposição de sprite do jogador: 3 frames por direção)
    if(abs(ddx) > abs(ddy)) {
        direcao_atual = (ddx > 0) ? 2 : 1; // direita/esquerda
    } else {
        direcao_atual = (ddy > 0) ? 0 : 3; // baixo/cima
    }

    if(dist > alcance_ataque) {
        // Se aproxima até ficar dentro do alcance de ataque
        image_speed = 0.3;

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

        image_index = direcao_atual * 3 + (image_index % 3);
    } else {
        // Parado no alcance, "respirando" enquanto mira
        image_speed = 0.05;
        image_index = direcao_atual * 3 + (image_index % 3);
    }

    // Dispara periodicamente enquanto o alvo estiver no alcance
    if(dist <= alcance_ataque) {
        timer_ataque--;
        if(timer_ataque <= 0) {
            timer_ataque = timer_ataque_max;

            var raio = instance_create_depth(x, y, 0, obj_projetil);
            raio.origem = id;
            raio.alvo = alvo;
            raio.direcao = ang;
            raio.dano_continuo = false;
            raio.tempo_vida = 10;
            raio.dano_por_frame = 2;
            raio.comprimento = alcance_ataque + 20;
            raio.segmentos = 16;
            raio.intensidade_glitch = 2;
        }
    }
} else {
    // Sem alvo: respira parado na última direção conhecida
    image_speed = 0.05;
    image_index = direcao_atual * 3 + (image_index % 3);
}

// Mantém dentro da sala
x = clamp(x, 10, room_width - 10);
y = clamp(y, 10, room_height - 10);

// Garante que a vida não fique fora dos limites
vida = clamp(vida, 0, vida_maxima);
