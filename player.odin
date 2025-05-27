package main

import rl "vendor:raylib"

Player :: struct {
	using position:    rl.Vector2,
	current_animation: ^Animation,
	run_animation:     Animation,
	jump_animation:    Animation,
	velocity:          rl.Vector2,
	jumping:           bool,
	jump_sound:        rl.Sound,
	death_sound:       rl.Sound,
	collider_size:     rl.Vector2,
	collider_offset:   rl.Vector2,
}

get_collision_rect_player :: proc(player: Player) -> rl.Rectangle {
	return rl.Rectangle {
		x = player.x + player.collider_offset.x,
		y = player.y + player.collider_offset.y,
		width = player.collider_size.x,
		height = player.collider_size.y,
	}
}

