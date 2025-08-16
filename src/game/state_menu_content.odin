package game

import "core:math/rand"
import rl "vendor:raylib"


@(rodata)
ui_selection_sounds := [?]Sound_Name{.Select_01, .Select_02}


Menu_Content :: struct {
	index_selected: int,
	widgets:        [dynamic]UI_Widget,
	custom_action:  UI_Callback,
	music:          Music,
}

// NOTE: menu_*_init procs are specific to the menu (main, settings...)

menu_content_destroy :: proc(m: ^Menu_Content) {
	delete(m.widgets)
}


menu_content_draw :: proc(game: ^Game, menu_screen: Menu_Screen) {
	menu := game.menu.contents[menu_screen]

	// "fake" game scene gackground
	state_menu_draw_bg(game)

	for widget in menu.widgets {
		ui_widget_draw(widget, game^)
	}
}

menu_content_update :: proc(game: ^Game, menu_screen: Menu_Screen) {
	menu := &game.menu.contents[menu_screen]
	num_focusable := ui_widget_count_focusable(menu.widgets[:])

	// custom UI callback action (e.g. Settings: Escape => Back to Menu)
	if menu.custom_action != nil {
		menu.custom_action(game)
	}

	// menu navigation
	if rl.IsKeyPressed(.DOWN) || rl.IsKeyPressed(.S) || rl.IsKeyPressed(.J) {
		new_selection := min(num_focusable - 1, menu.index_selected + 1)

		if menu.index_selected != new_selection {
			play_random_ui_selection_sound()
		}

		menu.index_selected = new_selection
	}
	if rl.IsKeyPressed(.UP) || rl.IsKeyPressed(.W) || rl.IsKeyPressed(.K) {
		new_selection := max(0, menu.index_selected - 1)

		if menu.index_selected != new_selection {
			play_random_ui_selection_sound()
		}

		menu.index_selected = new_selection
	}

	// highlight selected element
	focusable_index := 0
	for &widget in menu.widgets {
		if _, ok := widget.(UI_Label); !ok {
			focused := focusable_index == menu.index_selected
			ui_widget_set_focus(&widget, focused)
			focusable_index += 1
		} else {
			ui_widget_set_focus(&widget, false)
		}
	}

	// menu selection
	if selected_widget, ok := ui_widget_get_focusable_at_index(
		menu.widgets[:],
		menu.index_selected,
	); ok {
		switch &w in selected_widget {
		case UI_Button:
			if rl.IsKeyPressed(.SPACE) {
				play_sound(.Click)
				w.callback(game)
			}

		case UI_Slider:
			if rl.IsKeyPressed(.A) || rl.IsKeyPressed(.LEFT) || rl.IsKeyPressed(.H) {
				w.decrement(&w)
			} else if rl.IsKeyPressed(.D) || rl.IsKeyPressed(.RIGHT) || rl.IsKeyPressed(.L) {
				w.increment(&w, true)
			} else {
				ui_slider_unfocus(&w)
			}

		case UI_Label:
		// nothing, absolutely nothing...
		}
	}


}

@(private)
state_menu_draw_bg :: proc(game: ^Game) {
	// background
	playing_draw_background(game^)

	// floor
	playing_draw_floor(game^)

	// building
	playing_draw_building(game^)

	// obstacles
	if game.menu.current_screen == .Pause {
		playing_draw_obstacles(game^)
	}

	// player
	player_draw(game.player, game^)

	// dimmed background
	rl.DrawRectangle(0, 0, game.screen_width, game.screen_height, PAUSE_SCREEN_BG_TINT)
}

@(private)
play_random_ui_selection_sound :: proc() {
	sound_name := rand.choice(ui_selection_sounds[:])
	play_sound(sound_name)
}

