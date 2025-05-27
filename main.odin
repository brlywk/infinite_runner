package main

import "core:fmt"
import "core:mem"
import rl "vendor:raylib"

/*
    Constants
*/

SCREEN_WIDTH :: 640
SCREEN_HEIGHT :: 480
GRAVITY :: 800.0
JUMP_FORCE :: -400
GAME_SPEED :: 200.0

/*
    Structs
*/


Player :: struct {
	using position:    rl.Vector2,
	current_animation: ^Animation,
	run_animation:     Animation,
	jump_animation:    Animation,
	velocity:          rl.Vector2,
	jumping:           bool,
	jump_sound:        rl.Sound,
	death_sound:       rl.Sound,
}

Wall :: struct {
	using position: rl.Vector2,
	size:           rl.Vector2,
	active:         bool,
}

Game_State :: struct {
	player:      Player,
	walls:       [dynamic]Wall,
	score:       i32,
	game_over:   bool,
	spawn_timer: f32,
}

/*
    Main
*/

// check_tracking_allocator returns whether alloc has leaked any memory yet and prints the result to stdout.
// Parameter reset can be used to also reset the allocator if required.
check_tracking_allocator :: proc(alloc: ^mem.Tracking_Allocator, reset: bool = false) -> bool {
	for _, leak in alloc.allocation_map {
		fmt.printf("==== %v leaked %m\n", leak.location, leak.size)
	}

	if reset {
		mem.tracking_allocator_destroy(alloc)
	}

	return len(alloc.allocation_map) > 0
}

main :: proc() {
	// tracking allocator for learning purposes
	track: mem.Tracking_Allocator
	mem.tracking_allocator_init(&track, context.allocator)
	// defer mem.tracking_allocator_destroy(&track) - see comment below
	context.allocator = mem.tracking_allocator(&track)
	defer check_tracking_allocator(&track, true) // use helper to destroy allocator

	// main window
	rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "Infinite Runner")
	defer rl.CloseWindow()

	// sounds
	rl.InitAudioDevice()
	defer rl.CloseAudioDevice()

	rl.SetTargetFPS(60)

	// animations for player
	player_run_anim := load_animation("sprites/player/run.png", 32, 32, 6, 0.75, true)
	player_jump_anim := load_animation("sprites/player/jump.png", 32, 36, 4, 0.5, false)

	game := Game_State {
		player = {
			position          = {100, SCREEN_HEIGHT - 50 - 32}, // player size is 32x32
			velocity          = {0, 0},
			jumping           = false,
			jump_sound        = rl.LoadSound("sounds/jump.mp3"),
			death_sound       = rl.LoadSound("sounds/hit.mp3"),
			run_animation     = player_run_anim,
			jump_animation    = player_jump_anim,
			current_animation = &player_run_anim,
		},
		walls = make([dynamic]Wall),
		score = 0,
		game_over = false,
		spawn_timer = 0,
	}

	// set volume of sounds
	rl.SetSoundVolume(game.player.jump_sound, 0.5)
	rl.SetSoundVolume(game.player.death_sound, 0.5)

	for !rl.WindowShouldClose() {
		dt := rl.GetFrameTime()

		if !game.game_over {
			update_game(&game, dt)
		} else {
			if rl.IsKeyPressed(.R) {
				restart_game(&game)
			}
		}

		draw_game(&game, dt)
	}

	delete(game.walls)
}

/*
    Functions
*/

update_game :: proc(game: ^Game_State, dt: f32) {
	// input
	if rl.IsKeyPressed(.SPACE) && !game.player.jumping {
		game.player.velocity.y = JUMP_FORCE
		game.player.jumping = true
		rl.PlaySound(game.player.jump_sound)
		switch_animation(&game.player, &game.player.jump_animation)
	}

	// player "physics"
	game.player.velocity.y += GRAVITY * dt
	game.player.y += game.player.velocity.y * dt

	// collision, dt
	ground_y := SCREEN_HEIGHT - 50 - get_animation_height(game.player.current_animation^)
	if game.player.y >= ground_y {
		game.player.y = ground_y
		game.player.velocity.y = 0
		game.player.jumping = false
		switch_animation(&game.player, &game.player.run_animation)
	}

	// spawn walls
	game.spawn_timer += dt
	if game.spawn_timer >= 2.0 {
		spawn_wall(game)
		game.spawn_timer = 0
	}

	// update walls
	for &wall in game.walls {
		if !wall.active {
			continue
		}

		wall.position.x -= GAME_SPEED * dt

		// remove offscreen walls
		if wall.position.x + wall.size.x < 0 {
			wall.active = false
			game.score += 10
		}

		// collision detection
		if check_collision(game.player, wall) {
			rl.PlaySound(game.player.death_sound)
			game.game_over = true
		}
	}

	// delete inactive walls
	for i := len(game.walls) - 1; i >= 0; i -= 1 {
		if !game.walls[i].active {
			ordered_remove(&game.walls, i)
		}
	}
}

spawn_wall :: proc(game: ^Game_State) {
	wall := Wall {
		position = {SCREEN_WIDTH, SCREEN_HEIGHT - 50 - 60},
		size     = {30, 60},
		active   = true,
	}

	append(&game.walls, wall)
}

// check if player collides with wall
check_collision :: proc(player: Player, wall: Wall) -> bool {
	player_size := rl.Vector2 {
		get_animation_width(player.current_animation^),
		get_animation_height(player.current_animation^),
	}

	return(
		player.x < wall.position.x + wall.size.x &&
		player.x + player_size.x > wall.position.x &&
		player.y < wall.position.y + wall.size.y &&
		player.y + player_size.y > wall.position.y \
	)
}

draw_game :: proc(game: ^Game_State, dt: f32) {
	rl.BeginDrawing()
	rl.ClearBackground(rl.SKYBLUE)
	defer rl.EndDrawing()

	// ground
	rl.DrawRectangle(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50, rl.GREEN)

	// player
	play_animation(game.player.current_animation, game.player.position, dt)

	// walls
	for wall in game.walls {
		if wall.active {
			rl.DrawRectangleV(wall.position, wall.size, rl.GRAY)
		}
	}

	// score
	score_text := fmt.ctprintf("Score: %d", game.score)
	rl.DrawText(score_text, 10, 10, 20, rl.BLACK)

	// game over screen
	if game.game_over {
		rl.DrawText("GAME OVER", SCREEN_WIDTH / 2 - 100, SCREEN_HEIGHT / 2 - 20, 40, rl.RED)
		rl.DrawText(
			"Press R to restart",
			SCREEN_WIDTH / 2 - 80,
			SCREEN_HEIGHT / 2 + 30,
			30,
			rl.WHITE,
		)
	}
}

restart_game :: proc(game: ^Game_State) {
	game.player.position = {100, SCREEN_HEIGHT - 100}
	game.player.velocity = {100, 100}
	game.player.jumping = false
	game.score = 0
	game.game_over = false
	game.spawn_timer = 0

	clear(&game.walls)
}

