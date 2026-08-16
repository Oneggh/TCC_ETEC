/// @description Sombras suaves de sol alto (borda macia, curtas — nada de sombra dura tipo recorte)

// Fica atrás das construções/árvores (depth maior) mas na frente do chão (tiles ~1800+)
depth = 1000;

// Sol alto e um pouco à esquerda: a sombra cai curta pra direita e pra baixo
desloc_x = 12;
desloc_y = 5;

alpha_sombra = 0.20;

// Quem projeta sombra (só cenário — personagens e HUD não são tocados)
alvos_sombra = [
    obj_casa_madeira,
    obj_casa_tijolo,
    obj_loja_geral,
    obj_arvore,
    obj_arbusto_flores,
    obj_poste,
    obj_banco,
    obj_placa,
];
