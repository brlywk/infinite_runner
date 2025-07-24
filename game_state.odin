package main

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
	state: Game_State,
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

