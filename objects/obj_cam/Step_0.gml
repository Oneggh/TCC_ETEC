if (instance_exists(obj_player_1))
{
    camera_set_view_pos(cam,
        obj_player_1.x - camera_get_view_width(cam)/2,
        obj_player_1.y - camera_get_view_height(cam)/2
    );
}

// ===== MINIMAPA (camera 1, sem zoom) =====
var p = instance_find(obj_player_1, 0);
if (p != noone) {
    var cam1 = view_camera[1];

    // segue o player no minimapa
    camera_set_view_pos(cam1,
        p.x - camera_get_view_width(cam1) * 0.5,
        p.y - camera_get_view_height(cam1) * 0.5
    );
}