// --- MOVIMENTAÇÃO COM COLISÃO ---
var dir_x = 0;
var dir_y = 0;

if keyboard_check(vk_right) || keyboard_check(ord("D")) dir_x = 1;
if keyboard_check(vk_left)  || keyboard_check(ord("A")) dir_x = -1;
if keyboard_check(vk_down)  || keyboard_check(ord("S")) dir_y = 1;
if keyboard_check(vk_up)    || keyboard_check(ord("W")) dir_y = -1;

// Move na horizontal com colisão
if (dir_x != 0) {
    // Verifica se tem colisão na direção que quer ir
    if (!place_meeting(x + dir_x * speed_walk, y, obj_bloqueio)) {
        x += dir_x * speed_walk;
    }
}

// Move na vertical com colisão  
if (dir_y != 0) {
    if (!place_meeting(x, y + dir_y * speed_walk, obj_bloqueio)) {
        y += dir_y * speed_walk;
    }
}

// --- ANIMAÇÃO COM IDLE NA CAMINHADA ---
var andando = (dir_x != 0 or dir_y != 0);

if (andando) {
    // Velocidade da animação (ajuste conforme necessário)
    image_speed = 0.3;
    
    // BAIXO (S) - frames 0,1,2
    if (dir_y > 0) {
        image_index = 0 + (image_index % 3);
        direcao_atual = 0;
    }
    // CIMA (W) - frames 9,10,11
    else if (dir_y < 0) {
        image_index = 9 + (image_index % 3);
        direcao_atual = 3;
    }
    // ESQUERDA (A) - frames 3,4,5
    else if (dir_x < 0) {
        image_index = 3 + (image_index % 3);
        direcao_atual = 1;
    }
    // DIREITA (D) - frames 6,7,8
    else if (dir_x > 0) {
        image_index = 6 + (image_index % 3);
        direcao_atual = 2;
    }
    
} else {
    // PARADO - mostra APENAS o frame idle (frame do meio)
    image_speed = 0;
    
    if (direcao_atual == 0) image_index = 1;   // Baixo idle
    else if (direcao_atual == 1) image_index = 4;  // Esquerda idle
    else if (direcao_atual == 2) image_index = 7;  // Direita idle
    else if (direcao_atual == 3) image_index = 10; // Cima idle
}