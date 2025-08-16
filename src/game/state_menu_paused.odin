package game

import "../global"
import rl "vendor:raylib"


menu_pause_init :: proc(width, height: f32) -> Menu_Content {
	widgets := make([dynamic]UI_Widget)

	custom_action := proc(game: ^Game) {
		if rl.IsKeyPressed(.ESCAPE) {
			game.state = .Playing
			player_change_state(&game.player, game.player.prev_state)
		}
	}

	// Labels
	y := UI_SCORE_POS.y
	{
		title_label := ui_label_create("Paused", ui_font_default, vec2_center(y), 16.0)
		append(&widgets, title_label)

		// help text at the bototm
		font_size_help: f32 = 8.0
		y_help := height - font_size_help -  /* offset */4.0

		help_label := ui_label_create(
			"Escape to resume game",
			ui_font_default,
			vec2_center(y_help),
			font_size_help,
		)
		append(&widgets, help_label)
	}

	// Buttons
	{
		spacer: f32 = 16.0
		y = UI_SCORE_POS.y +  /* font-size of title*/16.0 + spacer * 2
		x := width / 2 - UI_BUTTON_WIDTH / 2
		button_font := ui_font_default
		button_font.size = UI_BUTTON_FONT_SIZE
		button_font.color = UI_BUTTON_FONT_COLOR

		// resume game
		append(
			&widgets,
			ui_button_create(
				"Resume",
				Rect{x, y, UI_BUTTON_WIDTH, UI_BUTTON_HEIGHT},
				proc(game: ^Game) {
					game.state = .Playing
				},
				button_font,
			),
		)

		// Main Menu
		y += spacer + UI_BUTTON_HEIGHT
		append(
			&widgets,
			ui_button_create(
				"Main Menu",
				Rect{x, y, UI_BUTTON_WIDTH, UI_BUTTON_HEIGHT},
				proc(game: ^Game) {
					reset(game)
				},
				button_font,
			),
		)


		// exit game
		y += spacer + UI_BUTTON_HEIGHT
		append(
			&widgets,
			ui_button_create(
				"Exit Game",
				Rect{x, y, UI_BUTTON_WIDTH, UI_BUTTON_HEIGHT},
				proc(game: ^Game) {
					game.state = .Exit
				},
				button_font,
			),
		)

	}

	menu := Menu_Content {
		index_selected = 0,
		widgets        = widgets,
		custom_action  = custom_action,
		music          = global.get_asset(Music_Name.InGame),
	}

	return menu
}

