package assets

Texture_Name :: enum {
	// Floor
	Floor,

	// Backgrounds
	Backround_01,
	Backround_02,
	Backround_03,
	Backround_04,
	Backround_05,

	// Buildings
	Building_01,
	Building_02,
	Building_03,
	Building_04,
	Building_05,

	// Obstacle sprites
	Vending_Machine_Large_01,
}

textures := [Texture_Name]Asset {
	// FLOOR
	.Floor = {data = #load("../../assets/sprites/floor/16x16_floor.png"), type = Texture{}},

	// OBSTACLES
	.Vending_Machine_Large_01 = {
		data = #load("../../assets/sprites/obstacles/20x24_vending_01.png"),
		type = Texture{},
	},

	// BACKGROUNDS
	.Backround_01 = {data = #load("../../assets/sprites/bg/bg_01.png"), type = Texture{}},
	.Backround_02 = {data = #load("../../assets/sprites/bg/bg_02.png"), type = Texture{}},
	.Backround_03 = {data = #load("../../assets/sprites/bg/bg_03.png"), type = Texture{}},
	.Backround_04 = {data = #load("../../assets/sprites/bg/bg_04.png"), type = Texture{}},
	.Backround_05 = {data = #load("../../assets/sprites/bg/bg_05.png"), type = Texture{}},

	// BUILDINGS
	.Building_01 = {
		data = #load("../../assets/sprites/buildings/128x160_building_01.png"),
		type = Texture{},
	},
	.Building_02 = {
		data = #load("../../assets/sprites/buildings/128x144_building_02.png"),
		type = Texture{},
	},
	.Building_03 = {
		data = #load("../../assets/sprites/buildings/128x160_building_03.png"),
		type = Texture{},
	},
	.Building_04 = {
		data = #load("../../assets/sprites/buildings/128x160_building_04.png"),
		type = Texture{},
	},
	.Building_05 = {
		data = #load("../../assets/sprites/buildings/128x224_building_05.png"),
		type = Texture{},
	},
}

