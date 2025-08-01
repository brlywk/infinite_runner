package game

import "../assets"
import "core:math/rand"
import rl "vendor:raylib"


// Current game state identifier.
Game_State :: enum {
	// Loading,
	Menu,
	Playing,
	Paused,
	Game_Over,
	Exit,
}

// The game struct. Yes, *THE* game struct.
Game :: struct {
	// general settings
	screen_width:      i32,
	screen_height:     i32,
	speed:             f32,
	last_increase:     f32,
	state:             Game_State,
	distance:          i32,
	started:           f64,

	// game entities
	player:            Player,
	buildings:         [dynamic]Building,
	obstacles:         [dynamic]Obstacle,

	// assets
	floor:             Background, // just one floor type for now
	background_assets: [BACKGROUND_LAYERS]Background,
	building_assets:   [BUILDING_NUM]Texture,
}

Background :: struct {
	texture:       Texture,
	scroll_speed:  f32,
	scroll_offset: f32,
}


// Creates the main game struct.
//
// Inputs:
//  - width, height: Dimensions of the render texture the game is rendered to.
//
// Returns: Initialized Game struct.
init :: proc(width, height: i32) -> Game {
	asset_cache := (^Asset_Cache)(context.user_ptr)

	// floor
	floor := assets.get(asset_cache, Texture_Name.Floor)

	// time the game actually started
	started := rl.GetTime()

	game := Game {
		// general settings
		screen_width = width,
		screen_height = height,
		state = GAME_INITIAL_STATE,
		speed = GAME_SPEED_INIT,
		distance = 0,
		started = started,

		// game entities
		player = init_player(asset_cache, width, height, floor.height),
		buildings = make([dynamic]Building),
		obstacles = make([dynamic]Obstacle),

		// assets
		floor = {texture = floor, scroll_speed = 1.0},
		background_assets = {
			{texture = assets.get(asset_cache, Texture_Name.Backround_01), scroll_speed = 0.2},
			{texture = assets.get(asset_cache, Texture_Name.Backround_02), scroll_speed = 0.4},
			{texture = assets.get(asset_cache, Texture_Name.Backround_03), scroll_speed = 0.6},
			{texture = assets.get(asset_cache, Texture_Name.Backround_04), scroll_speed = 0.8},
			{texture = assets.get(asset_cache, Texture_Name.Backround_05), scroll_speed = 0.95},
		},
		building_assets = {
			assets.get(asset_cache, Texture_Name.Building_01),
			assets.get(asset_cache, Texture_Name.Building_02),
			assets.get(asset_cache, Texture_Name.Building_03),
			assets.get(asset_cache, Texture_Name.Building_04),
			assets.get(asset_cache, Texture_Name.Building_05),
		},
	}

	// spawn some initial stuff
	init_spawn(&game)

	return game
}

init_player :: proc(asset_cache: ^Asset_Cache, width, height, floor_height: i32) -> Player {
	// player
	player_init_anim := player_animations[PLAYER_INITIAL_STATE]
	player_animation := assets.get(asset_cache, player_init_anim)
	player_pos := Vec2 {
		PLAYER_X_START_POS,
		f32(height - floor_height - player_animation.texture.height),
	}

	return player_init(player_pos, PLAYER_INITIAL_STATE)
}

init_spawn :: proc(game: ^Game) {
	// spawn a first building somewhere on the right side of the screen
	first_building_x := rand.int31_max(game.screen_width / 2) + game.screen_width / 2
	first_building := building_create_random(game, f32(first_building_x), game.started)
	append(&game.buildings, first_building)

	// spawn a first obstacle just off-screen to give some time for the player
	// to mentally prepare for the high-stakes game of obstacle hopping
	first_obstacle := obstacle_create_random(game, game.started)
	append(&game.obstacles, first_obstacle)
}

reset :: proc(game: ^Game) {
	game^ = init(game.screen_width, game.screen_height)
}

// Destroys the main game struct, de-allocating all the things.
destroy :: proc(game: ^Game) {
	// free dynamically allocated fields
	delete(game.obstacles)
	delete(game.buildings)

	// Note: game.backgrounds is a slice based on an array living on the stack, hence
	// no deletion needed

	// set raylib fields to zero, b/c handles will be destroyed when asset cache is destroyed
	game.floor = Background{}

	// Note: All backing textures for assets are being freed/deleted in main.odin when
	// the asset cache itself it destroyed
}

draw :: proc(game: ^Game) {
	#partial switch game.state {
	case .Playing:
		playing_draw(game)
	case .Paused:
		paused_draw(game)
	case .Game_Over:
		game_over_draw(game)
	case .Menu:
		menu_draw(game)
	}
}

update :: proc(game: ^Game) {
	#partial switch game.state {
	case .Playing:
		playing_update(game)
	case .Paused:
		paused_update(game)
	case .Game_Over:
		game_over_update(game)
	case .Menu:
		menu_update(game)
	}
}

should_exit :: proc(game: Game) -> bool {
	return game.state == .Exit
}

