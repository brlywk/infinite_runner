package game

import "../obstacle"
import rl "vendor:raylib"

//
// Structs
//


// 
// Procs
//


playing_draw :: proc(game: ^Game) {
	// background 
	draw_background(game^)

	// floor
	draw_floor(game^)

	// buildings
	// TODO: Change
	building := game.buildings[1]
	rl.DrawTexture(
		building,
		128,
		game.screen_height - game.floor.height - building.height,
		rl.WHITE,
	)

	// obstacles
	draw_obstacles(game^)

	// player
	player_draw(game)

	// ui
}

playing_update :: proc(game: ^Game) {
	if rl.IsKeyDown(rl.KeyboardKey.SPACE) {
		player_animation_rest(game)
	}
}


@(private = "file")
draw_floor :: proc(game: Game) {
	num_floor_tiles := int(game.screen_width / game.floor.width) + 2
	floor_y := game.screen_height - game.floor.height

	for x in 0 ..< num_floor_tiles {
		floor_x := i32(x) * game.floor.width
		rl.DrawTexture(game.floor, floor_x, floor_y, rl.WHITE)
	}
}

@(private = "file")
draw_background :: proc(game: Game) {
	for bg in game.backgrounds {
		rl.DrawTexture(bg.texture, 0, 0, rl.WHITE)
	}
}

@(private = "file")
draw_obstacles :: proc(game: Game) {
	for o in game.obstacles {
		obstacle.draw(o)
	}
}

