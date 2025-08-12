package game


Menu_Screen :: enum {
	Main,
	Settings,
}

Menu :: struct {
	current_screen: Menu_Screen,
	contents:       [Menu_Screen]Menu_Content,
}


menu_init :: proc(width, height: f32) -> Menu {
	contents := [Menu_Screen]Menu_Content {
		.Main     = menu_main_init(width, height),
		.Settings = menu_settings_init(width, height),
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
}


menu_update :: proc(game: ^Game) {
	menu_content_update(game, game.menu.current_screen)
}


menu_draw :: proc(game: ^Game) {
	menu_content_draw(game, game.menu.current_screen)
}

