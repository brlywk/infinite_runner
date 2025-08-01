package main

import "assets"
import "base:runtime"
import "core:log"
import "core:math/rand"
import "core:mem"
import "core:time"
import "game"
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
	rl.SetExitKey(rl.KeyboardKey.KEY_NULL) // disable ESC key exiting the game

	// GAME INIT
	//
	// asset cache
	asset_cache := assets.cache_init()
	defer assets.cache_destroy(&asset_cache)
	// we need assets everywhere, so let's make the completly sane decision to
	// save a reference to the asset_cache in our implicit context struct...
	// what could ever go wrong?
	context.user_ptr = &asset_cache

	// set default font
	default_font := assets.get(&asset_cache, assets.Font_Name.Independent_Modern)
	rl.GuiSetFont(default_font)

	// main game struct
	gg := game.init(GAME_WIDTH, GAME_HEIGHT)
	defer game.destroy(&gg)

	// GAME LOOP
	//
	for !rl.WindowShouldClose() {
		defer free_all(context.temp_allocator)

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

			// calculate scaling
			window_width := f32(rl.GetScreenWidth())
			window_height := f32(rl.GetScreenHeight())
			scale := min(window_width / GAME_WIDTH, window_height / GAME_HEIGHT)

			// rect to use for upscaling
			// TODO: When entering fullscreen, this needs to be centered
			render_rect := Rect {
				x      = 0,
				y      = 0,
				width  = GAME_WIDTH * scale,
				height = GAME_HEIGHT * scale,
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
		}
	}
}

