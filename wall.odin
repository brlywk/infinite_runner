package main

import rl "vendor:raylib"

Wall :: struct {
	using position: rl.Vector2,
	size:           rl.Vector2,
	active:         bool,
}

get_collision_rect_wall :: proc(wall: Wall) -> rl.Rectangle {
	return rl.Rectangle {
		x = wall.position.x,
		y = wall.position.y,
		width = wall.size.x,
		height = wall.size.y,
	}
}

