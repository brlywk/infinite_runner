package game

import "../global"
import "core:fmt"
import "core:math"
import rl "vendor:raylib"


// Retrieves the default from the asset cache.
get_default_font :: proc() -> rl.Font {
	return global.get_asset(FONT_NAME_DEFAULT)
}

get_screen_center :: proc(game: Game) -> Vec2 {
	return Vec2{f32(game.screen_width) / 2, f32(game.screen_height) / 2}
}

get_screen_center_nearest :: proc(game: Game) -> Vec2 {
	center := get_screen_center(game)
	return vec2_round_to_pixel(center)

}

// Returns the correct x position for an element for it to be drawn centered on the screen.
get_screen_center_x :: proc(game: Game, element_width: f32) -> f32 {
	return f32(game.screen_width) / 2.0 - element_width / 2.0
}

vec2_round_to_pixel :: proc(vec: Vec2) -> Vec2 {
	return Vec2{math.round(vec.x), math.round(vec.y)}
}

// Draws the given text with a coooool drop shadow. Because it's cool. Maybe.
draw_cool_text :: proc(
	text: cstring,
	font_size: f32,
	pos: Vec2,
	color: rl.Color,
	shadow_color := FONT_SHADOW_COLOR,
) {
	default_font := get_default_font()

	// drop-shadow
	shadow_pos := pos + FONT_SHADOW_OFFSET
	rl.DrawTextEx(default_font, text, shadow_pos, font_size, 0.0, shadow_color)

	// actual text
	rl.DrawTextEx(default_font, text, pos, font_size, 0.0, color)
}

// Draws some text at horizontally centered on the screen, using the game's default font.
draw_center_text_x :: proc(
	text: cstring,
	font_size: f32,
	game: Game,
	text_y: f32,
	color: rl.Color,
	shadow_color := FONT_SHADOW_COLOR,
	shadow := true,
) {
	default_font := get_default_font()

	text_size := rl.MeasureTextEx(default_font, text, font_size, 0.0)
	text_x := get_screen_center_x(game, text_size.x)
	text_pos := Vec2{text_x, text_y}

	if shadow {
		draw_cool_text(text, font_size, text_pos, color, shadow_color)
	} else {
		rl.DrawTextEx(default_font, text, text_pos, font_size, 0.0, color)
	}
}

// Draw current FPS on screen. A bit nicer looking than rl.DrawFPS().
draw_fps :: proc(game: Game) {
	fps := rl.GetFPS()
	fps_text := fmt.ctprintf("FPS: %d", fps)

	fps_font_size: f32 = 8.0
	fps_text_x := fps_font_size * 2
	fps_text_y := f32(game.screen_height - game.floor.texture.height) + fps_font_size / 2

	draw_cool_text(fps_text, fps_font_size, {fps_text_x, fps_text_y}, rl.SKYBLUE)
}

// Distance is scaled to display a nicer number. This (debug) function prints the actual number
// to the screen
draw_raw_distance :: proc(game: Game) {
	dist_raw_text := fmt.ctprintf("Raw Distance: %d", game.distance)
	dist_raw_font_size: f32 = 8.0
	dist_raw_x := get_screen_center_x(game, 0)

	dist_raw_y := f32(game.screen_height - game.floor.texture.height) + dist_raw_font_size / 2

	draw_cool_text(dist_raw_text, dist_raw_font_size, {dist_raw_x, dist_raw_y}, rl.GREEN)

}

