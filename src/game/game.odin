package game

import "../assets"
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
	screen_width:      i32,
	screen_height:     i32,
	speed:             f32,
	state:             Game_State,
	default_font:      rl.Font,
	floor:             Texture, // just one floor type for now
	background_assets: [BACKGROUND_LAYERS]Background,
	buildings:         [dynamic]Building,
	building_assets:   [BUILDING_NUM]Texture,
	player:            Player,
	obstacles:         [dynamic]Obstacle,
}

Background :: struct {
	texture:      Texture,
	scroll_speed: f32,
}

Building :: struct {
	using pos: Vec2,
	texture:   Texture,
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
	asset_cache := (^Asset_Cache)(context.user_ptr)

	// floor
	floor := assets.get(asset_cache, Texture_Name.Floor)

	// player
	player_init_anim := player_animations[PLAYER_INIT_STATE]
	player_animation := assets.get(asset_cache, player_init_anim)
	player_pos := Vec2{16.0, f32(height - floor.height - player_animation.texture.height)}

	// TODO: Delete, just for testing
	test_wall_texture := assets.get(asset_cache, Texture_Name.Vending_Machine_Large_01)
	test_wall := obstacle_create(
		test_wall_texture,
		{64.0, f32(height - floor.height - test_wall_texture.height)},
	)

	game := Game {
		screen_width      = width,
		screen_height     = height,
		state             = .Playing,
		speed             = GAME_INITIAL_SPEED,
		default_font      = assets.get(asset_cache, Font_Name.Independent_Modern),
		player            = player_init(player_pos, PLAYER_INIT_STATE),
		floor             = floor,
		background_assets = {
			{texture = assets.get(asset_cache, Texture_Name.Backround_01), scroll_speed = 0.2},
			{texture = assets.get(asset_cache, Texture_Name.Backround_02), scroll_speed = 0.4},
			{texture = assets.get(asset_cache, Texture_Name.Backround_03), scroll_speed = 0.6},
			{texture = assets.get(asset_cache, Texture_Name.Backround_04), scroll_speed = 0.8},
			{texture = assets.get(asset_cache, Texture_Name.Backround_05), scroll_speed = 1.0},
		},
		buildings         = make([dynamic]Building),
		building_assets   = [?]Texture {
			assets.get(asset_cache, Texture_Name.Building_01),
			assets.get(asset_cache, Texture_Name.Building_02),
			assets.get(asset_cache, Texture_Name.Building_03),
			assets.get(asset_cache, Texture_Name.Building_04),
			assets.get(asset_cache, Texture_Name.Building_05),
		},
		obstacles         = make([dynamic]Obstacle),
	}

	// TODO: Delete, just for testing
	append(&game.obstacles, test_wall)

	return game
}

destroy :: proc(game: ^Game) {
	// free dynamically allocated fields
	delete(game.obstacles)
	delete(game.buildings)

	// Note: that game.backgrounds is a slice based on an array living on the stack, hence
	// no deletion needed

	// set raylib fields to zero, b/c handles will be destroyed when asset cache is destroyed
	game.default_font = rl.Font{}
	game.floor = rl.Texture2D{}

	// Note: All backing textures for assets are being freed/deleted in main.odin when
	// the asset cache itself it destroyed
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

// Calculate the y-coordinate a texture has to be drawn at for the Texture to be flush
// with the floor of the game.
y_floored :: proc(game: Game) -> f32 {
	return f32(game.screen_height - game.floor.height)
}

