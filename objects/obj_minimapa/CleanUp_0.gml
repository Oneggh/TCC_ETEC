// Libera o sprite quando o objeto for destruído
if (sprite_exists(minimap_sprite))
{
    sprite_delete(minimap_sprite);
}

// Libera as surfaces se existirem
if (surface_exists(mini_surface))
{
    surface_free(mini_surface);
}

if (surface_exists(mini_mask))
{
    surface_free(mini_mask);
}