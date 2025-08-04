package assets

Sound_Name :: enum {
	// Player
	Attack,
	Jump,
	Hit,
	Step_01,
	Step_02,
	Step_03,
	Step_04,
	Step_05,

	// UI
	Click,
	Select_01,
	Select_02,
}

sounds := [Sound_Name]Asset {
	// PLAYER
	.Hit = {
		data = #load("../../../assets/sounds/player/hit_01.wav"),
		type = Sound_Info{base_volume = 0.6},
	},
	.Jump = {
		data = #load("../../../assets/sounds/player/jump_01.wav"),
		type = Sound_Info{base_volume = 0.35},
	},
	.Attack = {
		data = #load("../../../assets/sounds/player/attack_01.wav"),
		type = Sound_Info{base_volume = 1.0},
	},
	.Step_01 = {
		data = #load("../../../assets/sounds/player/step_01.wav"),
		type = Sound_Info{base_volume = 0.75},
	},
	.Step_02 = {
		data = #load("../../../assets/sounds/player/step_02.wav"),
		type = Sound_Info{base_volume = 0.75},
	},
	.Step_03 = {
		data = #load("../../../assets/sounds/player/step_03.wav"),
		type = Sound_Info{base_volume = 0.75},
	},
	.Step_04 = {
		data = #load("../../../assets/sounds/player/step_04.wav"),
		type = Sound_Info{base_volume = 0.75},
	},
	.Step_05 = {
		data = #load("../../../assets/sounds/player/step_05.wav"),
		type = Sound_Info{base_volume = 0.75},
	},

	// UI
	.Click = {
		data = #load("../../../assets/sounds/ui/button_click_01.wav"),
		type = Sound_Info{base_volume = 1.0},
	},
	.Select_01 = {
		data = #load("../../../assets/sounds/ui/button_select_01.wav"),
		type = Sound_Info{base_volume = 1.0},
	},
	.Select_02 = {
		data = #load("../../../assets/sounds/ui/button_select_02.wav"),
		type = Sound_Info{base_volume = 1.0},
	},
}

