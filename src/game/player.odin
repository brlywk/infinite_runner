package game

import "../assets"
import "core:log"
import rl "vendor:raylib"


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
	using hitbox: Rect, // for a better game feel, the hitbox should be smaller than the sprite
	velocity:     Vec2,
	state:        Player_State,
	prev_state:   Player_State,
	health:       u8,
}


player_init :: proc(pos: Vec2, state: Player_State) -> Player {
	// calculate the optimal hitbox based on the two primary animation states
	anim_run := player_get_animation_for_state(.Running)
	anim_jump := player_get_animation_for_state(.Jumping)

	anim_run_size := assets.animaton_vec2(anim_run)
	anim_jump_size := assets.animaton_vec2(anim_jump)

	hitbox_size := min_vec2(anim_run_size, anim_jump_size) - PLAYER_HITBOX_OFFSET
	log.debug("pos", pos, "hitbox size:", hitbox_size)
	hitbox := Rect {
		x      = pos.x + (hitbox_size.x / 2),
		y      = pos.y, // don't y-offset the hitbox, that messes with jumping and drawing
		width  = hitbox_size.x,
		height = hitbox_size.y,
	}
	log.debug("hitbox:", hitbox)


	return Player {
		velocity = VEC2_ZERO,
		state = state,
		prev_state = state,
		hitbox = hitbox,
		health = PLAYER_INITIAL_HEALTH,
	}
}

player_update :: proc(player: ^Player, floor_y: f32, dt: f32) {
	// player jumping
	if rl.IsKeyDown(rl.KeyboardKey.SPACE) && player.state != .Jumping {
		player_change_state(player, .Jumping)
		player_reset_animation(player^)
		player.velocity.y -= PLAYER_JUMP_FORCE
	}

	// gravity, as always, is dragging everyone down
	player.velocity.y += PLAYER_GRAVITY * dt
	player.y += player.velocity.y * dt

	// floor collision detection
	if player.y + player.height >= floor_y {
		// only change state here if it's jumping -> running, otherwise
		// collision detection goes haywire
		if player.state == .Jumping {
			player_change_state(player, .Running)
		}
		player.y = floor_y - player.height
		player.velocity.y = 0
	}

	// NOTE: Collision detection is done in:
	// state_playing_draw.odin -> playing_check_player_collision()
}


// Returns if the current player animation has finished playing.
player_draw :: proc(player: Player, freeze_animation := false) -> bool {
	animation := player_get_animation(player)
	animation_ended := assets.animation_play(animation, player, freeze_animation)

	// draw collision rectangle for player in debug mode
	when ODIN_DEBUG {
		rl.DrawRectangleLinesEx(player, 1.0, rl.BLUE)
	}

	return animation_ended
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

player_get_sprite_size :: proc(player: Player) -> Vec2 {
	current_animation := player_get_animation(player)
	return Vec2 {
		f32(current_animation.animation_info.frame_width),
		f32(current_animation.animation_info.frame_height),
	}
}

player_get_pos :: proc(player: Player) -> Vec2 {
	return Vec2{player.x, player.y}
}

player_reset_animation :: proc(player: Player) {
	animation := player_get_animation(player)
	assets.animation_reset(animation)
}

player_change_state :: proc(player: ^Player, new_state: Player_State, loc := #caller_location) {
	if player.state == new_state do return

	player.prev_state = player.state
	player.state = new_state

	log.debug("player state change requested from:", loc)
	log.debugf("player state change: old=%v new=%v", player.prev_state, new_state)
}

