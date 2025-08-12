package game

import "../global"
import "core:log"
import rl "vendor:raylib"

menu_settings_init :: proc(width, height: f32) -> Menu_Content {
	widgets := make([dynamic]UI_Widget)

	// we want to exit back to the main menu on pressing escape
	custom_action: UI_Callback = proc(game: ^Game) {
		if rl.IsKeyPressed(.ESCAPE) {
			game.menu.current_screen = .Main
		}
	}

	// we need a reference to our global context to access settings
	settings := &global.ctx().settings

	// where we start drawing things
	y := UI_SCORE_POS.y
	spacer: f32 : 16.0

	// Lables
	{
		// title
		title_label := ui_label_create("Settings", ui_font_default, vec2_center(y), 16.0)
		append(&widgets, title_label)
		log.debugf("settings title label: height=%f", title_label.rect.height)
		y += title_label.rect.height + spacer

		// help text at the bototm
		font_size_help: f32 = 8.0
		y_help := height - font_size_help -  /* offset */4.0

		help_label := ui_label_create(
			"Escape to go back",
			ui_font_default,
			vec2_center(y_help),
			font_size_help,
		)
		append(&widgets, help_label)
	}

	// Sliders
	{
		// NOTE: Sliders cause a little bit more work because we only know the
		// size of the toggle (for positioning) AFTER we created the toggle

		// TODO
	}

	menu := Menu_Content {
		index_selected = 0,
		widgets        = widgets,
		custom_action  = custom_action,
	}

	return menu
}

