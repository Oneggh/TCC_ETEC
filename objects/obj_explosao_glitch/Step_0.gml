/// @description Controla o tempo de vida do burst

tempo_vida--;
if(tempo_vida <= 0) {
    instance_destroy();
}
