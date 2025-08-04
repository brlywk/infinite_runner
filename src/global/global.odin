package global

import "assets"

// Holds global systems required everywhere:
//  - Asset Cache
//  - Game Settings
Context :: struct {
	assets:   assets.Cache,
	settings: Settings,
}

init_context :: proc() -> Context {
	return Context {
		assets = assets.cache_init(),
		// TODO: Load from saved settings (json?)
		settings = Settings{volume_master = 1.0, volume_music = 1.0, volume_sound = 1.0},
	}
}

destroy_context :: proc(global_ctx: ^Context) {
	assets.cache_destroy(&global_ctx.assets)
}

// Returns a reference to the global game context (global.Context).
ctx :: proc() -> ^Context {
	return (^Context)(context.user_ptr)
}

