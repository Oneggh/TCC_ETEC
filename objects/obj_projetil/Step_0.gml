/// @description Acompanha o jogador, gera o efeito glitch em linha reta e aplica dano

// Acompanha a posição de quem disparou (jogador ou clone);
// a direção NÃO muda depois de disparada — o raio vai reto, sem perseguir o alvo
if(origem != noone && instance_exists(origem)) {
    x = origem.x;
    y = origem.y;
} else {
    instance_destroy();
    exit;
}

// Reembaralha a forma "quebrada" do raio só de vez em quando — não a cada frame.
// É isso que faz ele parecer um raio de verdade (uma forma sólida que pisca) em vez
// de vibrar feito estática a 60 quadros por segundo
timer_glitch_shape--;
var regenerar_forma = (timer_glitch_shape <= 0);
if(regenerar_forma) {
    timer_glitch_shape = intervalo_glitch_shape;
}

// Gera os segmentos glitch ao longo da linha reta
for(var i = 0; i <= segmentos; i++) {
    var t = i / segmentos;
    var base_x = x + lengthdir_x(comprimento * t, direcao);
    var base_y = y + lengthdir_y(comprimento * t, direcao);

    if(regenerar_forma) {
        var glitch_intensity = t * caos * 3;
        var angulo_glitch = random(360);
        var dist_glitch = random(glitch_intensity);

        desvio_x[i] = lengthdir_x(dist_glitch, angulo_glitch);
        desvio_y[i] = lengthdir_y(dist_glitch, angulo_glitch);
    }

    pontos[i] = {
        x: base_x + desvio_x[i],
        y: base_y + desvio_y[i]
    };
}

// Tempo de vida do raio
tempo_vida--;
if(tempo_vida <= 0) {
    instance_destroy();
    exit;
}

// --- DANO ---
if(dano_continuo) {
    // Fagulhas retangulares RGB saindo do raio (só visual, efeito do M2)
    timer_faisca++;
    if(timer_faisca >= intervalo_faisca) {
        timer_faisca = 0;

        var idx = irandom(segmentos);
        var p = pontos[idx];

        var faisca = instance_create_depth(p.x, p.y, 0, obj_faisca_rgb);
        faisca.cor_faisca = cores_faisca[irandom(array_length(cores_faisca) - 1)];

        var ang_faisca = random(360);
        var vel_faisca = 1 + random(2.5);
        faisca.vel_x = lengthdir_x(vel_faisca, ang_faisca);
        faisca.vel_y = lengthdir_y(vel_faisca, ang_faisca);
    }

    // Variante "dano contínuo" (M2): fere periodicamente quem estiver tocando o feixe
    timer_dano++;
    if(timer_dano >= intervalo_dano) {
        timer_dano = 0;

        with(obj_inimigo) {
            for(var i = 0; i < other.segmentos; i++) {
                if(point_distance(x, y, other.pontos[i].x, other.pontos[i].y) < 30) {
                    vida = max(vida - other.dano_por_frame, 0);

                    invulneravel = true;
                    invulneravel_timer = 5;

                    piscadas_restantes = 6;
                    timer_efeito_acerto = 9;
                    image_blend = c_lime;

                    if(other.ataque_maximo && random(100) < 50) {
                        efeito_lentidao = true;
                        timer_lentidao = 180;
                    }

                    instance_create_depth(other.pontos[i].x, other.pontos[i].y, 0, obj_efeito_acerto);

                    // --- EMPURRÃO FORTE E PERIÓDICO ---
                    // Acumula tempo real de contato (em vez de um timer cego que podia "perder"
                    // o inimigo se ele não estivesse tocando o feixe bem no instante do check)
                    other.timer_knockback += other.intervalo_dano;
                    if(other.timer_knockback >= other.intervalo_knockback) {
                        other.timer_knockback = 0;

                        var novo_x = x + lengthdir_x(other.forca_empurrao, other.direcao);
                        var novo_y = y + lengthdir_y(other.forca_empurrao, other.direcao);
                        if (!place_meeting(novo_x, novo_y, obj_bloqueio)) {
                            x = novo_x;
                            y = novo_y;
                        }

                        // Impacto visual maior, marcando o empurrão forte
                        instance_create_depth(x, y, 0, obj_explosao_glitch);
                    }

                    break;
                }
            }
        }
    }
} else if(!hit_unico_aplicado) {
    // Variante "raio único": aplica dano uma única vez, assim que o feixe surge
    hit_unico_aplicado = true;

    with(obj_inimigo) {
        for(var i = 0; i < other.segmentos; i++) {
            if(point_distance(x, y, other.pontos[i].x, other.pontos[i].y) < 30) {
                vida = max(vida - other.dano_por_frame * 5, 0);

                invulneravel = true;
                invulneravel_timer = 5;

                piscadas_restantes = 10;
                timer_efeito_acerto = 9;
                image_blend = c_lime;

                if(other.ataque_maximo && random(100) < 50) {
                    efeito_lentidao = true;
                    timer_lentidao = 180;
                }

                x += random(10) - 5;
                y += random(10) - 5;

                repeat(6) {
                    instance_create_depth(other.pontos[i].x, other.pontos[i].y, 0, obj_efeito_acerto);
                }

                break;
            }
        }
    }
}
