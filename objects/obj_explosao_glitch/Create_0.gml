/// @description Burst visual do ataque básico M1 — só efeito, o dano já foi aplicado na criação

raio_max = 55;
tempo_vida = 14;
tempo_vida_max = tempo_vida;

cores = [c_lime, c_aqua, c_fuchsia, c_white, c_yellow];

// Estilhaços glitch que disparam para fora do centro, distribuídos ao redor com um pouco de caos
num_estilhacos = 10;
angulos_estilhaco = array_create(num_estilhacos);
for (var i = 0; i < num_estilhacos; i++) {
    angulos_estilhaco[i] = (360 / num_estilhacos) * i + random(20) - 10;
}
