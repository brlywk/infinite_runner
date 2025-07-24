package main

//
// Structs
//


// Position of a sprite on the screen.
Position :: struct {
	x: i32,
	y: i32,
}

// A single frame in a sprite sheet. 
SpriteFrame :: struct {
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
to_rect :: proc(sprite_frame: SpriteFrame, pos: Position) -> Rect {
	return Rect {
		x = f32(pos.x),
		y = f32(pos.y),
		width = f32(sprite_frame.width),
		height = f32(sprite_frame.height),
	}
}

