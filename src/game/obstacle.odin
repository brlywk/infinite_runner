package game

import rl "vendor:raylib"


// 
// Structs
//


Obstacle :: struct {
	using rect: Rect,
	texture:    Texture,
	active:     bool,
}


//
// Procs
//


obstacle_create :: proc(texture: Texture, pos: Vec2) -> Obstacle {
	rect := Rect {
		x      = pos.x,
		y      = pos.y,
		width  = f32(texture.width),
		height = f32(texture.height),
	}
	return Obstacle{rect = rect, texture = texture, active = true}
}

obstacle_update :: proc(obstacle: ^Obstacle) {
	// TODO
}


obstacle_draw :: proc(obstacle: Obstacle) {
	if !obstacle.active do return

	rl.DrawTexture(obstacle.texture, i32(obstacle.x), i32(obstacle.y), rl.WHITE)

	when ODIN_DEBUG {
		obstacle_rect := obstacle_rect(obstacle)
		rl.DrawRectangleLinesEx(obstacle_rect, 1.0, rl.RED)
	}
}

obstacle_rect :: proc(obstacle: Obstacle) -> Rect {
	return Rect {
		x = obstacle.x,
		y = obstacle.y,
		width = f32(obstacle.texture.width),
		height = f32(obstacle.texture.height),
	}
}

