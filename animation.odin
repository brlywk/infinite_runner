package main

import rl "vendor:raylib"

Animation :: struct {
	sprite_sheet:  rl.Texture2D,
	rect:          rl.Rectangle,
	num_frames:    i32,
	current_frame: i32,
	timer:         f32,
	duration:      f32,
	loop:          bool,
	loop_finished: bool,
}

load_animation :: proc(
	file_name: cstring,
	frame_width, frame_height, num_frames: i32,
	duration: f32,
	loop: bool,
) -> Animation {
	texture := rl.LoadTexture(file_name)

	return Animation {
		sprite_sheet = texture,
		rect = rl.Rectangle{x = 0, y = 0, width = f32(frame_width), height = f32(frame_height)},
		current_frame = 0,
		num_frames = num_frames,
		timer = 0.0,
		duration = duration,
		loop = loop,
		loop_finished = false,
	}
}

play_animation :: proc(anim: ^Animation, position: rl.Vector2, dt: f32) {
	// check if this needs to be looped, and if not, hang onto the last frame
	if !anim.loop && anim.loop_finished {
		rl.DrawTextureRec(anim.sprite_sheet, anim.rect, position, rl.WHITE)
		return
	}

	// increase timer
	anim.timer += dt

	// frame_time is the time in seconds each frame of the animation should last
	frame_time := anim.duration / f32(anim.num_frames)
	target_frame := i32(anim.timer / frame_time)

	// which frame should be drawn right now based on time
	if anim.loop {
		anim.current_frame = target_frame % anim.num_frames
		if anim.timer >= anim.duration {
			anim.timer = 0.0
		}
	} else {
		if target_frame >= anim.num_frames {
			// hang on to last frame
			anim.current_frame = anim.num_frames - 1
			anim.loop_finished = true
		} else {
			anim.current_frame = target_frame
		}
	}

	// slide the rect over to the correct position
	anim.rect.x = f32(anim.current_frame) * anim.rect.width

	// draw current animation frame
	rl.DrawTextureRec(anim.sprite_sheet, anim.rect, position, rl.WHITE)
}

get_animation_height :: proc(anim: Animation) -> f32 {
	return anim.rect.height
}

get_animation_width :: proc(anim: Animation) -> f32 {
	return anim.rect.width
}

switch_animation :: proc(player: ^Player, target_animation: ^Animation) {
	if player.current_animation == target_animation {
		return
	}

	if !target_animation.loop {
		target_animation.loop_finished = false
		target_animation.current_frame = 0
		target_animation.timer = 0.0
		target_animation.rect.x = 0.0
	}

	player.current_animation = target_animation
}

