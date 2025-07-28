package game

import rl "vendor:raylib"


DECO_BUILDING_TINT :: rl.Color{100, 100, 100, 255}


//
// UPDATE
//


playing_update :: proc(game: ^Game) {
	dt := rl.GetFrameTime()
	floor_y := y_floored(game^)


	// player
	player_update(&game.player, floor_y, dt)

	// TODO:
	// spawn obstacles
	// check for player collision with obstacles
	// animate background
	// spawn occasional decorative buildings
}


//
// DRAW
//


playing_draw :: proc(game: ^Game) {
	// background 
	playing_draw_background(game^)

	// floor
	playing_draw_floor(game^)

	// buildings
	// TODO: Change, just for test drawing
	building := game.building_assets[1]
	rl.DrawTexture(
		building,
		128,
		game.screen_height - game.floor.height - building.height,
		DECO_BUILDING_TINT,
	)

	// obstacles
	playing_draw_obstacles(game^)

	// player
	player_draw(game.player)

	// ui
}

@(private = "file")
playing_draw_floor :: proc(game: Game) {
	num_floor_tiles := int(game.screen_width / game.floor.width) + 2
	floor_y := game.screen_height - game.floor.height

	for x in 0 ..< num_floor_tiles {
		floor_x := i32(x) * game.floor.width
		rl.DrawTexture(game.floor, floor_x, floor_y, rl.WHITE)
	}
}

@(private = "file")
playing_draw_background :: proc(game: Game) {
	for bg in game.background_assets {
		rl.DrawTexture(bg.texture, 0, 0, rl.WHITE)
	}
}

@(private = "file")
playing_draw_obstacles :: proc(game: Game) {
	for o in game.obstacles {
		obstacle_draw(o)
	}
}

