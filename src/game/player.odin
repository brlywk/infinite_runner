package game

import "../assets"
import "core:log"
import rl "vendor:raylib"

PLAYER_INITIAL_STATE :: Player_State.Running
PLAYER_HITBOX_OFFSET :: Vec2{4, 4} // make the hitbox 2px smaller than the sprite sheet
PLAYER_JUMP_FORCE :: 400.0
PLAYER_GRAVITY :: 800.0

// mapping of player_state to animation_name for blazing fast lookup,
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
	hitbox:    Vec2, // for a better game feel, the hitbox should be smaller than the sprite
}


player_init :: proc(pos: Vec2, state: Player_State) -> Player {
	// calculate the optimal hitbox based on the two primary animation states
	anim_run := player_get_animation_for_state(.Running)
	anim_jump := player_get_animation_for_state(.Jumping)

	anim_run_size := assets.animaton_vec2(anim_run)
	anim_jump_size := assets.animaton_vec2(anim_jump)

	hitbox := min_vec2(anim_run_size, anim_jump_size) - PLAYER_HITBOX_OFFSET / 2
	log.debug("hitbox:", hitbox)

	return Player{pos = pos, velocity = VEC2_ZERO, state = state, hitbox = hitbox}
}

player_rect :: proc(player: Player) -> Rect {
	return Rect{x = player.x, y = player.y, width = player.hitbox.x, height = player.hitbox.y}
}

player_update :: proc(player: ^Player, floor_y: f32, dt: f32) {
	animation := player_get_animation(player^)
	anim_height := f32(animation.texture.height)

	// player jumping
	if rl.IsKeyDown(rl.KeyboardKey.SPACE) && player.state != .Jumping {
		player.state = .Jumping
		player_reset_animation(player^)
		player.velocity.y -= PLAYER_JUMP_FORCE
	}

	// gravity, as always, is dragging everyone down
	player.velocity.y += PLAYER_GRAVITY * dt
	player.y += player.velocity.y * dt

	// floor collision detection
	// log.debug("player:", player.y + anim_height, "floor:", floor_y)
	if player.y + anim_height >= floor_y {
		player.state = .Running
		player.y = floor_y - anim_height
		player.velocity.y = 0
	}
}


player_draw :: proc(player: Player, freeze_animation := false) {
	animation := player_get_animation(player)
	assets.animation_play(animation, player, freeze_animation)

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

player_get_animation_for_state :: proc(state: Player_State) -> ^Animation {
	asset_cache := (^Asset_Cache)(context.user_ptr)
	animation_name := player_animations[state]
	return assets.get(asset_cache, animation_name)
}

// Retrieves the appropriate animation for the player from the asset cache,
// based on the state the player is in (e.g. Player_State.Running).
player_get_animation :: proc(player: Player) -> ^Animation {
	return player_get_animation_for_state(player.state)
}

player_reset_animation :: proc(player: Player) {
	animation := player_get_animation(player)
	assets.animation_reset(animation)
}

