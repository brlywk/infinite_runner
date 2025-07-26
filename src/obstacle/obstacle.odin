package obstacle

import rl "vendor:raylib"


// 
// Structs
//


Obstacle :: struct {
	using pos: Vec2,
	texture:   Texture,
	active:    bool,
}


//
// Procs
//


create :: proc(texture: Texture, pos: Vec2) -> Obstacle {
	return Obstacle{pos = pos, texture = texture, active = true}
}


draw :: proc(obstacle: Obstacle) {
	if !obstacle.active do return

	rl.DrawTexture(obstacle.texture, i32(obstacle.x), i32(obstacle.y), rl.WHITE)
}

