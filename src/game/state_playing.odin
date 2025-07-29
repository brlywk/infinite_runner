package game

import rl "vendor:raylib"


DECO_BUILDING_TINT :: rl.Color{100, 100, 100, 255}


//
// UPDATE
//


playing_update :: proc(game: ^Game) {
	// check for paused key being pressed (ESC)
	if rl.IsKeyPressed(rl.KeyboardKey.ESCAPE) {
		game.state = .Paused
	}

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
	playing_draw_building(game^)

	// obstacles
	playing_draw_obstacles(game^)

	// player
	is_paused := game.state == .Paused
	player_draw(game.player, is_paused)

	// ui
	playing_draw_ui(game^)
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

@(private = "file")
playing_draw_building :: proc(game: Game) {
}

@(private = "file")
playing_draw_ui :: proc(game: Game) {
}

