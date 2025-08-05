package game

import rl "vendor:raylib"


BACKGROUND_NAMES :: [?]Texture_Name {
	Texture_Name.Backround_01,
	Texture_Name.Backround_02,
	Texture_Name.Backround_03,
	Texture_Name.Backround_04,
	Texture_Name.Backround_05,
}
BACKGROUND_LAYERS :: len(BACKGROUND_NAMES)


BUILDING_NAMES :: [?]Texture_Name {
	Texture_Name.Building_01,
	Texture_Name.Building_02,
	Texture_Name.Building_03,
	Texture_Name.Building_04,
	Texture_Name.Building_05,
}
BUILDING_NUM :: len(BUILDING_NAMES)
BUILDING_TINT :: rl.Color{100, 100, 100, 255}
BUILDING_SPAWN_SECONDS_MIN :: 1.75
BUILDING_SPAWN_SECONDS_MAX :: 3.0
BUILDING_SPAWN_GAP_MIN :: 32
BUILDING_SPAWN_GAP_MAX :: 128

FONT_NAME_DEFAULT :: Font_Name.Independent_Modern
FONT_SHADOW_COLOR :: rl.Color{0, 0, 0, 222}
FONT_SHADOW_COLOR_ON_BLACK :: rl.Color{66, 66, 66, 255}
FONT_SHADOW_OFFSET :: Vec2{1.0, 1.0}

GAME_INITIAL_STATE :: Game_State.Playing
GAME_PIXELS_PER_POINT :: 10
GAME_SPEED_INIT :: 100.0
GAME_SPEED_MAX :: 400.0
GAME_SPEED_INCREASE_BY :: 6.66 // increase speed by THIS value...
GAME_SPEED_INCREASE_PER :: 25.0 // ...for each of THIS unit of distance traveled

OBSTACLE_SPAWN_SECONDS_MIN :: 1.5
OBSTACLE_SPAWN_SECONDS_MAX :: 3.5

PAUSE_SCREEN_BG_TINT :: rl.Color{10, 10, 10, 200}

PLAYER_X_START_POS :: 16.0
PLAYER_INITIAL_STATE :: Player_State.Running
PLAYER_INITIAL_HEALTH :: 4
PLAYER_INITIAL_FOOTSTEP_INTERVAL :: 0.28
PLAYER_HITBOX_OFFSET :: Vec2{4, 0}
PLAYER_JUMP_FORCE :: 300.0
PLAYER_GRAVITY :: 800.0
// I now understand why so many say bit_sets are a seriously cool feature ;)
PLAYER_VULNERABLE_STATES :: bit_set[Player_State]{.Running, .Jumping}
PLAYER_NO_JUMPING_STATES :: bit_set[Player_State]{.Jumping, .Hurt, .Dead}
PLAYER_RUNNING_DUST_PARTICLES :: 10
PLAYER_RUNNING_DUST_X_OFFSET :: 2

UI_SCORE_POS :: Vec2{4.0, 4.0}
UI_SCORE_FONT_SIZE :: 8.0
UI_SCORE_COLOR :: rl.WHITE

VEC2_ZERO :: Vec2{0, 0}

