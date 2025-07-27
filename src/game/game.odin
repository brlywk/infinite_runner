package game

import "../assets"
import "../obstacle"
import "core:log"
import rl "vendor:raylib"

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
	speed:         f32,
	state:         Game_State,
	asset_cache:   assets.Cache,
	default_font:  rl.Font,
	floor:         Texture, // just one floor type for now
	backgrounds:   [BACKGROUND_LAYERS]Background,
	buildings:     [BUILDING_NUM]Texture,
	player:        Player,
	obstacles:     [dynamic]obstacle.Obstacle,
}

Background :: struct {
	texture:      Texture,
	scroll_speed: f32,
}


// 
// Procs
//


// Creates the main game struct.
//
// Inputs:
//  - width, height: Dimensions of the render texture the game is rendered to.
//
// Returns: Initialized Game struct.
init :: proc(width, height: i32) -> Game {
	asset_cache := assets.cache_init()

	// floor
	floor := assets.get(asset_cache, Texture_Name.Floor)

	// player
	player_animation := assets.get(asset_cache, Animation_Name.Player_Run)
	log.debug("player_animation", player_animation)
	player_pos := Vec2{16.0, f32(height - floor.height - player_animation.texture.height)}

	// TODO: Delete, just for testing
	test_wall_texture := assets.get(asset_cache, Texture_Name.Vending_Machine_Large_01)
	test_wall := obstacle.create(
		test_wall_texture,
		{64.0, f32(height - floor.height - test_wall_texture.height)},
	)

	game := Game {
		screen_width  = width,
		screen_height = height,
		state         = .Playing,
		speed         = GAME_INITIAL_SPEED,
		asset_cache   = asset_cache,
		default_font  = assets.get(asset_cache, Font_Name.Independent_Modern),
		player        = player_init(player_animation, player_pos),
		floor         = floor,
		backgrounds   = {
			{texture = assets.get(asset_cache, Texture_Name.Backround_01), scroll_speed = 0.2},
			{texture = assets.get(asset_cache, Texture_Name.Backround_02), scroll_speed = 0.4},
			{texture = assets.get(asset_cache, Texture_Name.Backround_03), scroll_speed = 0.6},
			{texture = assets.get(asset_cache, Texture_Name.Backround_04), scroll_speed = 0.8},
			{texture = assets.get(asset_cache, Texture_Name.Backround_05), scroll_speed = 1.0},
		},
		buildings     = [?]Texture {
			assets.get(asset_cache, Texture_Name.Building_01),
			assets.get(asset_cache, Texture_Name.Building_02),
			assets.get(asset_cache, Texture_Name.Building_03),
			assets.get(asset_cache, Texture_Name.Building_04),
			assets.get(asset_cache, Texture_Name.Building_05),
		},
		obstacles     = make([dynamic]obstacle.Obstacle),
	}

	// TODO: Delete, just for testing
	append(&game.obstacles, test_wall)

	return game
}

destroy :: proc(game: ^Game) {
	// free dynamically allocated fields
	delete(game.obstacles)
	// note that game.backgrounds is a slice based on an array living on the stack, hence
	// no deletion needed

	// set raylib fields to zero, b/c handles will be destroyed when asset cache is destroyed
	game.default_font = rl.Font{}
	game.floor = rl.Texture2D{}

	assets.cache_destroy(&game.asset_cache)
}

draw :: proc(game: ^Game) {
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

