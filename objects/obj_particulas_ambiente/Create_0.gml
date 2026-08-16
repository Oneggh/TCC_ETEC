/// @description Partículas de dia ensolarado: pólen/poeira flutuando na luz sobre a cidade

depth = -110000; // na frente de tudo, inclusive do banho de luz

sistema_amb = part_system_create();
part_system_depth(sistema_amb, depth);

// --- Pólen: pontinhos quentes que sobem/derivam devagar, opacidade variável ---
pt_polen = part_type_create();
part_type_shape(pt_polen, pt_shape_disk);
part_type_size(pt_polen, 0.04, 0.10, 0, 0.001);
part_type_colour2(pt_polen, make_colour_rgb(255, 246, 205), make_colour_rgb(232, 226, 160));
part_type_alpha3(pt_polen, 0, 0.55, 0);      // nasce e some suave, nunca "pisca"
part_type_speed(pt_polen, 0.15, 0.5, 0, 0.02);
part_type_direction(pt_polen, 20, 90, 0, 6); // brisa subindo pra direita, com balanço
part_type_life(pt_polen, 240, 420);

// --- Poeirinha mais fina, ainda mais sutil, dando profundidade ao ar ---
pt_poeira = part_type_create();
part_type_shape(pt_poeira, pt_shape_pixel);
part_type_size(pt_poeira, 0.5, 1.2, 0, 0);
part_type_colour1(pt_poeira, make_colour_rgb(255, 252, 235));
part_type_alpha3(pt_poeira, 0, 0.3, 0);
part_type_speed(pt_poeira, 0.1, 0.35, 0, 0);
part_type_direction(pt_poeira, 340, 30, 0, 4);
part_type_life(pt_poeira, 300, 500);

// Cobre toda a área da cidade
emissor_amb = part_emitter_create(sistema_amb);
part_emitter_region(sistema_amb, emissor_amb, 288, 2336, 256, 1152, ps_shape_rectangle, ps_distr_linear);
