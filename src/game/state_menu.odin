package game

import "../global"
import rl "vendor:raylib"

Menu_Screen :: enum {
	Main,
	Settings,
	Pause,
}

Menu :: struct {
	current_screen: Menu_Screen,
	contents:       [Menu_Screen]Menu_Content,
}


menu_init :: proc(width, height: f32) -> Menu {
	contents := [Menu_Screen]Menu_Content {
		.Main     = menu_main_init(width, height),
		.Settings = menu_settings_init(width, height),
		.Pause    = menu_pause_init(width, height),
	}

	menu := Menu {
		current_screen = .Main,
		contents       = contents,
	}

	return menu
}

menu_destroy :: proc(menu: ^Menu) {
	menu_content_destroy(&menu.contents[.Main])
	menu_content_destroy(&menu.contents[.Settings])
	menu_content_destroy(&menu.contents[.Pause])
}


menu_update :: proc(game: ^Game) {
	menu_music := game.menu.contents[game.menu.current_screen].music

	if !rl.IsMusicStreamPlaying(menu_music.rl_music) {
		rl.PlayMusicStream(menu_music.rl_music)
	} else {
		music_volume := global.music_volume(menu_music)
		rl.SetMusicVolume(menu_music.rl_music, music_volume)
		rl.UpdateMusicStream(menu_music.rl_music)
	}

	menu_content_update(game, game.menu.current_screen)
}


menu_draw :: proc(game: ^Game) {
	menu_content_draw(game, game.menu.current_screen)
}

