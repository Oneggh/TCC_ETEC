/// @description Controlador do celular (acessível durante o jogo, tecla P)

if (!variable_global_exists("celular_aberto")) global.celular_aberto = false;

estado = "fechado"; // "fechado" | "home" | "menu_app" | "placeholder"
abertura = 0; // 0..1, anima abrir/fechar

apps = ["Menu", "Opcoes", "Mensagens", "Galeria"];
app_hover = -1;

menu_botoes = ["Continuar", "Salvar", "Voltar ao Titulo", "Sair"];
menu_hover = -1;

mensagem_feedback = "";
mensagem_timer = 0;

placeholder_titulo = "";

// ================= LAYOUT (Step e Draw usam a mesma função) =================
calcular_layout = function() {
    var _gw = display_get_gui_width();
    var _gh = display_get_gui_height();
    var _cx = _gw / 2;
    var _cy = _gh / 2;

    var _tela_w = 340;
    var _tela_h = 480;

    var _l = {
        gw: _gw,
        gh: _gh,
        cx: _cx,
        cy: _cy,
        corpo_x1: _cx - _tela_w / 2 - 14,
        corpo_y1: _cy - _tela_h / 2 - 14,
        corpo_x2: _cx + _tela_w / 2 + 14,
        corpo_y2: _cy + _tela_h / 2 + 14,
        tela_x1: _cx - _tela_w / 2,
        tela_y1: _cy - _tela_h / 2,
        tela_x2: _cx + _tela_w / 2,
        tela_y2: _cy + _tela_h / 2,
    };

    // Grade de apps (2 colunas)
    var _icone = 120;
    var _gap = 24;
    var _cols = 2;
    _l.app_rects = [];
    for (var i = 0; i < array_length(apps); i++) {
        var _col = i mod _cols;
        var _lin = i div _cols;
        var _ix1 = _l.tela_x1 + 30 + _col * (_icone + _gap);
        var _iy1 = _l.tela_y1 + 60 + _lin * (_icone + _gap);
        array_push(_l.app_rects, {
            x1: _ix1, y1: _iy1, x2: _ix1 + _icone, y2: _iy1 + _icone,
        });
    }

    // Botões do app Menu
    var _bw = _tela_w - 60;
    var _bh = 50;
    var _bgap = 14;
    _l.menu_rects = [];
    for (var i = 0; i < array_length(menu_botoes); i++) {
        var _by1 = _l.tela_y1 + 70 + i * (_bh + _bgap);
        array_push(_l.menu_rects, {
            x1: _cx - _bw / 2, y1: _by1, x2: _cx + _bw / 2, y2: _by1 + _bh,
        });
    }

    // Botão de fechar/voltar (canto superior direito da tela)
    _l.fechar = { x1: _l.tela_x2 - 34, y1: _l.tela_y1 + 6, x2: _l.tela_x2 - 6, y2: _l.tela_y1 + 34 };

    return _l;
};
