// PEGAR OS IDs DOS TILEMAPS (sempre atualiza)
for (var i = 0; i < array_length(tilemap_names); i++)
{
    tilemap_ids[i] = layer_tilemap_get_id(tilemap_names[i]);
    if (tilemap_ids[i] == noone)
    {
        show_debug_message("Aviso: Tilemap não encontrado: " + tilemap_names[i]);
    }
}

// Verifica se o sprite do mapa completo já existe
if (!sprite_exists(minimap_sprite))
{
    // Encontra um tilemap de referência (o primeiro válido)
    var ref_tilemap = noone;
    for (var i = 0; i < array_length(tilemap_ids); i++)
    {
        if (tilemap_ids[i] != noone)
        {
            ref_tilemap = tilemap_ids[i];
            break;
        }
    }
    
    if (ref_tilemap != noone)
    {
        // Pega dimensões do tilemap
        var tilemap_w = tilemap_get_width(ref_tilemap);
        var tilemap_h = tilemap_get_height(ref_tilemap);
        
        // Tamanho TOTAL do mapa em pixels
        var map_width = tilemap_w * tile_size;
        var map_height = tilemap_h * tile_size;
        
        show_debug_message("Criando mapa completo: " + string(map_width) + "x" + string(map_height));
        
        // CRIA UMA SUPERFÍCIE TEMPORÁRIA
        var temp_surface = surface_create(map_width, map_height);
        
        if (surface_exists(temp_surface))
        {
            surface_set_target(temp_surface);
            draw_clear_alpha(c_black, 0);
            
            // Desenha TODOS os tilemaps na superfície temporária
            for (var i = 0; i < array_length(tilemap_ids); i++)
            {
                var tm = tilemap_ids[i];
                if (tm != noone)
                {
                    var tmx = tilemap_get_x(tm);
                    var tmy = tilemap_get_y(tm);
                    draw_tilemap(tm, tmx, tmy);
                }
            }
            
            surface_reset_target();
            
            // CONVERTE A SUPERFÍCIE PARA SPRITE
            minimap_sprite = sprite_create_from_surface(temp_surface, 0, 0, map_width, map_height, false, false, 0, 0);
            
            // LIBERA A SUPERFÍCIE TEMPORÁRIA
            surface_free(temp_surface);
            
            if (sprite_exists(minimap_sprite))
            {
                fullmap_created = true;
                show_debug_message("Mapa completo convertido para SPRITE com sucesso!");
            }
            else
            {
                show_debug_message("ERRO: Não foi possível criar o sprite!");
            }
        }
        else
        {
            show_debug_message("ERRO: Não foi possível criar a superfície temporária!");
        }
    }
    else
    {
        show_debug_message("ERRO: Nenhum tilemap válido encontrado!");
    }
}
else
{
    show_debug_message("Sprite já existe, reutilizando...");
}