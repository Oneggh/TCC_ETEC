/// @description Espelha a stamina do jogador só para exibição.
/// O jogador (obj_player_1) é a única fonte de verdade da stamina — ele mesmo cuida do
/// gasto (correr, dash, M2) e da recuperação. Este objeto NUNCA escreve de volta nele,
/// senão os dois sistemas de recuperação brigam entre si (foi exatamente esse o bug que
/// fazia o M2 parecer não gastar stamina: este objeto reenchia por trás).
if(instance_exists(jogador)) {
    stamina_atual = jogador.Stamina;
    stamina_maxima = jogador.Stamina_maxima;
}

// Garante que stamina não ultrapasse os limites
stamina_atual = clamp(stamina_atual, 0, stamina_maxima);