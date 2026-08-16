/// @description Inicializa o raio (ajustado por quem o disparou: M1/M2 do jogador ou o clone)

// Direção fixa do raio — definida uma única vez na criação, não persegue o alvo
direcao = 0;
comprimento = 150;
espessura_base = 8;
dano_por_frame = 1;

// Variante do ataque:
// dano_continuo = true  -> feixe duradouro que fere repetidamente quem ficar nele
// dano_continuo = false -> hit único e instantâneo (raio rápido)
dano_continuo = false;
tempo_vida = 10;
intervalo_dano = 6;
timer_dano = 0;
hit_unico_aplicado = false;

// Empurrão periódico (só usado quando dano_continuo = true, ou seja, no M2)
forca_empurrao = 14;
intervalo_knockback = 120; // a cada ~2s
timer_knockback = 0;

// Fagulhas retangulares RGB saindo do raio (só usado quando dano_continuo = true, no M2)
timer_faisca = 0;
intervalo_faisca = 6;
cores_faisca = [c_red, c_lime, c_blue];

// Estado do ataque (ajustado por quem disparou)
ataque_maximo = false;
intensidade_glitch = 3;
caos = 2;

// Inimigo mirado no momento do disparo (só usado para o brilho visual no alvo)
alvo = noone;

// Quem disparou o raio (obj_player_1 ou obj_clone) — o raio acompanha essa instância
origem = noone;

// Deslocamento do ponto de origem em relação a quem disparou (ex: altura do notebook no peito)
offset_x = 0;
offset_y = 0;

// Efeito visual: o raio não é desenhado como linha — é uma nuvem de mini triângulos e
// quadrados RGB ao longo do trajeto, cada um com cor própria e independente (ver Draw_0)
segmentos = 20;
pontos = array_create(segmentos + 1);
cores_fragmento = [c_red, c_lime, c_blue];

// Desvio "quebrado" de cada ponto em relação à linha reta. Fica guardado e só é
// reembaralhado a cada poucos frames (ver intervalo_glitch_shape), pra o raio parecer
// um raio de verdade (forma sólida que pisca) em vez de vibrar feito estática
desvio_x = array_create(segmentos + 1, 0);
desvio_y = array_create(segmentos + 1, 0);
timer_glitch_shape = 0;
intervalo_glitch_shape = 4;

// Preenche pontos com uma linha reta válida (evita crash caso o Draw rode antes
// do primeiro Step desta instância, o que acontece no frame em que ela é criada)
for (var i = 0; i <= segmentos; i++) {
    var t = i / segmentos;
    pontos[i] = {
        x: x + lengthdir_x(comprimento * t, direcao),
        y: y + lengthdir_y(comprimento * t, direcao)
    };
}
