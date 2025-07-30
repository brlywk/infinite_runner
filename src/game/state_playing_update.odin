package game

import "core:math"
import rl "vendor:raylib"


playing_update :: proc(game: ^Game) {
	// check for paused key being pressed (ESC)
	if rl.IsKeyPressed(rl.KeyboardKey.ESCAPE) {
		game.state = .Paused
	}

	dt := rl.GetFrameTime()

	// background
	playing_update_background(game, dt)

	// floor
	playing_update_floor(game, dt)

	// buildings
	playing_update_buildings(game, dt)

	// obstacles

	// player
	floor_y := y_floored(game^)
	player_update(&game.player, floor_y, dt)

	// game distance ("score")
	playing_update_score(game, dt)

	// ui

	// TODO:
	// spawn obstacles
	// ui and all that weird stuff
	// check for player collision with obstacles
	// slightly increase game speed (capped to a max) based on distance

	// cleanup
	playing_cleanup_buildings(game)
	playing_cleanup_obstacles(game)
}

@(private = "file")
playing_update_background :: proc(game: ^Game, dt: f32) {
	for &bg in game.background_assets {
		bg.scroll_offset += game.speed * bg.scroll_speed * dt

		// at 60 FPS, we could run into an overflow in ~10^29 years, so better not risk it...
		if bg.scroll_offset >= f32(game.screen_width) {
			bg.scroll_offset -= f32(game.screen_width) // faster than modulo...
		}
	}
}

@(private = "file")
playing_update_floor :: proc(game: ^Game, dt: f32) {
	game.floor.scroll_offset += game.speed * game.floor.scroll_speed * dt

	if game.floor.scroll_offset >= f32(game.screen_width) {
		game.floor.scroll_offset -= f32(game.screen_width)
	}
}

@(private = "file")
playing_update_score :: proc(game: ^Game, dt: f32) {
	game.distance += i32(math.floor(game.speed * dt))
}


@(private = "file")
playing_cleanup_obstacles :: proc(game: ^Game) {
}

