package main

import "core:fmt"
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
	position:    rl.Vector2,
	velocity:    rl.Vector2,
	size:        rl.Vector2,
	jumping:     bool,
	jump_sound:  rl.Sound,
	death_sound: rl.Sound,
	sprite:      rl.Texture2D,
}

Wall :: struct {
	position: rl.Vector2,
	size:     rl.Vector2,
	active:   bool,
}

GameState :: struct {
	player:      Player,
	walls:       [dynamic]Wall,
	score:       i32,
	game_over:   bool,
	spawn_timer: f32,
}

/*
    Main
*/

main :: proc() {
	// main window
	rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "Infinite Runner")
	defer rl.CloseWindow()

	// sounds
	rl.InitAudioDevice()
	defer rl.CloseAudioDevice()

	rl.SetTargetFPS(60)

	game := GameState {
		player = {
			position    = {100, SCREEN_HEIGHT - 50 - 32}, // player size is 32x32
			velocity    = {0, 0},
			size        = {32, 32},
			jumping     = false,
			jump_sound  = rl.LoadSound("sounds/jump.mp3"),
			death_sound = rl.LoadSound("sounds/hit.mp3"),
			sprite      = rl.LoadTexture("sprites/player/player.png"),
		},
		walls = make([dynamic]Wall),
		score = 0,
		game_over = false,
		spawn_timer = 0,
	}

	for !rl.WindowShouldClose() {
		dt := rl.GetFrameTime()

		if !game.game_over {
			update_game(&game, dt)
		} else {
			if rl.IsKeyPressed(.R) {
				restart_game(&game)
			}
		}

		draw_game(&game)
	}

	delete(game.walls)
}

/*
    Functions
*/

update_game :: proc(game: ^GameState, dt: f32) {
	// input
	if rl.IsKeyPressed(.SPACE) && !game.player.jumping {
		game.player.velocity.y = JUMP_FORCE
		game.player.jumping = true
		rl.PlaySound(game.player.jump_sound)
	}

	// player "physics"
	game.player.velocity.y += GRAVITY * dt
	game.player.position.y += game.player.velocity.y * dt

	// collision
	ground_y := SCREEN_HEIGHT - 50 - game.player.size.y
	if game.player.position.y >= ground_y {
		game.player.position.y = ground_y
		game.player.velocity.y = 0
		game.player.jumping = false
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

spawn_wall :: proc(game: ^GameState) {
	wall := Wall {
		position = {SCREEN_WIDTH, SCREEN_HEIGHT - 50 - 60},
		size     = {30, 60},
		active   = true,
	}

	append(&game.walls, wall)
}

// check if player collides with wall
check_collision :: proc(player: Player, wall: Wall) -> bool {
	return(
		player.position.x < wall.position.x + wall.size.x &&
		player.position.x + player.size.x > wall.position.x &&
		player.position.y < wall.position.y + wall.size.y &&
		player.position.y + player.size.y > wall.position.y \
	)
}

draw_game :: proc(game: ^GameState) {
	rl.BeginDrawing()
	rl.ClearBackground(rl.SKYBLUE)
	defer rl.EndDrawing()

	// ground
	rl.DrawRectangle(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50, rl.GREEN)

	// player
	rl.DrawTextureV(game.player.sprite, game.player.position, rl.WHITE)

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

restart_game :: proc(game: ^GameState) {
	game.player.position = {100, SCREEN_HEIGHT - 100}
	game.player.velocity = {100, 100}
	game.player.jumping = false
	game.score = 0
	game.game_over = false
	game.spawn_timer = 0

	clear(&game.walls)
}

