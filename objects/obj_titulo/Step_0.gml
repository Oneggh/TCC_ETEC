/// @description Anima o cristal/partículas e trata os cliques do menu

var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);
var _clicou = mouse_check_button_pressed(mb_left);
var _soltou = mouse_check_button_released(mb_left);
var _pode_interagir = (fade_modo != "saindo");

var _l = calcular_layout();

// ================= CRISTAL =================
cristal_escala_alvo = (estado == "cristal") ? 1 : 0.7;
cristal_escala += (cristal_escala_alvo - cristal_escala) * 0.08;
cristal_bob_y = sin(current_time * 0.0016) * 10;

// Balanço suave (o sprite é 2D, então em vez de girar 360 ele "respira" de leve)
cristal_rotacao = sin(current_time * 0.0009) * 7;

// Brilho de hover: sobe suave quando o mouse passa por cima, e a gema "olha" pro cursor
var _sobre_cristal = (estado == "cristal")
    && (point_distance(_mx, _my, _l.cristal_x, _l.cristal_y + cristal_bob_y) <= cristal_raio * 1.3);
cristal_hover_glow += ((_sobre_cristal ? 1 : 0) - cristal_hover_glow) * 0.12;

var _tilt_alvo_x = _sobre_cristal ? clamp((_mx - _l.cristal_x) / cristal_raio, -1, 1) * 8 : 0;
var _tilt_alvo_y = _sobre_cristal ? clamp((_my - (_l.cristal_y + cristal_bob_y)) / cristal_raio, -1, 1) * 8 : 0;
cristal_tilt_x += (_tilt_alvo_x - cristal_tilt_x) * 0.15;
cristal_tilt_y += (_tilt_alvo_y - cristal_tilt_y) * 0.15;

// Anéis de energia do clique (decaem e somem)
for (var i = array_length(cliques_efeito) - 1; i >= 0; i--) {
    cliques_efeito[i].vida++;
    if (cliques_efeito[i].vida >= cliques_efeito[i].vida_max) array_delete(cliques_efeito, i, 1);
}

// ================= PARTÍCULAS (sparkles ao redor do cristal) =================
particula_timer--;
if (particula_timer <= 0 && cristal_escala > 0.4) {
    particula_timer = irandom_range(4, 10);

    var _ang = random(360);
    var _dist = random_range(10, cristal_raio * 0.9);
    var _p = {
        x: _l.cristal_x + lengthdir_x(_dist, _ang),
        y: _l.cristal_y + cristal_bob_y + lengthdir_y(_dist, _ang),
        vx: random_range(-0.3, 0.3),
        vy: random_range(-0.9, -0.3),
        vida: 0,
        vida_max: random_range(40, 80),
        tam: random_range(1.5, 3.5),
    };
    array_push(particulas, _p);
}

for (var i = array_length(particulas) - 1; i >= 0; i--) {
    var _p = particulas[i];
    _p.x += _p.vx;
    _p.y += _p.vy;
    _p.vida++;
    if (_p.vida >= _p.vida_max) {
        array_delete(particulas, i, 1);
    }
}

// ================= FADE DE SALA =================
if (fade_modo == "entrando") {
    fade_timer++;
    fade_alpha = 1 - (fade_timer / fade_duracao);
    if (fade_timer >= fade_duracao) {
        fade_alpha = 0;
        fade_modo = "nenhum";
    }
} else if (fade_modo == "saindo") {
    fade_timer++;
    fade_alpha = fade_timer / fade_duracao;
    if (fade_timer >= fade_duracao) {
        room_goto(fade_destino);
    }
}

// ================= INTERAÇÃO POR ESTADO =================
menu_hover = -1;
saves_hover = -1;
saves_voltar_hover = false;
opcoes_voltar_hover = false;
opcoes_fullscreen_hover = false;

