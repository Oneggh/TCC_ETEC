/// @description Desenha o personagem e interfaces

// --- GLOW PULSANTE EM MODO COMBATE (silhueta translúcida atrás do personagem) ---
if(modo_atual == "combate") {
    var pulso_glow = 0.5 + 0.5 * sin(current_time * 0.006);
    var cor_glow = canalizando_m2 ? c_aqua : c_lime;

    draw_sprite_ext(sprite_index, image_index, x, y,
                    image_xscale * 1.12, image_yscale * 1.12,
                    image_angle, cor_glow, 0.12 + pulso_glow * 0.13);
}

// --- INDICADOR DE STAMINA DO M2 (aparece enquanto o raio está canalizado) ---
if(modo_atual == "combate" && canalizando_m2) {
    var stamina_pct = Stamina / Stamina_maxima;

    var barra_x = x + 20;
    var barra_y = y - 50;

    draw_set_color(c_aqua);
    draw_set_alpha(0.8);
    draw_rectangle(barra_x, barra_y, barra_x + 40 * stamina_pct, barra_y + 5, false);
    draw_set_alpha(1);
}

// Desenha o personagem
draw_self();

// Indicador de cooldown do dash
if (!dash_disponivel) {
    var cooldown_progress = dash_timer / dash_cooldown;
    draw_set_color(c_red);
    draw_rectangle(x - 20, y - 40, x - 20 + (40 * cooldown_progress), y - 35, false);
}

// Indicador de modo atual (pequeno texto)
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_text(x, y - 120, string_upper(modo_atual));