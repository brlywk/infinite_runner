package game

import "core:log"
import "core:math"
import "core:math/rand"
import rl "vendor:raylib"

Particle_Options :: struct {
	velocity:             Vec2,
	velocity_variation:   Vec2,
	color_start:          rl.Color,
	color_end:            rl.Color,
	size_start:           f32,
	size_end:             f32,
	size_variation:       f32,
	lifetime:             f32,
	particles_per_second: f32,
}

Particle :: struct {
	position:           Vec2,
	velocity:           Vec2,
	velocity_variation: Vec2,
	color_start:        rl.Color,
	color_end:          rl.Color,
	size_start:         f32,
	size_end:           f32,
	lifetime:           f32,
	lifetime_remaining: f32,
}

Particle_System :: struct {
	options:       Particle_Options,
	max_particles: u8, // assumption: we should not need more than 256 particles
	particles:     [dynamic]Particle,
	spawn_timer:   f32,
}


particle_system_create :: proc(options: Particle_Options, max_particles: u8) -> Particle_System {
	assert(options.particles_per_second > 0.0)

	return Particle_System {
		options       = options,
		max_particles = max_particles,
		// Note: For the scope of the game it should be performant enough to not use an object pool
		particles     = make([dynamic]Particle),
		spawn_timer   = 0.0,
	}
}

particle_system_destroy :: proc(system: ^Particle_System) {
	delete(system.particles)
}

particle_system_update :: proc(system: ^Particle_System, pos: Vec2, dt: f32) {
	// first: update existing particles with lifetime
	for &particle in system.particles do if particle.lifetime_remaining > 0 {
		// position
		particle.position += particle.velocity * dt

		// lifetime
		particle.lifetime_remaining -= dt
	}

	// second: remove "dead" particles
	for i := len(system.particles) - 1; i >= 0; i -= 1 {
		if system.particles[i].lifetime_remaining <= 0 {
			unordered_remove(&system.particles, i)
		}
	}

	// third: spawn new particles
	system.spawn_timer -= dt
	// log.debugf(
	// 	"particle update: timer=%f num_particles=%v max_particles=%v",
	// 	system.spawn_timer,
	// 	len(system.particles),
	// 	system.max_particles,
	// )
	if system.spawn_timer <= 0 && len(system.particles) < int(system.max_particles) {
		spawn_particle(system, pos)
		system.spawn_timer = 1.0 / system.options.particles_per_second
	}
}

@(private = "file")
spawn_particle :: proc(system: ^Particle_System, pos: Vec2) {
	// create velocity with variation
	vel_x :=
		system.options.velocity.x +
		rand.float32_range(
			-system.options.velocity_variation.x / 2,
			system.options.velocity_variation.x / 2,
		)
	vel_y :=
		system.options.velocity.y +
		rand.float32_range(
			-system.options.velocity_variation.y / 2,
			system.options.velocity_variation.y / 2,
		)

	// create size with variation
	size_start :=
		system.options.size_start +
		rand.float32_range(-system.options.size_variation / 2, system.options.size_variation / 2)
	size_start = max(size_start, 1.0)

	particle := Particle {
		position           = pos,
		velocity           = {vel_x, vel_y},
		color_start        = system.options.color_start,
		color_end          = system.options.color_end,
		size_start         = size_start,
		size_end           = system.options.size_end,
		lifetime           = system.options.lifetime,
		lifetime_remaining = system.options.lifetime,
	}

	append(&system.particles, particle)
}

particle_system_draw :: proc(system: Particle_System) {
	for particle in system.particles do if particle.lifetime_remaining > 0 {
		// percentage of life the particle has reachted, e.g.:
		//  lifetime = 1.0, lifetime_remaining = 0.2
		//  1.0 - (0.2 / 1.0) = 0.8 -> particle is at 80% of it's lifetime 
		t := 1.0 - (particle.lifetime_remaining / particle.lifetime)

		color := rl.Color {
			u8(math.lerp(f32(particle.color_start.r), f32(particle.color_end.r), t)), // r
			u8(math.lerp(f32(particle.color_start.g), f32(particle.color_end.g), t)), // g
			u8(math.lerp(f32(particle.color_start.b), f32(particle.color_end.b), t)), // b
			u8(math.lerp(f32(particle.color_start.a), f32(particle.color_end.a), t)), // alpha
		}

		size := math.lerp(particle.size_start, particle.size_end, t)
		size_vec := Vec2{size, size}

		// log.debugf("drawing particle: pos=%v, size=%v color=%v", particle.position, size_vec, color)
		rl.DrawRectangleV(particle.position, size_vec, color)
	}
}

