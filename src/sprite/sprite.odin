package sprite

import rl "vendor:raylib"

//
// Types
//


Vec2 :: rl.Vector2
Rect :: rl.Rectangle


//
// Structs
//


// Position of a sprite on the screen.
Position :: struct {
	x: i32,
	y: i32,
}

// General information about a sprite.
Info :: struct {
	width:  i32,
	height: i32,
}


// 
// Procs
//


// Creates a raylib Rectangle.
//
// Inputs:
//  - sprite_frame: SpriteFrame with sizes of a sprite.
//  - pos: x and y position of a sprite on the screen.
//
// Returns: raylib.Rectangle
to_rect :: proc(sprite_frame: Info, pos: Position) -> Rect {
	return Rect {
		x = f32(pos.x),
		y = f32(pos.y),
		width = f32(sprite_frame.width),
		height = f32(sprite_frame.height),
	}
}

