/// @description Movimento da partícula de sangue (desacelera e some)
x += vel_x;
y += vel_y;
vel_x *= 0.9;
vel_y *= 0.9;

tempo_vida--;
if(tempo_vida <= 0) instance_destroy();
