package game

import "../assets"
import rl "vendor:raylib"


BACKGROUND_NAMES :: [?]assets.Texture_Name {
	Texture_Name.Backround_01,
	Texture_Name.Backround_02,
	Texture_Name.Backround_03,
	Texture_Name.Backround_04,
	Texture_Name.Backround_05,
}
BACKGROUND_LAYERS :: len(BACKGROUND_NAMES)


BUILDING_NAMES :: [?]assets.Texture_Name {
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
FONT_SHADOW_OFFSET :: Vec2{1.0, 1.0}

GAME_SPEED_INIT :: 100.0
GAME_SPEED_MAX :: 400.0
GAME_INITIAL_STATE :: Game_State.Playing
GAME_PIXELS_PER_POINT :: 10

PLAYER_X_START_POS :: 16.0
PLAYER_INITIAL_STATE :: Player_State.Running
PLAYER_HITBOX_OFFSET :: Vec2{4, 0}
PLAYER_JUMP_FORCE :: 300.0
PLAYER_GRAVITY :: 800.0

UI_SCORE_POS :: Vec2{4.0, 4.0}
UI_SCORE_FONT_SIZE :: 8.0
UI_SCORE_COLOR :: rl.WHITE

VEC2_ZERO :: Vec2{0, 0}

