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
	Obstacle_Vent,
	Obstacle_Box_01,
	Obstacle_Box_02,
	Obstacle_Box_03,
	Obstacle_Vending_Machine_Small_01,
	Obstacle_Vending_Machine_Small_02,
	Obstacle_Pole,
	Obstacle_Vending_Machine_Large_01,
	Obstacle_Vending_Machine_Large_02,
	Obstacle_Ad_01,
	Obstacle_Ad_02,
	Obstacle_Dumpster,
	Obstacle_Bench,
	Obstacle_Car_01,
	Obstacle_Car_02,
}

textures := [Texture_Name]Asset {
	// FLOOR
	.Floor = {data = #load("../../../assets/sprites/floor/16x16_floor.png"), type = Texture{}},

	// OBSTACLES
	.Obstacle_Vent = {
		data = #load("../../../assets/sprites/obstacles/12x28_vent.png"),
		type = Texture{},
	},
	.Obstacle_Box_01 = {
		data = #load("../../../assets/sprites/obstacles/14x9_box_01.png"),
		type = Texture{},
	},
	.Obstacle_Box_02 = {
		data = #load("../../../assets/sprites/obstacles/14x9_box_02.png"),
		type = Texture{},
	},
	.Obstacle_Box_03 = {
		data = #load("../../../assets/sprites/obstacles/14x9_box_03.png"),
		type = Texture{},
	},
	.Obstacle_Vending_Machine_Small_01 = {
		data = #load("../../../assets/sprites/obstacles/16x17_vending_small_01.png"),
		type = Texture{},
	},
	.Obstacle_Vending_Machine_Small_02 = {
		data = #load("../../../assets/sprites/obstacles/16x17_vending_small_02.png"),
		type = Texture{},
	},
	.Obstacle_Pole = {
		data = #load("../../../assets/sprites/obstacles/16x32_pole.png"),
		type = Texture{},
	},
	.Obstacle_Vending_Machine_Large_01 = {
		data = #load("../../../assets/sprites/obstacles/20x24_vending_01.png"),
		type = Texture{},
	},
	.Obstacle_Vending_Machine_Large_02 = {
		data = #load("../../../assets/sprites/obstacles/20x24_vending_02.png"),
		type = Texture{},
	},
	.Obstacle_Ad_01 = {
		data = #load("../../../assets/sprites/obstacles/26x32_ad_01.png"),
		type = Texture{},
	},
	.Obstacle_Ad_02 = {
		data = #load("../../../assets/sprites/obstacles/26x32_ad_02.png"),
		type = Texture{},
	},
	.Obstacle_Dumpster = {
		data = #load("../../../assets/sprites/obstacles/28x24_dumpster.png"),
		type = Texture{},
	},
	.Obstacle_Bench = {
		data = #load("../../../assets/sprites/obstacles/32x11_bench.png"),
		type = Texture{},
	},
	.Obstacle_Car_01 = {
		data = #load("../../../assets/sprites/obstacles/41x13_car_01.png"),
		type = Texture{},
	},
	.Obstacle_Car_02 = {
		data = #load("../../../assets/sprites/obstacles/41x13_car_02.png"),
		type = Texture{},
	},

	// BACKGROUNDS
	.Backround_01 = {data = #load("../../../assets/sprites/bg/bg_01.png"), type = Texture{}},
	.Backround_02 = {data = #load("../../../assets/sprites/bg/bg_02.png"), type = Texture{}},
	.Backround_03 = {data = #load("../../../assets/sprites/bg/bg_03.png"), type = Texture{}},
	.Backround_04 = {data = #load("../../../assets/sprites/bg/bg_04.png"), type = Texture{}},
	.Backround_05 = {data = #load("../../../assets/sprites/bg/bg_05.png"), type = Texture{}},

	// BUILDINGS
	.Building_01 = {
		data = #load("../../../assets/sprites/buildings/128x160_building_01.png"),
		type = Texture{},
	},
	.Building_02 = {
		data = #load("../../../assets/sprites/buildings/128x144_building_02.png"),
		type = Texture{},
	},
	.Building_03 = {
		data = #load("../../../assets/sprites/buildings/128x160_building_03.png"),
		type = Texture{},
	},
	.Building_04 = {
		data = #load("../../../assets/sprites/buildings/128x160_building_04.png"),
		type = Texture{},
	},
	.Building_05 = {
		data = #load("../../../assets/sprites/buildings/128x224_building_05.png"),
		type = Texture{},
	},
}

