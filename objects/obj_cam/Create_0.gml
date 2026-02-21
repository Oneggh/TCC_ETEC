view_enabled = true;
view_visible[0] = true;

window_w = 1280;
window_h = 720;

zoom = 2;

cam = camera_create_view(
    0, 0,
    window_w/zoom,
    window_h/zoom,
    0,
    -1, -1, -1, -1
);

view_camera[0] = cam;