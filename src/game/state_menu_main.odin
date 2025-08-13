package game

menu_main_init :: proc(width, height: f32) -> Menu_Content {
	widgets := make([dynamic]UI_Widget)

	// LABELS
	// we will draw all menu elements centered, so x-coordinates in Vec2's are irrelevant
	{
		// game title
		append(
			&widgets,
			ui_label_create(GAME_TITLE, ui_font_default, vec2_center(UI_SCORE_POS.y), 16.0),
		)

		// help text at the bottom of the screen (in reverse order for easier math-ing)
		font_size_help: f32 = 8.0
		spacer: f32 = 8.0
		y := height - font_size_help -  /* offset */4.0

		append(
			&widgets,
			ui_label_create(
				"Space to select (and jump in game)",
				ui_font_default,
				vec2_center(y),
				font_size_help,
			),
		)

		y -= spacer + font_size_help
		append(
			&widgets,
			ui_label_create(
				"Arrows to change selection",
				ui_font_default,
				vec2_center(y),
				font_size_help,
			),
		)
	}


	// BUTTONS
	{
		spacer: f32 = 16.0
		y := UI_SCORE_POS.y +  /* font-size of title*/16.0 + spacer * 2
		x := width / 2 - UI_BUTTON_WIDTH / 2
		button_font := ui_font_default
		button_font.size = UI_BUTTON_FONT_SIZE
		button_font.color = UI_BUTTON_FONT_COLOR

		// Start
		append(
			&widgets,
			ui_button_create(
				"Start",
				Rect{x, y, UI_BUTTON_WIDTH, UI_BUTTON_HEIGHT},
				proc(game: ^Game) {
					game.state = .Playing
				},
				button_font,
			),
		)

		// Settings
		y += spacer + UI_BUTTON_HEIGHT
		append(
			&widgets,
			ui_button_create(
				"Settings",
				Rect{x, y, UI_BUTTON_WIDTH, UI_BUTTON_HEIGHT},
				proc(game: ^Game) {
					game.menu.current_screen = .Settings
				},
				button_font,
			),
		)

		// quit
		y += spacer + UI_BUTTON_HEIGHT
		append(
			&widgets,
			ui_button_create(
				"Quit",
				Rect{x, y, UI_BUTTON_WIDTH, UI_BUTTON_HEIGHT},
				proc(game: ^Game) {
					game.state = .Exit
				},
				button_font,
			),
		)
	}

	return Menu_Content{index_selected = 0, widgets = widgets}
}

