package game

import "../assets"
import "../obstacle"
import "../player"
import rl "vendor:raylib"

//
// Structs
//


// Current game state identifier.
Game_State :: enum {
	Loading,
	Menu,
	Playing,
	Paused,
	Game_Over,
}

// The game struct. Yes, *THE* game struct.
Game :: struct {
	screen_width:  i32,
	screen_height: i32,
	state:         Game_State,
	asset_cache:   assets.Cache,
	default_font:  rl.Font,
	floor:         assets.Texture_Handle, // just one floor type for now
	player:        player.Player,
	obstacles:     [dynamic]obstacle.Obstacle,
}

init :: proc(width, height: i32) -> Game {
	asset_cache := assets.cache_init()
	player := player.Player{}

	game := Game {
		state        = .Playing,
		asset_cache  = asset_cache,
		default_font = assets.get(asset_cache, assets.Font_Name.Independent_Modern),
		floor        = assets.get(asset_cache, assets.Texture_Name.Floor),
		player       = player,
		obstacles    = make([dynamic]obstacle.Obstacle),
	}

	return game
}

destroy :: proc(game: ^Game) {
	// free dynamically allocated fields
	delete(game.obstacles)

	// set raylib fields to zero, b/c handles will be destroyed when asset cache is destroyed
	game.default_font = rl.Font{}
	game.floor.texture = rl.Texture2D{}


	assets.cache_destroy(&game.asset_cache)
}


//
// Procs
//


draw :: proc(game: Game) {
	#partial switch game.state {
	case .Playing:
		playing_draw(game)
	}
}

update :: proc(game: ^Game) {
	#partial switch game.state {
	case .Playing:
		playing_update(game)
	}
}

