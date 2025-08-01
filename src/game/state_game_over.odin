package game

import "core:fmt"
import "core:log"
import "core:math/linalg"
// import "core:log"
import rl "vendor:raylib"

game_over_draw :: proc(game: ^Game) {
	death_animation_finished := player_get_animation(game.player).animation_finished

	if !death_animation_finished {
		playing_draw_background(game^)
		playing_draw_floor(game^)
		playing_draw_building(game^)
		playing_draw_obstacles(game^)
		player_draw(game.player)
	}

	// draw the final screen
	dt := rl.GetFrameTime()

	playing_draw_background(game^)
	player_draw(game.player)

	// only who the UI once the animation is done
	if !game_over_move_player(game, dt) do return

	// final screen UI
	game_over_draw_ui(game)
}

game_over_update :: proc(game: ^Game) {
	// although everybode LOOOVES unskippable "cutscenes", let's be nice and allow
	// players to do something before the death animation finishes

	#partial switch rl.GetKeyPressed() {
	case .R:
		reset(game)
	case .M:
		game.state = .Menu
	case .ESCAPE:
		game.state = .Exit
	}

	// play death animation first
	death_animation_finished := player_get_animation(game.player).animation_finished
	if !death_animation_finished do return

	dt := rl.GetFrameTime()
	game_over_move_player(game, dt)
}

game_over_move_player :: proc(game: ^Game, dt: f32) -> (done: bool) {
	player_half_size := vec2_round_to_pixel(player_get_sprite_size(game.player) / 2)
	player_pos := player_get_pos(game.player)
	target_pos := get_screen_center_nearest(game^) - player_half_size
	log.debugf(
		"target_pos=%v player_pos=%v player_half_size=%v",
		target_pos,
		player_pos,
		player_half_size,
	)

	// early out
	if player_pos == target_pos do return true

	// why does everything in pixel games need extra handling for floating point math? :(
	// (Yes, I know why, but it still sucks...)
	direction := player_pos - target_pos // yes, mathematically it's flipped, but it makes it easier for me to think in screen coordinates
	distance := linalg.length(direction)

	// half a pixel is enough to snap to
	if distance < 0.5 {
		game.player.x = target_pos.x
		game.player.y = target_pos.y
		return true
	}

	move := min(GAME_SPEED_INIT * dt, distance) * linalg.normalize(direction)

	// move player
	game.player.x -= move.x
	game.player.y -= move.y

	return false
}

game_over_draw_ui :: proc(game: ^Game) {
	padding: f32 = 32.0

	// game over text
	game_over_font_size: f32 = 16.0
	draw_center_text_x(
		"Game Over",
		game_over_font_size,
		game^,
		padding,
		rl.WHITE,
		FONT_SHADOW_COLOR_ON_BLACK,
	)

	// final score
	score_y := padding + game_over_font_size * 2
	score_font_size: f32 = 8.0
	score_text := fmt.ctprintf("Distance travelled: %d", calc_distance_score(game^))
	draw_center_text_x(
		score_text,
		score_font_size,
		game^,
		score_y,
		rl.WHITE,
		FONT_SHADOW_COLOR_ON_BLACK,
	)

	// options
	options_texts := []string {
		"Press Escape to exit the game",
		"Press M to go back to the main menu.",
		"Press R to restart.",
	}

	options_y_start := f32(game.screen_height) - padding
	options_font_size: f32 = 8.0
	for text, i in options_texts {
		options_y := options_y_start - (f32(i) * options_font_size * 2)

		draw_center_text_x(
			fmt.ctprint(text),
			options_font_size,
			game^,
			options_y,
			rl.WHITE,
			FONT_SHADOW_COLOR_ON_BLACK,
		)
	}
}

