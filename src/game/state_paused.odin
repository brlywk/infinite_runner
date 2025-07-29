package game

import rl "vendor:raylib"


PAUSE_SCREEN_BG_TINT :: rl.Color{10, 10, 10, 200}


paused_update :: proc(game: ^Game) {
	if rl.IsKeyPressed(rl.KeyboardKey.ESCAPE) {
		game.state = .Playing
	}
}

paused_draw :: proc(game: ^Game) {
	// draw current playing state for a nice effect
	playing_draw(game)

	rl.DrawRectangle(0, 0, game.screen_width, game.screen_height, PAUSE_SCREEN_BG_TINT)
	draw_center_text_x("PAUSED", 16.0, game^, 32.0, rl.WHITE)
}

