package scaling

// With increasing game speed, many things need to scale at different rates
// to make the game "feel good". All of these rates are centralized here.
Factor :: struct {
	animation: f32,
	sound:     f32,
	gravity:   f32,
	obstacle:  f32,
}

FACTOR :: Factor {
	animation = 0.3,
	sound     = 0.1,
	gravity   = 0.4,
	obstacle  = 0.4,
}

