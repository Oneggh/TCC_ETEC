mini_size = 256;
mini_x = 20;
mini_y = 20;

tile_size = 16;

// Controles separados:
visible_tiles = 30;        // Quantos tiles cabem na largura do minimapa (ÁREA VISÍVEL)
zoom_level = 0.8          // Zoom visual (1.0 = normal, 2.0 = 2x maior)

// Surface do minimapa (a que será mostrada)
mini_surface = -1;

// Sprite do mapa COMPLETO (mais estável que surface)
minimap_sprite = -1;
fullmap_created = false;

// Máscara circular
mini_mask = -1;
mask_size = 0;

// Lista de nomes dos tilemaps (CORRIGIDA!)
tilemap_names = [
    "Terreno1",
    "Terreno2",
    "Terreno3",
    "Terreno4",
    "Terreno5",
    "Ts_Arbustos",
    "Ts_arbusto2"
];

// Array para armazenar os IDs dos tilemaps
tilemap_ids = array_create(array_length(tilemap_names), noone);