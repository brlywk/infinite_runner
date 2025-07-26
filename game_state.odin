package main

import rl "vendor:raylib"

//
// Structs
//


// Current game state identifier.
Game_State :: enum {
	Menu,
	Playing,
	Paused,
	Game_Over,
}

// The game struct. Yes, *THE* game struct.
Game :: struct {
	state:        Game_State,
	assets:       Asset_Cache,
	default_font: rl.Font,
	floor:        Texture_Handle, // just one floor type for now
}


//
// Procs
//


game_draw :: proc(game: Game) {
	#partial switch game.state {
	case .Playing:
		game_playing_draw(game)
	}
}

game_update :: proc(game: ^Game) {
	#partial switch game.state {
	case .Playing:
		game_playing_update(game)
	}
}

