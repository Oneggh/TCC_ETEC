// DRAW GUI
// Pega a vida do personagem
if(instance_exists(obj_player_1)) {
    with(obj_player_1) {
        obj_vida.vida_atual = Vida;
    }
}

// --- DIVISÃO IGUALITÁRIA COM CÁLCULO PRECISO ---
// Para 20 frames, cada frame = 5% de vida
// Mas podemos fazer um mapeamento mais suave

// Calcula o percentual
var percentual = (vida_atual / vida_maxima) * 100;

// Converte percentual para frame (0-19)
// 100% -> frame 0
// 95% -> frame 1
// 90% -> frame 2
// 85% -> frame 3
// ...
// 5% -> frame 19
// 0% -> frame 19

var frame_vida = floor((100 - percentual) / 5);

// Ajustes para valores extremos
if(percentual >= 100) frame_vida = 0;
if(percentual <= 5) frame_vida = 19;

// Garante que está dentro dos limites
var total_frames = sprite_get_number(spr_vida);
frame_vida = clamp(frame_vida, 0, total_frames - 1);

// Desenha
draw_sprite_ext(spr_vida, frame_vida, pos_x, pos_y, escala_vida, escala_vida, 0, c_white, 1);