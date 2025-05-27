package main

import rl "vendor:raylib"

// get_collision_rect is a proc overload for all structs implementing a collision rect proc.
get_collision_rect :: proc {
	get_collision_rect_player,
	get_collision_rect_wall,
}

// check_collision returns whether rect1 and rect2 collide.
// Right now just a simple wrapper for raylibs detection function.
check_collision :: proc(rect1, rect2: rl.Rectangle) -> bool {
	return rl.CheckCollisionRecs(rect1, rect2)
}

