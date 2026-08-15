/// @description Abre/fecha o celular (tecla P) e trata os cliques

if (keyboard_check_pressed(ord("P"))) {
    estado = (estado == "fechado") ? "home" : "fechado";
}

global.celular_aberto = (estado != "fechado");

if (mensagem_timer > 0) {
    mensagem_timer--;
}

var _alvo_abertura = (estado == "fechado") ? 0 : 1;
abertura += (_alvo_abertura - abertura) * 0.25;

if (estado == "fechado") exit;

var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);
var _clicou = mouse_check_button_pressed(mb_left);

var _l = calcular_layout();

app_hover = -1;
menu_hover = -1;

// Botão de fechar (some pra tela inicial, ou fecha de vez se já estiver nela)
var _rf = _l.fechar;
if (_clicou && _mx >= _rf.x1 && _mx <= _rf.x2 && _my >= _rf.y1 && _my <= _rf.y2) {
    estado = (estado == "home") ? "fechado" : "home";
}

if (estado == "home") {
    for (var i = 0; i < array_length(_l.app_rects); i++) {
        var _r = _l.app_rects[i];
        if (_mx >= _r.x1 && _mx <= _r.x2 && _my >= _r.y1 && _my <= _r.y2) {
            app_hover = i;
            if (_clicou) {
                if (apps[i] == "Menu") {
                    estado = "menu_app";
                } else {
                    placeholder_titulo = apps[i];
                    estado = "placeholder";
                }
            }
        }
    }
} else if (estado == "menu_app") {
    for (var i = 0; i < array_length(_l.menu_rects); i++) {
        var _r = _l.menu_rects[i];
        if (_mx >= _r.x1 && _mx <= _r.x2 && _my >= _r.y1 && _my <= _r.y2) {
            menu_hover = i;
            if (_clicou) {
                switch (i) {
                    case 0: // Continuar
                        estado = "fechado";
                        break;
                    case 1: // Salvar
                        scr_save_write(1);
                        mensagem_feedback = "Jogo salvo!";
                        mensagem_timer = 90;
                        break;
                    case 2: // Voltar ao Título
                        global.celular_aberto = false;
                        room_goto(Room_Titulo);
                        break;
                    case 3: // Sair
                        game_end();
                        break;
                }
            }
        }
    }
}
