/// @description Banho de luz solar quente e suave sobre a cena inteira

var _cam = view_camera[0];
var vx = camera_get_view_x(_cam);
var vy = camera_get_view_y(_cam);
var vw = camera_get_view_width(_cam);
var vh = camera_get_view_height(_cam);

// Aditivo em alpha baixo: clareia e esquenta a cena sem estourar as cores
gpu_set_blendmode(bm_add);
draw_set_colour(cor_sol);
draw_set_alpha(alpha_sol);
draw_rectangle(vx, vy, vx + vw, vy + vh, false);
gpu_set_blendmode(bm_normal);

draw_set_alpha(1);
draw_set_colour(c_white);
