package game

import "../assets"

//
// Constants
//


PLAYER_JUMP_FORCE :: 400.0
PLAYER_GRAVITY :: 800.0


// 
// Structs
//


Player :: struct {
	using pos:       Vec2,
	using animation: Animation,
}


// 
// Procs
//


player_init :: proc(animation: Animation, pos: Vec2) -> Player {
	return Player{pos = pos, animation = animation}
}

player_rect :: proc(player: Player) -> Rect {
	return Rect {
		x = player.x,
		y = player.y,
		width = f32(player.animation_info.frame_width),
		height = f32(player.animation_info.frame_height),
	}
}

player_draw :: proc(game: ^Game) {
	assets.animation_play(&game.player, game.player)
}

player_animation_rest :: proc(game: ^Game) {
	game.player.current_frame = 0
	game.player.animation_finished = false
	game.player.timer = 0.0
}

