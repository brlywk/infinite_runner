package assets

import "../sprite"

//
// Constants
//


PLAYER_RUN_ANIMATION_SPEED :: 0.5
PLAYER_JUMP_ANIMATION_SPEED :: 0.5
PLAYER_HURT_ANIMATION_SPEED :: 0.5
PLAYER_DEATH_ANIMATION_SPEED :: 0.5

FONT_DEFAULT_SIZE :: 8


//
// Enums
//

Asset_Name :: union {
	Texture_Name,
	Font_Name,
	Sound_Name,
}


Texture_Name :: enum {
	// Player sprites
	// Player_Idle,
	Player_Run,
	Player_Jump,
	Player_Hurt,
	// Player_Attack,
	Player_Dead,

	// Floor
	Floor,

	// Backgrounds

	// Obstacle sprites
}

Font_Name :: enum {
	Independent_Modern,
}

Sound_Name :: union {
	Sound_UI_Name,
	Sound_Player_Name,
}

Sound_UI_Name :: enum {
	Click,
	Select_01,
	Select_02,
}

Sound_Player_Name :: enum {
	Attack,
	Jump,
	Hit,
	Step_01,
	Step_02,
	Step_03,
	Step_04,
	Step_05,
}

Music_Name :: enum {}


//
// Textures
//


textures := [Texture_Name]Asset {
	// PLAYER

	// .Player_Idle = {
	// 	path = "../../assets/sprites/player/16x17_player_idle.png",
	// 	data = #load("../../assets/sprites/player/16x17_player_idle.png"),
	// 	type = Texture{},
	// },
	.Player_Run = {
		path = "../../assets/sprites/player/16x18_player_run.png",
		data = #load("../../assets/sprites/player/16x18_player_run.png"),
		type = Texture {
			sprite_info = sprite.Info{width = 16, height = 18},
			animation = sprite.Animation_Info {
				frames = 8,
				speed = PLAYER_RUN_ANIMATION_SPEED,
				repeats = true,
			},
		},
	},
	.Player_Jump = {
		path = "../../assets/sprites/player/16x22_player_jump.png",
		data = #load("../../assets/sprites/player/16x22_player_jump.png"),
		type = Texture {
			sprite_info = sprite.Info{width = 16, height = 22},
			animation = sprite.Animation_Info {
				frames = 6,
				speed = PLAYER_JUMP_ANIMATION_SPEED,
				repeats = false,
			},
		},
	},
	.Player_Hurt = {
		path = "../../assets/sprites/player/16x16_player_hurt.png",
		data = #load("../../assets/sprites/player/16x16_player_hurt.png"),
		type = Texture {
			sprite_info = sprite.Info{width = 16, height = 16},
			animation = sprite.Animation_Info {
				frames = 3,
				speed = PLAYER_HURT_ANIMATION_SPEED,
				repeats = false,
			},
		},
	},
	// .Player_Attack = {
	// 	path = "../../assets/sprites/player/19x19_player_attack.png",
	// 	data = #load("../../assets/sprites/player/19x19_player_attack.png"),
	// 	type = Texture{},
	// },
	.Player_Dead = {
		path = "../../assets/sprites/player/21x15_player_dead.png",
		data = #load("../../assets/sprites/player/21x15_player_dead.png"),
		type = Texture {
			sprite_info = sprite.Info{width = 21, height = 15},
			animation = sprite.Animation_Info {
				frames = 5,
				speed = PLAYER_DEATH_ANIMATION_SPEED,
				repeats = false,
			},
		},
	},

	// FLOOR
	.Floor = {
		path = "../../assets/sprites/floor/16x16_floor.png",
		data = #load("../../assets/sprites/floor/16x16_floor.png"),
		type = Texture{sprite_info = sprite.Info{width = 16, height = 16}, animation = nil},
	},
}


//
// Fonts
//


fonts := [Font_Name]Asset {
	.Independent_Modern = {
		path = "../../assets/fonts/independent_modern.ttf",
		data = #load("../../assets/fonts/independent_modern.ttf"),
		type = Font{default_font_size = FONT_DEFAULT_SIZE},
	},
}


//
// Sounds
//


ui_sounds := [Sound_UI_Name]Asset {
	.Click = {
		path = "../../assets/sounds/ui/button_click_01.wav",
		data = #load("../../assets/sounds/ui/button_click_01.wav"),
		type = Sound{},
	},
	.Select_01 = {
		path = "../../assets/sounds/ui/button_select_01.wav",
		data = #load("../../assets/sounds/ui/button_select_01.wav"),
		type = Sound{},
	},
	.Select_02 = {
		path = "../../assets/sounds/ui/button_select_02.wav",
		data = #load("../../assets/sounds/ui/button_select_02.wav"),
		type = Sound{},
	},
}


player_sounds := [Sound_Player_Name]Asset {
	.Hit = {
		path = "../../assets/sounds/player/hit_01.wav",
		data = #load("../../assets/sounds/player/hit_01.wav"),
		type = Sound{},
	},
	.Jump = {
		path = "../../assets/sounds/player/jump_01.wav",
		data = #load("../../assets/sounds/player/jump_01.wav"),
		type = Sound{},
	},
	.Attack = {
		path = "../../assets/sounds/player/attack_01.wav",
		data = #load("../../assets/sounds/player/attack_01.wav"),
		type = Sound{},
	},
	.Step_01 = {
		path = "../../assets/sounds/player/step_01.wav",
		data = #load("../../assets/sounds/player/step_01.wav"),
		type = Sound{},
	},
	.Step_02 = {
		path = "../../assets/sounds/player/step_02.wav",
		data = #load("../../assets/sounds/player/step_02.wav"),
		type = Sound{},
	},
	.Step_03 = {
		path = "../../assets/sounds/player/step_03.wav",
		data = #load("../../assets/sounds/player/step_03.wav"),
		type = Sound{},
	},
	.Step_04 = {
		path = "../../assets/sounds/player/step_04.wav",
		data = #load("../../assets/sounds/player/step_04.wav"),
		type = Sound{},
	},
	.Step_05 = {
		path = "../../assets/sounds/player/step_05.wav",
		data = #load("../../assets/sounds/player/step_05.wav"),
		type = Sound{},
	},
}

music := [Music_Name]Asset{}