if (estado == "cristal") {
    if (_pode_interagir && _sobre_cristal && _clicou) {
        estado = "menu";
        menu_abertura = 0;

        // Anel de energia + estilhaços de luz ao "despertar" o cristal
        var _cx_click = _l.cristal_x;
        var _cy_click = _l.cristal_y + cristal_bob_y;
        array_push(cliques_efeito, { x: _cx_click, y: _cy_click, vida: 0, vida_max: 36 });
        repeat(18) {
            var _ang_est = random(360);
            array_push(particulas, {
                x: _cx_click, y: _cy_click,
                vx: lengthdir_x(random_range(1.5, 4), _ang_est),
                vy: lengthdir_y(random_range(1.5, 4), _ang_est),
                vida: 0, vida_max: random_range(30, 55),
                tam: random_range(1.5, 3.5),
            });
        }
    }
} else if (estado == "menu") {
    menu_abertura = min(1, menu_abertura + 0.08);

    for (var i = 0; i < array_length(_l.menu_rects); i++) {
        var _r = _l.menu_rects[i];
        if (_mx >= _r.x1 && _mx <= _r.x2 && _my >= _r.y1 && _my <= _r.y2) {
            menu_hover = i;
            if (_pode_interagir && _clicou) {
                switch (i) {
                    case 0: // Iniciar
                        fade_modo = "saindo";
                        fade_timer = 0;
                        fade_destino = Teste;
                        break;
                    case 1: // Saves
                        estado = "saves";
                        break;
                    case 2: // Opções
                        estado = "opcoes";
                        break;
                    case 3: // Sair
                        game_end();
                        break;
                }
            }
        }
    }
} else if (estado == "saves") {
    for (var i = 0; i < array_length(_l.slot_rects); i++) {
        var _r = _l.slot_rects[i];
        if (_mx >= _r.x1 && _mx <= _r.x2 && _my >= _r.y1 && _my <= _r.y2) {
            saves_hover = i;
            var _slot = i + 1;
            if (_pode_interagir && _clicou && scr_save_exists(_slot)) {
                scr_save_load(_slot);
            }
        }
    }

    var _rv = _l.saves_voltar;
    if (_mx >= _rv.x1 && _mx <= _rv.x2 && _my >= _rv.y1 && _my <= _rv.y2) {
        saves_voltar_hover = true;
        if (_pode_interagir && _clicou) estado = "menu";
    }
} else if (estado == "opcoes") {
    if (_pode_interagir && _clicou && opcoes_slider_arrastando == -1) {
        if (_my >= _l.slider_musica_y - 14 && _my <= _l.slider_musica_y + 14 && _mx >= _l.slider_x1 - 10 && _mx <= _l.slider_x2 + 10) {
            opcoes_slider_arrastando = 0;
        } else if (_my >= _l.slider_sfx_y - 14 && _my <= _l.slider_sfx_y + 14 && _mx >= _l.slider_x1 - 10 && _mx <= _l.slider_x2 + 10) {
            opcoes_slider_arrastando = 1;
        }
    }

    if (opcoes_slider_arrastando != -1) {
        var _v = clamp((_mx - _l.slider_x1) / _l.slider_w, 0, 1);
        if (opcoes_slider_arrastando == 0) global.opt_musica = _v;
        else global.opt_sfx = _v;

        if (_soltou) {
            opcoes_slider_arrastando = -1;
            scr_options_save();
        }
    }

    var _cb = _l.checkbox;
    if (_mx >= _cb.x1 - 100 && _mx <= _cb.x2 + 10 && _my >= _cb.y1 - 6 && _my <= _cb.y2 + 6) {
        opcoes_fullscreen_hover = true;
        if (_pode_interagir && _clicou) {
            global.opt_fullscreen = !global.opt_fullscreen;
            window_set_fullscreen(global.opt_fullscreen);
            scr_options_save();
        }
    }

    var _rv2 = _l.opcoes_voltar;
    if (_mx >= _rv2.x1 && _mx <= _rv2.x2 && _my >= _rv2.y1 && _my <= _rv2.y2) {
        opcoes_voltar_hover = true;
        if (_pode_interagir && _clicou) {
            opcoes_slider_arrastando = -1;
            estado = "menu";
        }
    }
}
