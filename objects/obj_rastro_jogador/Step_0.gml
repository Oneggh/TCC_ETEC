/// @description Desvanece e se destrói

tempo_vida--;
image_alpha = alpha_inicial * (tempo_vida / 10);

if(tempo_vida <= 0) {
    instance_destroy();
}
