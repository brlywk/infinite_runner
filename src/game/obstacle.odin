package game

import "../assets"
import "core:log"
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


obstacle_create_random :: proc(game: Game, time: f64) -> Obstacle {
	asset_cache := (^Asset_Cache)(context.user_ptr)

	texture_name := rand.choice(obstacle_names)
	texture := assets.get(asset_cache, texture_name)
	floor_y := y_floored(game)

	return Obstacle {
		texture = texture,
		rect = Rect {
			x = f32(game.screen_width) + 2,
			y = floor_y - f32(texture.height),
			width = f32(texture.width),
			height = f32(texture.height),
		},
		spawn_time = time,
	}
}

playing_obstacle_spawn :: proc(game: ^Game, dt: f32) {
	num_obstacles := len(game.obstacles)
	if num_obstacles == 0 do return

	last_spawned := game.obstacles[num_obstacles - 1]
	now := rl.GetTime()
	rng := rand.float64_range(OBSTACLE_SPAWN_SECONDS_MIN, OBSTACLE_SPAWN_SECONDS_MAX)

	if now >= last_spawned.spawn_time + rng {
		// always spawn obstacles just outside the right screen bounds
		new_obstacle := obstacle_create_random(game^, now)
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

