package main

Animation :: union {
	Animation_Info,
}

Animation_Info :: struct {
	frames:  i32,
	speed:   f32,
	repeats: bool,
}

