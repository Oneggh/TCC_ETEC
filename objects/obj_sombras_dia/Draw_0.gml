/// @description Desenha uma elipse borrada na base de cada objeto de cenário

// spr_glow é um gradiente radial branco com origem no centro — tingido de preto e
// achatado, vira exatamente uma sombra de borda suave (sem serrilhado duro).
var _n = array_length(alvos_sombra);

for (var i = 0; i < _n; i++) {
    with (alvos_sombra[i]) {
        // Acompanha o tamanho real do objeto na tela (respeita a escala da instância)
        var _larg = sprite_width * 0.72;
        var _alt  = _larg * 0.26; // sol alto = sombra curta

        draw_sprite_ext(
            spr_glow, 0,
            x + other.desloc_x,
            y + other.desloc_y,
            _larg / sprite_get_width(spr_glow),
            _alt / sprite_get_height(spr_glow),
            0,
            c_black,
            other.alpha_sombra
        );
    }
}
