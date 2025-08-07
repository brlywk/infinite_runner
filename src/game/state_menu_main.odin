package game

import rl "vendor:raylib"

menu_main_draw :: proc(game: ^Game) {
	// background
	playing_draw_background(game^)

	// floor
	playing_draw_floor(game^)

	// player
	player_change_state(&game.player, .Idle)
	player_draw(game.player, game^)

	// title
	draw_center_text_x(GAME_TITLE, 16.0, game^, 16.0, rl.WHITE)
}

menu_main_update :: proc(game: ^Game) {
}

