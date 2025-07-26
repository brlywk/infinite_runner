package game

import rl "vendor:raylib"

//
// Structs
//


// 
// Procs
//


playing_draw :: proc(game: Game) {
	rl.DrawTexture(game.floor.texture, 0, 0, rl.WHITE)
}

playing_update :: proc(game: ^Game) {
}

