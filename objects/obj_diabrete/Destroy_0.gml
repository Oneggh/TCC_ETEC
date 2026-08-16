/// @description Avisa a Vāelith que o invocou que este diabrete não está mais ativo
if(instance_exists(dono)) {
    dono.diabretes_vivos = max(dono.diabretes_vivos - 1, 0);
}
