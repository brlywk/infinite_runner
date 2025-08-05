package game

import "../global"
import "../global/assets"
import "../global/scaling"
import "core:log"
import "core:math"
import "core:math/rand"
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

// possible footstep sounds for player movement
@(rodata)
player_footstep_sounds := []Sound_Name{.Step_01, .Step_02, .Step_03, .Step_04, .Step_05}


Player_State :: enum {
	Running,
	Jumping,
	Attacking,
	Hurt,
	Dead,
}


Player :: struct {
	using hitbox:        Rect, // for a better game feel, the hitbox should be smaller than the sprite
	velocity:            Vec2,
	state:               Player_State,
	prev_state:          Player_State,
	health:              u8,
	last_footstep_sound: f64,
	running_dust:        Particle_System,
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
		running_dust = particle_system_create(DUST_PARTICLE_OPTION, PLAYER_RUNNING_DUST_PARTICLES),
	}
}

// Update the player.
//
// Note: Yes, player is part of game as well, but to keep the "player API" consistent,
// the player parameter is still there.
player_update :: proc(player: ^Player, game: Game, floor_y: f32, dt: f32) {
	player.prev_state = player.state

	// update particle system; draw first to be behind player sprite
	if player.state == .Running {
		player_feet_pos := Vec2 {
			player.x + player.width / 2 + PLAYER_RUNNING_DUST_X_OFFSET,
			player.y + player.height,
		}
		particle_system_update(&player.running_dust, player_feet_pos, dt)
	}

	// player jumping
	if rl.IsKeyDown(.SPACE) && player.state not_in PLAYER_NO_JUMPING_STATES {
		player_change_state(player, .Jumping)
		player_reset_animation(player^)
		player.velocity.y -= PLAYER_JUMP_FORCE
	}

	// gravity, as always, is dragging everyone down;
	// as with other things, logarithmically scale gravity to have the player fall faster
	// with increased game speed
	gravity_scaling := 1.0 + math.ln(game.speed / GAME_SPEED_INIT) * scaling.FACTOR.gravity
	gravity := PLAYER_GRAVITY * gravity_scaling * dt
	player.velocity.y += gravity
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
}

player_destroy :: proc(player: ^Player) {
	particle_system_destroy(&player.running_dust)
}


// Returns if the current player animation has finished playing.
player_draw :: proc(player: Player, game: Game, freeze_animation := false) -> bool {
	animation := player_get_animation(player)
	animation_ended := assets.animation_play(
		animation,
		player,
		speed_multiplier(game),
		freeze_animation,
		// tint the player animation sprite red while in "hurt" state for
		// better visual feedback (and many new bugs to fix :P)
		player.state == .Hurt ? rl.RED : rl.WHITE,
	)

	// draw particle effect
	if player.state == .Running {
		particle_system_draw(player.running_dust)
	}

	// draw collision rectangle for player in debug mode
	when ODIN_DEBUG {
		rl.DrawRectangleLinesEx(player, 1.0, rl.BLUE)
	}

	return animation_ended
}

player_get_animation_for_state :: proc(state: Player_State) -> ^Animation {
	animation_name := player_animations[state]
	return global.get_asset(animation_name)
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

player_play_sound :: proc(player: ^Player, game: Game) {
	sound: assets.Sound

	switch player.state {
	case .Running:
		foot_step := rand.choice(player_footstep_sounds)
		sound = global.get_asset(foot_step)

	case .Jumping:
		sound = global.get_asset(Sound_Name.Jump)

	case .Hurt, .Dead:
		sound = global.get_asset(Sound_Name.Hit)

	case .Attacking:
		sound = global.get_asset(Sound_Name.Attack)
	}

	volume := global.sound_volume(sound)
	rl.SetSoundVolume(sound.rl_sound, volume)

	// for any other sound than running:
	// play it immediately
	if player.state != .Running && player.state != player.prev_state {
		log.debugf("Play sound for state: %v", player.state)
		rl.PlaySound(sound.rl_sound)
		return
	}

	// for running sounds, check if we should play a new footstep
	// sound already
	now := rl.GetTime() - game.started
	// we need some logarithmic dampening as linear scaling sounds... wrong
	audio_scaling := 1.0 + math.ln(speed_multiplier(game)) * scaling.FACTOR.sound
	footstep_every := PLAYER_INITIAL_FOOTSTEP_INTERVAL * audio_scaling
	if now > player.last_footstep_sound + f64(footstep_every) && player.state == .Running {
		log.debugf("Play running sound: footstep_every=%v", footstep_every)
		rl.PlaySound(sound.rl_sound)
		player.last_footstep_sound = now
	}
}

