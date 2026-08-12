/// @description Desenha a barra de stamina

// Verifica se o sprite existe
if(!sprite_exists(spr_stamina)) exit;

// Pega a stamina do jogador
if(instance_exists(jogador)) {
    with(jogador) {
        obj_stamina.stamina_atual = Stamina;
    }
}

// --- DIVISÃO IGUALITÁRIA PARA 23 FRAMES ---
// Cada frame representa aproximadamente 4.3478% da stamina (100 ÷ 23)
// Vamos usar 23 frames para representar de 100% até 0%

// Calcula o percentual de stamina
var percentual_stamina = (stamina_atual / stamina_maxima) * 100;

// Converte percentual para frame (0 a 22)
// Fórmula: frame = floor((100 - percentual_stamina) / (100/23))
// Simplificando: 100/23 ≈ 4.347826

var intervalo = 100 / 23;  // ≈ 4.3478
var frame_stamina = floor((100 - percentual_stamina) / intervalo);

// Ajustes para valores extremos
if(percentual_stamina >= 100) frame_stamina = 0;
if(percentual_stamina <= intervalo) frame_stamina = 22;  // Último frame

// Garante que está dentro dos limites
var total_frames = sprite_get_number(spr_stamina);
frame_stamina = clamp(frame_stamina, 0, total_frames - 1);


// Desenha o sprite de stamina
draw_sprite_ext(spr_stamina, frame_stamina, pos_x, pos_y, escala_stamina, escala_stamina, 0, c_white, 1);
/*
// (Opcional) Barra de progresso para debug
// Desenha um fundo para a barra
draw_set_color(c_black);
draw_rectangle(pos_x - 5, pos_y - 10, pos_x + 200, pos_y - 5, false);

// Desenha o progresso da stamina
var barra_largura = 200 * (stamina_atual / stamina_maxima);
draw_set_color(c_yellow);
draw_rectangle(pos_x - 5, pos_y - 10, pos_x - 5 + barra_largura, pos_y - 5, false);

// DEBUG - mostra valores
draw_set_color(c_white);
draw_text(200, 100, "Stamina: " + string(stamina_atual) + "/" + string(stamina_maxima));
draw_text(200, 120, "Percentual: " + string(percentual_stamina) + "%");
draw_text(200, 140, "Frame: " + string(frame_stamina) + "/" + string(total_frames - 1));
draw_text(200, 160, "Recuperando: " + string(recuperando));
