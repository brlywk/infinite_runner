package game

import "core:log"
import "core:math"
import rl "vendor:raylib"

// Debug flags
// usage: odin run. -debug -define:NO_COLLISION=true
NO_COLLISION :: #config(NO_COLLISION, false)


playing_update :: proc(game: ^Game) {
	// check for paused key being pressed (ESC)
	if rl.IsKeyPressed(.ESCAPE) {
		game.state = .Paused
	}

	// allow for instant restart
	if rl.IsKeyPressed(.R) {
		reset(game)
	}

	// check if the game should be over 
	if game.player.state == .Dead {
		game.state = .Game_Over
	}

	// we need to use our own game time so pausing the game
	// doesn't mess up time based events (e.g. obstacle spawning)
	dt := rl.GetFrameTime()
	if game.state == .Playing {
		game.game_time += f64(dt)
	}

	// background
	playing_update_background(game, dt)

	// floor
	playing_update_floor(game, dt)

	// buildings
	playing_update_buildings(game, dt)

	// obstacles
	playing_update_obstacles(game, dt)

	// check collision between player and obstacles
	when !(ODIN_DEBUG && NO_COLLISION) {
		playing_handle_collision(game, dt)
	}

	// player
	player_play_sound(&game.player, game^)
	player_update(&game.player, game^, y_floored(game^), dt)

	// game distance ("score")
	playing_update_score(game, dt)

	// update game speed based on distance travelled
	playing_update_game_speed(game)

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

playing_update_game_speed :: proc(game: ^Game) {
	// NOTE: The game speed displayed is different from the game speed internally,
	// so we need to "scale" all changes accordingly (smart? no!)
	actual_speed_per: f32 = GAME_SPEED_INCREASE_PER * GAME_PIXELS_PER_POINT
	speed_modifier := f32(game.distance / i32(actual_speed_per))
	speed_increase: f32 = speed_modifier * (GAME_SPEED_INCREASE_BY / (speed_modifier + 1))

	if speed_increase != game.last_increase {
		log.debugf("SPEED CHANGE: raw_distance=%d new_speed=%f", game.distance, game.speed)
		game.last_increase = speed_increase
		game.speed += speed_increase
		game.speed = clamp(game.speed, GAME_SPEED_INIT, GAME_SPEED_MAX)
	}
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
			// prevent any jumping velocity to acrue will player is in hurt state
			game.player.velocity.y = 0
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

