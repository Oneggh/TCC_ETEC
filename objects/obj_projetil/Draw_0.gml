/// @description Desenha o raio como uma nuvem de mini triângulos e quadrados RGB — não é uma
/// linha sólida: cada fragmento sorteia sua própria cor todo frame, sem sincronia com os outros

var alpha = clamp(tempo_vida / 10, 0, 1);
var n = min(segmentos, array_length(pontos) - 1);

// No M2 (dano contínuo), os fragmentos crescem um pouco conforme se aproxima do
// próximo empurrão, avisando visualmente que o "soco" está chegando
var pulso = 1;
if(dano_continuo && intervalo_knockback > 0) {
    var progresso_kb = timer_knockback / intervalo_knockback;
    pulso = 1 + (progresso_kb * progresso_kb) * 0.8;
}

var tamanho_base = max(espessura_base * 0.5, 3) * (ataque_maximo ? 1.4 : 1) * pulso;

draw_set_alpha(alpha);

// 1 fragmento a cada 2 pontos do trajeto (menos poluído que antes), cada um com
// posição, tamanho, forma e cor sorteados de forma independente — sem sincronia
for(var i = 0; i <= n; i += 2) {
    var px = pontos[i].x;
    var py = pontos[i].y;

    var offset_ang = random(360);
    var offset_dist = random(tamanho_base * 1.1);
    var fx = px + lengthdir_x(offset_dist, offset_ang);
    var fy = py + lengthdir_y(offset_dist, offset_ang);

    var tam = tamanho_base * (0.6 + random(0.7));

    draw_set_color(cores_fragmento[irandom(array_length(cores_fragmento) - 1)]);

    if(irandom(1) == 0) {
        // Quadrado
        draw_rectangle(fx - tam * 0.5, fy - tam * 0.5, fx + tam * 0.5, fy + tam * 0.5, false);
    } else {
        // Triângulo
        draw_triangle(fx, fy - tam * 0.6, fx - tam * 0.6, fy + tam * 0.5, fx + tam * 0.6, fy + tam * 0.5, false);
    }
}

draw_set_alpha(1);

// Brilho verde no alvo travado
if(alvo != noone && instance_exists(alvo)) {
    if(distance_to_object(alvo) < comprimento) {
        draw_set_color(c_lime);
        draw_set_alpha(0.3);
        draw_circle(alvo.x, alvo.y, 40, true);
        draw_set_alpha(1);
    }
}
