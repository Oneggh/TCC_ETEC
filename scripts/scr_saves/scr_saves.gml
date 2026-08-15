/// @description Sistema de save/load em arquivos save1.ini / save2.ini / save3.ini

function scr_save_path(_slot) {
    return "save" + string(_slot) + ".ini";
}

function scr_save_exists(_slot) {
    return file_exists(scr_save_path(_slot));
}

function scr_save_write(_slot) {
    if (!instance_exists(obj_player_1)) return false;

    var _sala = room_get_name(room);
    var _x = 0, _y = 0, _vida = 100, _vida_max = 100, _stam = 100, _stam_max = 100, _modo = "normal";

    with (obj_player_1) {
        _x = x;
        _y = y;
        _vida = Vida;
        _vida_max = VidaMax;
        _stam = Stamina;
        _stam_max = Stamina_maxima;
        _modo = modo_atual;
    }

    ini_open(scr_save_path(_slot));
    ini_write_string("Save", "sala", _sala);
    ini_write_real("Save", "x", _x);
    ini_write_real("Save", "y", _y);
    ini_write_real("Save", "vida", _vida);
    ini_write_real("Save", "vida_max", _vida_max);
    ini_write_real("Save", "stamina", _stam);
    ini_write_real("Save", "stamina_max", _stam_max);
    ini_write_string("Save", "modo", _modo);
    ini_write_string("Save", "data", date_date_string(date_current_datetime()) + " " + date_time_string(date_current_datetime()));
    ini_close();

    return true;
}

function scr_save_read(_slot) {
    if (!scr_save_exists(_slot)) return undefined;

    ini_open(scr_save_path(_slot));
    var _dados = {
        sala: ini_read_string("Save", "sala", ""),
        x: ini_read_real("Save", "x", 0),
        y: ini_read_real("Save", "y", 0),
        vida: ini_read_real("Save", "vida", 100),
        vida_max: ini_read_real("Save", "vida_max", 100),
        stamina: ini_read_real("Save", "stamina", 100),
        stamina_max: ini_read_real("Save", "stamina_max", 100),
        modo: ini_read_string("Save", "modo", "normal"),
        data: ini_read_string("Save", "data", ""),
    };
    ini_close();

    return _dados;
}

function scr_save_load(_slot) {
    var _dados = scr_save_read(_slot);
    if (is_undefined(_dados)) return false;

    global.save_pendente = _dados;

    var _sala_idx = asset_get_index(_dados.sala);
    if (_sala_idx == -1 || !room_exists(_sala_idx)) _sala_idx = Teste;

    room_goto(_sala_idx);
    return true;
}
