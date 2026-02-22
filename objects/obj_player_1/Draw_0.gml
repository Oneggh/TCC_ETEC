
// Desenha o personagem
draw_self();

/* HITBOX APENAS ATIVAR EM TESTES

// Desenha a ORIGEM (ponto central) - VERDE
draw_set_color(c_lime);
draw_circle(x, y, 3, false);

// Desenha a CAIXA DE COLISÃO - VERMELHO
draw_set_color(c_red);
draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, true);

// Desenha os LIMITES DO SPRITE - AZUL
draw_set_color(c_blue);
draw_rectangle(x - sprite_xoffset, y - sprite_yoffset, 
               x - sprite_xoffset + sprite_width, 
               y - sprite_yoffset + sprite_height, true);