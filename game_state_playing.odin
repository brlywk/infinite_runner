package main

import rl "vendor:raylib"

//
// Structs
//


// 
// Procs
//


game_playing_draw :: proc(game: Game) {
	rl.DrawRectangle(0, 0, 16, 16, rl.WHITE)
}

game_playing_update :: proc(game: ^Game) {
}

