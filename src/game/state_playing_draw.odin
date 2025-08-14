package game

import "core:fmt"
// import "core:log"
import "core:math"
import rl "vendor:raylib"


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
	is_paused := game.state == .Menu && game.menu.current_screen == .Pause
	player_draw(game.player, game^, is_paused)

	// ui
	playing_draw_ui(game^)
}

playing_draw_floor :: proc(game: Game) {
	floor_width := game.floor.texture.width
	floor_y := game.screen_height - game.floor.texture.height
	num_floor_tiles := int(game.screen_width / floor_width) + 3

	start_tile := int(game.floor.scroll_offset / f32(floor_width))
	start_x := -i32(game.floor.scroll_offset) + i32(start_tile) * floor_width


	for x in 0 ..< num_floor_tiles {
		floor_x := start_x + i32(x) * floor_width
		rl.DrawTexture(game.floor.texture, floor_x, floor_y, rl.WHITE)
	}
}

playing_draw_background :: proc(game: Game) {
	for bg in game.background_assets {
		texture_width := f32(bg.texture.width)
		num_textures := (game.screen_width / bg.texture.width) + 2
		start_x := -math.mod(bg.scroll_offset, texture_width)

		for i in 0 ..< num_textures {
			x := start_x + (f32(i) * texture_width)
			rl.DrawTextureV(bg.texture, {x, 0}, rl.WHITE)
		}
	}
}

playing_draw_obstacles :: proc(game: Game) {
	for o in game.obstacles {
		obstacle_draw(o)
	}
}


playing_draw_ui :: proc(game: Game) {
	// distance score
	playing_draw_distance(game)

	// draw elapsed time
	playing_draw_time_elapsed(game)

	// player health
	playing_draw_player_health(game)

	when ODIN_DEBUG {
		draw_fps(game)
		draw_raw_distance(game)
	}
}

playing_draw_distance :: proc(game: Game) {
	distance_score := calc_distance_score(game)
	dist_text := fmt.ctprintf("Distance: %d", distance_score)
	draw_cool_text(dist_text, UI_SCORE_FONT_SIZE, UI_SCORE_POS, UI_SCORE_COLOR)
}

playing_draw_player_health :: proc(game: Game) {
	// measure a static placeholder text to get an x-coordinate that is "close enough", but prevents the text from jumping when updated
	placeholder_size := rl.MeasureTextEx(get_default_font(), "Health: X", UI_SCORE_FONT_SIZE, 0.0)
	health_text_pos := Vec2 {
		f32(game.screen_width) - placeholder_size.x - UI_SCORE_POS.x,
		UI_SCORE_POS.y,
	}
	health_text := fmt.ctprintf("Health: %d", game.player.health)
	draw_cool_text(health_text, UI_SCORE_FONT_SIZE, health_text_pos, UI_SCORE_COLOR)
}

playing_draw_time_elapsed :: proc(game: Game) {
	time_elapsed := rl.GetTime() - game.started
	time_elapsed_text := fmt.ctprintf("%0.f", time_elapsed)

	draw_center_text_x(time_elapsed_text, UI_SCORE_FONT_SIZE, game, UI_SCORE_POS.y, UI_SCORE_COLOR)
}

