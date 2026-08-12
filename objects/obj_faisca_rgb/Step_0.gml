/// @description Voa, desacelera e desvanece

x += vel_x;
y += vel_y;

vel_x *= 0.88;
vel_y *= 0.88;

tempo_vida--;
if(tempo_vida <= 0) {
    instance_destroy();
}
