package game

// import "core:log"
import "core:math"
import rl "vendor:raylib"


playing_update :: proc(game: ^Game) {
	// check for paused key being pressed (ESC)
	if rl.IsKeyPressed(rl.KeyboardKey.ESCAPE) {
		game.state = .Paused
	}

	// check if the game should be over 
	if game.player.state == .Dead {
		game.state = .Game_Over
	}

	dt := rl.GetFrameTime()

	// background
	playing_update_background(game, dt)

	// floor
	playing_update_floor(game, dt)

	// buildings
	playing_update_buildings(game, dt)

	// obstacles
	playing_update_obstacles(game, dt)

	// player
	floor_y := y_floored(game^)
	player_update(&game.player, floor_y, dt)

	// check collision between player and obstacles
	playing_handle_collision(game, dt)

	// game distance ("score")
	playing_update_score(game, dt)

	// ui

	// TODO:
	// check for player collision with obstacles
	// add player health so player can survive ~3 collisions -> reduce game speed on collision
	// ui and all that weird stuff
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


check_collision :: proc(player: Player, obstacle: Obstacle) -> bool {
	return rl.CheckCollisionRecs(player, obstacle)
}

check_all_collisions :: proc(game: ^Game) -> bool {
	for obstacle in game.obstacles do if check_collision(game.player, obstacle) {
		return true
	}

	return false
}

playing_handle_collision :: proc(game: ^Game, dt: f32) {
	collision := check_all_collisions(game)

	// state change -> collision just happened
	if collision && game.player.state in PLAYER_VULNERABLE_STATES {
		game.player.health -= 1
		if game.player.health > 0 {
			player_change_state(&game.player, .Hurt)
		} else {
			player_change_state(&game.player, .Dead)
		}
	}

	// collision ended
	if !collision && game.player.state == .Hurt {
		player_reset_animation(game.player)
		player_change_state(&game.player, .Running)
	}
}

