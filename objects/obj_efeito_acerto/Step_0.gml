/// @description Movimento da partícula
x += vel_x;
y += vel_y;
tempo_vida--;
if(tempo_vida <= 0) instance_destroy();