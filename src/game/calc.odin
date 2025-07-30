package game

// Returns a Vec2 with the mininum x and y coordinates of v1 and v2.
min_vec2 :: proc(v1, v2: Vec2) -> Vec2 {
	min_x := min(v1.x, v2.x)
	min_y := min(v1.y, v2.y)

	return Vec2{min_x, min_y}
}

rect_xy_size :: proc(rect: Rect) -> (pos, size: Vec2) {
	pos = {rect.x, rect.y}
	size = {rect.width, rect.height}
	return
}

// Calculates the y-coordinate of the floor on the screen, 
// taking the current screen height into account.
//
// With this, every entity can be drawn at:
//       entity.y = y_floored(game) - entity.height
y_floored :: proc(game: Game) -> f32 {
	return f32(game.screen_height - game.floor.texture.height)
}

calc_distance_score :: proc(game: Game) -> i32 {
	return game.distance / GAME_PIXELS_PER_POINT
}

