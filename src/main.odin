package main

import "base:runtime"
import "core:log"
import "core:math/rand"
import "core:mem"
import "core:time"
import "game"
import "global"
import rl "vendor:raylib"

// 
// TYPES
//

Vec2 :: rl.Vector2
Rect :: rl.Rectangle

//
// Constants
//

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
	rl.InitWindow(GAME_WIDTH * INIT_SCALING, GAME_HEIGHT * INIT_SCALING, game.GAME_TITLE)
	defer rl.CloseWindow()

	rl.InitAudioDevice()
	defer rl.CloseAudioDevice()

	render_target := rl.LoadRenderTexture(GAME_WIDTH, GAME_HEIGHT)
	defer rl.UnloadRenderTexture(render_target)

	// Keeping this commented out as a "note to self":
	// For some reason, Odin + Raylib have an issue if the monitor refresh rate is not EXACTLY the same
	// as the target set here, causing micro-stutters with e.g. parallax background scrolling, so
	// don't set a target but use VSYNC instead...
	// rl.SetTargetFPS(60)
	rl.SetWindowState({.WINDOW_RESIZABLE, .VSYNC_HINT})
	rl.SetExitKey(.KEY_NULL) // disable ESC key exiting the game


	// GAME INIT
	//
	// settings
	game_settings := global.settings_load()

	// initialize scaling variables
	window_width: f32
	window_height: f32
	scale: f32
	scaled_width: f32
	scaled_height: f32
	window_pos: rl.Vector2

	// try to load window settings, or set them to defaults
	if global.settings_window_data_is_set(game_settings) {
		rl.SetWindowPosition(i32(game_settings.window_pos.x), i32(game_settings.window_pos.y))
		rl.SetWindowSize(i32(game_settings.window_width), i32(game_settings.window_height))

		window_width = game_settings.window_width
		window_height = game_settings.window_height
		scale = min(window_width / GAME_WIDTH, window_height / GAME_HEIGHT)
		scaled_width = GAME_WIDTH * scale
		scaled_height = GAME_HEIGHT * scale
		window_pos = rl.GetWindowPosition()
	} else {
		// initial state needs to be calculated
		window_width = f32(rl.GetScreenWidth())
		window_height = f32(rl.GetScreenHeight())
		scale = min(window_width / GAME_WIDTH, window_height / GAME_HEIGHT)
		scaled_width = GAME_WIDTH * scale
		scaled_height = GAME_HEIGHT * scale
		window_pos = rl.GetWindowPosition()

		// save the current state
		global.settings_update_window_data(
			&game_settings,
			window_width,
			window_height,
			{window_pos.x, window_pos.y},
		)
	}

	// global context
	global_ctx := global.init_context(game_settings)
	defer global.destroy_context(&global_ctx)
	context.user_ptr = &global_ctx

	// main game struct
	game.init()
	gg := game.create(GAME_WIDTH, GAME_HEIGHT)
	defer game.destroy(&gg)

	// GAME LOOP
	//
	for !rl.WindowShouldClose() {
		defer free_all(context.temp_allocator)

		// check for window changes and update scaling
		current_width := f32(rl.GetScreenWidth())
		current_height := f32(rl.GetScreenHeight())
		current_pos := rl.GetWindowPosition()

		if current_width != window_width ||
		   current_height != window_height ||
		   current_pos != window_pos {
			window_width = current_width
			window_height = current_height
			scale = min(window_width / GAME_WIDTH, window_height / GAME_HEIGHT)
			scaled_width = GAME_WIDTH * scale
			scaled_height = GAME_HEIGHT * scale

			global.settings_update_window_data(
				&game_settings,
				window_width,
				window_height,
				{current_pos.x, current_pos.y},
			)
		}

		// UPDATE
		game.update(&gg)

		// exit condition
		if game.should_exit(gg) {
			break
		}

		// DRAW
		// we draw to the render texture first...
		{
			rl.BeginTextureMode(render_target)
			defer rl.EndTextureMode()

			game.draw(&gg)
		}

		// ...and upscale that to the window dimensions
		{
			rl.BeginDrawing()
			defer rl.EndDrawing()

			// rect to use for upscaling
			render_rect := Rect {
				x      = (window_width - scaled_width) / 2,
				y      = 0,
				width  = scaled_width,
				height = scaled_height,
			}

			// rect to use for flipping the render texture b/c OpenGL
			flip_rect := Rect {
				x      = 0,
				y      = 0,
				width  = GAME_WIDTH,
				height = -GAME_HEIGHT, // we need to flip the y-axis 
			}

			rl.ClearBackground(rl.BLACK)
			rl.DrawTexturePro(render_target.texture, flip_rect, render_rect, {0, 0}, 0.0, rl.WHITE)

			// in fullscreen, draw a nice little border around the render texture
			if scaled_width < window_width || scaled_height < window_height {
				border_thickness := 2.0 * scale
				border_color := rl.Color{227, 141, 24, 255}

				border_rect := Rect {
					x      = render_rect.x - border_thickness,
					y      = render_rect.y - border_thickness,
					width  = render_rect.width + border_thickness * 2,
					height = render_rect.height + border_thickness * 2,
				}

				rl.DrawRectangleLinesEx(border_rect, border_thickness, border_color)
			}
		}
	}
}

