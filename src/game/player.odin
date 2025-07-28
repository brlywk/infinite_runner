package game

import "../assets"
import "core:log"
import rl "vendor:raylib"

PLAYER_INIT_STATE :: Player_State.Running
PLAYER_JUMP_FORCE :: 400.0
PLAYER_GRAVITY :: 800.0

// fast mapping of player_state to animation_name for blazing fast lookup,
// b/c the game's architecture might be questionable at best and collapse at any moment,
// but when it does, it will collapse FAST :P
player_animations := [Player_State]Animation_Name {
	.Running   = .Player_Run,
	.Jumping   = .Player_Jump,
	.Attacking = nil, // TODO: Add back in
	.Hurt      = .Player_Hurt,
	.Dead      = .Player_Dead,
}


Player_State :: enum {
	Running,
	Jumping,
	Attacking,
	Hurt,
	Dead,
}


Player :: struct {
	using pos: Vec2,
	velocity:  Vec2,
	state:     Player_State,
}


player_init :: proc(pos: Vec2, state: Player_State) -> Player {
	return Player{pos = pos, velocity = VEC2_ZERO, state = state}
}

player_rect :: proc(player: Player) -> Rect {
	animation := player_get_animation(player)

	return Rect {
		x = player.x,
		y = player.y,
		width = f32(animation.animation_info.frame_width),
		height = f32(animation.animation_info.frame_height),
	}
}

player_update :: proc(player: ^Player, floor_y: f32, dt: f32) {
	if rl.IsKeyDown(rl.KeyboardKey.SPACE) && player.state != .Jumping {
		player.state = .Jumping
		player_reset_animation(player^)
	}

	log.debug("floor_y:", floor_y, "player.y", player.y)
	if player.y >= floor_y {
		player.y = floor_y
		player.state = .Running
	}
}


player_draw :: proc(player: Player) {
	animation := player_get_animation(player)
	assets.animation_play(animation, player)

	// draw collision rectangle for player in debug mode
	when ODIN_DEBUG {
		player_rect := player_rect(player)
		rl.DrawRectangleLinesEx(player_rect, 1.0, rl.BLUE)
	}
}


player_hits_obstacle :: proc(player: Player, obstacle: Obstacle) -> bool {
	player_rect := player_rect(player)
	obstacle_rect := obstacle_rect(obstacle)

	log.debug("player_rect:", player_rect)
	log.debug("obstacle_rect", obstacle_rect)

	return rl.CheckCollisionRecs(player_rect, obstacle_rect)
}

player_get_animation :: proc(player: Player) -> ^Animation {
	asset_cache := (^Asset_Cache)(context.user_ptr)
	animation_name := player_animations[player.state]
	return assets.get(asset_cache, animation_name)
}

player_reset_animation :: proc(player: Player) {
	animation := player_get_animation(player)
	assets.animation_reset(animation)
}

