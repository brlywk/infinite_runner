package game

import "core:log"
import "core:math/rand"
import rl "vendor:raylib"


Building :: struct {
	using pos:  Vec2,
	texture:    Texture,
	spawn_time: f64,
}


create_random_building :: proc(game: Game, x: f32, time: f64) -> Building {
	rng_idx := rand.int_max(len(game.building_assets))
	texture := game.building_assets[rng_idx]
	floor_y := y_floored(game)

	return Building {
		texture = texture,
		pos = Vec2{x, floor_y - f32(texture.height)},
		spawn_time = time,
	}
}

@(private = "file")
playing_spawn_building :: proc(game: ^Game, dt: f32) {
	// try to get the last building that was spawned
	num_buildings := len(game.buildings)
	if num_buildings == 0 do return

	last_spawned := game.buildings[num_buildings - 1]

	now := rl.GetTime()
	rng := rand.float64_range(BUILDING_SPAWN_SECONDS_MIN, BUILDING_SPAWN_SECONDS_MAX)

	if now >= last_spawned.spawn_time + rng {
		// add small gap for more randomness
		gap := rand.float32_range(BUILDING_SPAWN_GAP_MIN, BUILDING_SPAWN_GAP_MAX)
		x := max(
			last_spawned.pos.x + f32(last_spawned.texture.width) + gap,
			f32(game.screen_width) + 2,
		)

		new_building := create_random_building(game^, x, now)

		log.debugf(
			"spawning building: last_spawn=%f rng=%f time=%f pos=%v",
			last_spawned.spawn_time,
			rng,
			now,
			new_building.pos,
		)

		append(&game.buildings, new_building)
	}
}


playing_update_buildings :: proc(game: ^Game, dt: f32) {
	playing_spawn_building(game, dt)

	// move buildings
	for &building in game.buildings {
		building.pos.x -= game.speed * dt
	}
}


playing_cleanup_buildings :: proc(game: ^Game) {
	for i := len(game.buildings) - 1; i >= 0; i -= 1 {
		building := game.buildings[i]

		if building.pos.x + f32(building.texture.width) < 0 {
			log.debug("building cleaned up")
			ordered_remove(&game.buildings, i)
		}
	}
}


playing_draw_building :: proc(game: Game) {
	for building in game.buildings {
		rl.DrawTextureV(building.texture, building.pos, BUILDING_TINT)
	}
}

