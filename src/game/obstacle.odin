package game

import "../global"
import "../global/scaling"
import "core:log"
import "core:math"
import "core:math/rand"
import rl "vendor:raylib"


// Note to self: We need to index it, so it cannot be a constant, but we also
// don't want to be able to change it, so we need @(rodata) to make it read-only.
@(rodata)
obstacle_names := []Texture_Name {
	.Obstacle_Vent,
	.Obstacle_Box_01,
	.Obstacle_Box_02,
	.Obstacle_Box_03,
	.Obstacle_Vending_Machine_Small_01,
	.Obstacle_Vending_Machine_Small_02,
	.Obstacle_Pole,
	.Obstacle_Vending_Machine_Large_01,
	.Obstacle_Vending_Machine_Large_02,
	.Obstacle_Ad_01,
	.Obstacle_Ad_02,
	.Obstacle_Dumpster,
	.Obstacle_Bench,
	.Obstacle_Car_01,
	.Obstacle_Car_02,
}


Obstacle :: struct {
	using rect: Rect,
	texture:    Texture,
	spawn_time: f64,
}


obstacle_create_random :: proc(game: ^Game, time: f64) -> Obstacle {
	texture_name := rand.choice(obstacle_names)
	texture := global.get_asset(texture_name)
	floor_y := y_floored(game^)

	new_obstacle := Obstacle {
		texture = texture,
		rect = Rect {
			x = f32(game.screen_width) + 2,
			y = floor_y - f32(texture.height),
			width = f32(texture.width),
			height = f32(texture.height),
		},
		spawn_time = time,
	}

	log.debugf("obstacle_create_random: %v", new_obstacle)
	return new_obstacle
}

playing_obstacle_spawn :: proc(game: ^Game, dt: f32) {
	num_obstacles := len(game.obstacles)

	now := game.game_time

	if num_obstacles == 0 {
		// depending on game speed we can potentially remove all obstacles before
		// new ones get spawned (especially at higher game speeds), so always add
		// an obstacle in when the slice is empty
		safety_obstacle := obstacle_create_random(game, now)
		log.debugf("no obstacle found, force spawning at (raw) distance: %d", game.distance)
		append(&game.obstacles, safety_obstacle)
		return
	}

	last_spawned := game.obstacles[num_obstacles - 1]

	// scale spawning with game speed to avoid gaps
	spawn_speed_factor := game.speed / GAME_SPEED_INIT
	dampened_spawn_speed_factor := 1.0 + math.ln(spawn_speed_factor) * scaling.FACTOR.obstacle
	scaled_min := f64(OBSTACLE_SPAWN_SECONDS_MIN / dampened_spawn_speed_factor)
	scaled_max := f64(OBSTACLE_SPAWN_SECONDS_MAX / dampened_spawn_speed_factor)

	rng := rand.float64_range(scaled_min, scaled_max)
	time_since_last_spawn := now - last_spawned.spawn_time

	if time_since_last_spawn >= rng {
		// always spawn obstacles just outside the right screen bounds
		new_obstacle := obstacle_create_random(game, now)
		log.debugf(
			"spawning obstacle: last_spawn=%f rng=%f time=%f pos=%v",
			last_spawned.spawn_time,
			rng,
			now,
			Vec2{new_obstacle.x, new_obstacle.y},
		)
		append(&game.obstacles, new_obstacle)
	}
}

playing_update_obstacles :: proc(game: ^Game, dt: f32) {
	playing_obstacle_spawn(game, dt)

	// move obstacles
	for &obstacle in game.obstacles {
		obstacle.x -= game.speed * dt
	}
}

obstacle_draw :: proc(obstacle: Obstacle) {
	rl.DrawTexture(obstacle.texture, i32(obstacle.x), i32(obstacle.y), rl.WHITE)

	when ODIN_DEBUG {
		rl.DrawRectangleLinesEx(obstacle, 1.0, rl.RED)
	}
}

playing_cleanup_obstacles :: proc(game: ^Game) {
	for i := len(game.obstacles) - 1; i >= 0; i -= 1 {
		obstacle := game.obstacles[i]

		if obstacle.x + f32(obstacle.texture.width) < 0 {
			log.debug("obstacle cleaned up")
			ordered_remove(&game.obstacles, i)
		}
	}
}

