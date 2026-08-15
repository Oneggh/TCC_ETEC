/// @description Salvar/carregar as opções do jogo (volume e tela cheia) em options.ini

function scr_options_load() {
    if (!variable_global_exists("opt_musica")) global.opt_musica = 1;
    if (!variable_global_exists("opt_sfx")) global.opt_sfx = 1;
    if (!variable_global_exists("opt_fullscreen")) global.opt_fullscreen = false;

    if (file_exists("options.ini")) {
        ini_open("options.ini");
        global.opt_musica = ini_read_real("Options", "musica", global.opt_musica);
        global.opt_sfx = ini_read_real("Options", "sfx", global.opt_sfx);
        global.opt_fullscreen = bool(ini_read_real("Options", "fullscreen", global.opt_fullscreen ? 1 : 0));
        ini_close();
    }

    audio_group_set_gain(audiogroup_default, global.opt_musica, 0);
}

function scr_options_save() {
    ini_open("options.ini");
    ini_write_real("Options", "musica", global.opt_musica);
    ini_write_real("Options", "sfx", global.opt_sfx);
    ini_write_real("Options", "fullscreen", global.opt_fullscreen ? 1 : 0);
    ini_close();

    audio_group_set_gain(audiogroup_default, global.opt_musica, 0);
}
