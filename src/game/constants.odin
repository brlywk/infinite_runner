package game

import "../assets"

GAME_INITIAL_SPEED :: 200.0
GAME_INITIAL_STATE :: Game_State.Playing

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


VEC2_ZERO :: Vec2{0, 0}

