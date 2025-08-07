package game


Menu_Screen :: enum {
	Main,
	Settings,
}


Menu :: struct {
	current_screen: Menu_Screen,
}

menu_init :: proc() -> Menu {
	return {current_screen = .Main}
}


menu_update :: proc(game: ^Game) {
	switch game.menu.current_screen {
	case .Main:
		menu_main_update(game)
	case .Settings:
		menu_settings_update(game)
	}
}


menu_draw :: proc(game: ^Game) {
	switch game.menu.current_screen {
	case .Main:
		menu_main_draw(game)
	case .Settings:
		menu_settings_draw(game)
	}
}

