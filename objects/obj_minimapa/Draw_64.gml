var p = instance_find(obj_player_1, 0);
if (p == noone) exit;

// Verifica se o sprite do mapa completo existe
if (!sprite_exists(minimap_sprite)) exit;

// Cria a surface do minimapa (se necessário)
if (!surface_exists(mini_surface))
    mini_surface = surface_create(mini_size, mini_size);

// Cria a máscara circular (se necessário)
if (!surface_exists(mini_mask) || mask_size != mini_size)
{
    if (surface_exists(mini_mask)) surface_free(mini_mask);
    mini_mask = surface_create(mini_size, mini_size);
    mask_size = mini_size;
    
    surface_set_target(mini_mask);
    draw_clear_alpha(c_black, 0);
    draw_set_color(c_white);
    draw_circle(mini_size * 0.5, mini_size * 0.5, mini_size * 0.5, false);
    surface_reset_target();
}

// Desenha na surface do minimapa
surface_set_target(mini_surface);
draw_clear_alpha(c_black, 0);

var cx = mini_size * 0.5;
var cy = mini_size * 0.5;

// Calcula a escala base (sem zoom) e aplica o zoom
var base_scale = mini_size / (visible_tiles * tile_size);
var final_scale = base_scale * zoom_level;

// Usa o primeiro tilemap válido como referência para o offset
var ref_tilemap = noone;
for (var i = 0; i < array_length(tilemap_ids); i++)
{
    if (tilemap_ids[i] != noone)
    {
        ref_tilemap = tilemap_ids[i];
        break;
    }
}
if (ref_tilemap == noone) exit;

var tmx = tilemap_get_x(ref_tilemap);
var tmy = tilemap_get_y(ref_tilemap);

// Posição do jogador no mapa completo (em pixels)
var player_map_x = p.x - tmx;
var player_map_y = p.y - tmy;

// Desenha o fundo circular
draw_set_color(make_color_rgb(20,20,20));
draw_circle(cx, cy, mini_size * 0.5, false);

// Desenha o SPRITE do mapa completo (mais estável que surface)
if (sprite_exists(minimap_sprite))
{
    draw_sprite_ext(minimap_sprite, 0, 
        cx - (player_map_x * final_scale),
        cy - (player_map_y * final_scale),
        final_scale, final_scale, 0, c_white, 1);
}

// Desenha o jogador no centro (CABEÇA ANIMADA)
if (p != noone)
{
    // Tamanho que a cabeça vai aparecer no minimapa (ajuste)
    var head_size = 10;  // 8-12 pixels geralmente fica bom
    
    // Desenha a cabeça no centro do minimapa usando o sprite spr_ggh_head
    draw_sprite_ext(spr_ggh_head, p.image_index,
                    mini_x + cx,  // Centro X do minimapa
                    mini_y + cy,  // Centro Y do minimapa
                    head_size / 16,  // Escala X (32 é o tamanho original)
                    head_size / 16,  // Escala Y
                    0, c_white, 1);
}

// Aplica a máscara circular
gpu_set_blendmode_ext(bm_zero, bm_src_alpha);
draw_surface(mini_mask, 0, 0);
gpu_set_blendmode(bm_normal);

surface_reset_target();

// Desenha o minimapa na tela
draw_surface(mini_surface, mini_x, mini_y);

// Desenha a borda circular
draw_set_color(c_white);
draw_circle(mini_x + cx, mini_y + cy, cx, true);

// Desenha a borda por cima (com blend mode para transparência)
gpu_set_blendmode(bm_normal);
draw_sprite(spr_minimapa_borda, 0, mini_x, mini_y);