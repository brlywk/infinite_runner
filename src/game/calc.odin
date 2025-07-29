package game

// Returns a Vec2 with the mininum x and y coordinates of v1 and v2.
min_vec2 :: proc(v1, v2: Vec2) -> Vec2 {
	min_x := min(v1.x, v2.x)
	min_y := min(v1.y, v2.y)

	return Vec2{min_x, min_y}
}

