package sprite

// We need an Animation union b/c we need the ability to assign "nil" to an
// animation field if that thing should not have an animation.
Animation :: union {
	Animation_Info,
}

Animation_Info :: struct {
	frames:  i32,
	speed:   f32,
	repeats: bool,
}

