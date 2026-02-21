cam = view_camera[0];

base_w = 1366  // largura da sua resolução
base_h = 768;   // altura da sua resolução

zoom = 4; // 2 = tudo fica 2x maior (zoom in)

camera_set_view_size(cam, base_w/zoom, base_h/zoom);