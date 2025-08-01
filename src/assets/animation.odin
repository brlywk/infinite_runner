package assets

import rl "vendor:raylib"

// 
// Structs
//

Animation :: struct {
	texture:            rl.Texture2D,
	animation_info:     Animation_Info,
	current_frame:      int,
	animation_finished: bool,
	timer:              f32,
}


Animation_Info :: struct {
	frame_width:  i32,
	frame_height: i32,
	num_frames:   int,
	duration:     f32,
	repeats:      bool,
}


//
// Procs
//


@(private)
load_animation :: proc(animation_name: Animation_Name) -> Animation {
	animation_asset := animations[animation_name]
	animation_info := animation_asset.type.(Animation_Info)
	texture := load_texture_data(animation_asset.data)

	return Animation{texture = texture, animation_info = animation_info}
}

animaton_vec2 :: proc(animation: ^Animation) -> rl.Vector2 {
	return rl.Vector2 {
		f32(animation.animation_info.frame_width),
		f32(animation.animation_info.frame_height),
	}
}

animation_rect :: proc(animation: ^Animation) -> rl.Rectangle {
	return rl.Rectangle {
		x = f32(animation.current_frame) * f32(animation.animation_info.frame_width),
		y = 0,
		width = f32(animation.animation_info.frame_width),
		height = f32(animation.animation_info.frame_height),
	}
}

animation_play :: proc(
	animation: ^Animation,
	rect: rl.Rectangle,
	speed_modifier: f32 = 1.0,
	freeze_animation := false,
	color_tint := rl.WHITE,
) -> (
	animation_ended: bool,
) {
	pos, _ := rect_xy_size(rect)

	if freeze_animation || (!animation.animation_info.repeats && animation.animation_finished) {
		rl.DrawTextureRec(animation.texture, animation_rect(animation), pos, rl.WHITE)
		return animation.animation_finished
	}

	animation.timer += rl.GetFrameTime()

	frame_time :=
		animation.animation_info.duration /
		(f32(animation.animation_info.num_frames) * speed_modifier)
	target_frame := int(animation.timer / frame_time)

	if animation.animation_info.repeats {
		animation.current_frame = target_frame % animation.animation_info.num_frames
		if animation.timer >= animation.animation_info.duration do animation.timer = 0.0
	} else {
		if target_frame >= animation.animation_info.num_frames {
			animation.current_frame = int(animation.animation_info.num_frames) - 1
			animation.animation_finished = true
		} else {
			animation.current_frame = target_frame
		}
	}

	rl.DrawTextureRec(animation.texture, animation_rect(animation), pos, color_tint)
	return animation.animation_finished
}

animation_reset :: proc(animation: ^Animation) {
	animation.current_frame = 0
	animation.animation_finished = false
	animation.timer = 0.0
}

rect_xy_size :: proc(rect: rl.Rectangle) -> (pos, size: rl.Vector2) {
	pos = {rect.x, rect.y}
	size = {rect.width, rect.height}
	return
}

