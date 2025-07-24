package main

import "base:runtime"
import "core:log"
import "core:math/rand"
import "core:mem"
import "core:time"
import rl "vendor:raylib"

// 
// TYPES
//

Vec2 :: rl.Vector2
Rect :: rl.Rectangle

//
// Constants
//

WINDOW_NAME :: "Infinite Runner"

// resolution the game should be rendered with
GAME_WIDTH :: 320
GAME_HEIGHT :: 240

// initial scaling for window dimensions
INIT_SCALING :: 3


//
// Main
//

main :: proc() {
	// DEBUG SETUP
	//
	log_level := log.Level.Warning

	when ODIN_DEBUG {
		track: mem.Tracking_Allocator
		mem.tracking_allocator_init(&track, context.allocator)
		context.allocator = mem.tracking_allocator(&track)
		defer check_tracking_allocator(&track, true)

		log_level = log.Level.Debug
	}

	// LOGGING
	//
	context.logger = log.create_console_logger(log_level)
	defer log.destroy_console_logger(context.logger)

	// RNG
	//
	seed := u64(time.time_to_unix_nano(time.now()))
	rng := rand.create(seed)
	context.random_generator = runtime.default_random_generator(&rng)

	// RAYLIB
	//
	rl.InitWindow(GAME_WIDTH * INIT_SCALING, GAME_HEIGHT * INIT_SCALING, WINDOW_NAME)
	defer rl.CloseWindow()

	render_target := rl.LoadRenderTexture(GAME_WIDTH, GAME_HEIGHT)
	defer rl.UnloadRenderTexture(render_target)

	rl.SetTargetFPS(60)
	rl.SetWindowState({.WINDOW_RESIZABLE, .VSYNC_HINT})

	// GAME INIT STUFF
	//
	game := Game {
		state = .Playing,
		font  = load_font(.Independent_Modern),
	}

	// TODO: Delete
	sprite_handle := load_texture(.Floor)

	// GAME LOOP
	//
	for !rl.WindowShouldClose() {
		defer free_all(context.temp_allocator)

		// UPDATE
		game_update(&game)

		// DRAW
		// we draw to the render texture first...
		{
			rl.BeginTextureMode(render_target)
			defer rl.EndTextureMode()

			// vvv actual drawing instructions go here :P vvv
			game_draw(game)
			rl.DrawTextEx(game.font, "Just a test", {0, 24}, 8.0, 0.0, rl.WHITE)
			rl.DrawTexture(sprite_handle.texture, 0, 64, rl.WHITE)
		}

		// ...and upscale that to the window dimensions
		{
			rl.BeginDrawing()
			defer rl.EndDrawing()

			window_width := f32(rl.GetScreenWidth())
			window_height := f32(rl.GetScreenHeight())
			scale := min(window_width / GAME_WIDTH, window_height / GAME_HEIGHT)
			// log.debug("scale:", scale)

			// rect to use for upscaling
			render_rect := Rect {
				x      = 0,
				y      = 0,
				width  = GAME_WIDTH * scale,
				height = GAME_HEIGHT * scale,
			}
			// log.debug("render_rect", render_rect)

			// rect to use for flipping the render texture b/c OpenGL
			flip_rect := Rect {
				x      = 0,
				y      = 0,
				width  = GAME_WIDTH,
				height = -GAME_HEIGHT, // we need to flip the y-axis 
			}
			// log.debug("flip_rect", flip_rect)

			rl.ClearBackground(rl.BLACK)
			rl.DrawTexturePro(render_target.texture, flip_rect, render_rect, {0, 0}, 0.0, rl.WHITE)
		}
	}
}

