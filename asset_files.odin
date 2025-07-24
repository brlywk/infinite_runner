package main

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


//
// Textures
//


textures := [Texture_Name]Asset {
	// PLAYER

	// .Player_Idle = {
	// 	path = "assets/sprites/player/16x17_player_idle.png",
	// 	data = #load("assets/sprites/player/16x17_player_idle.png"),
	// 	type = Texture_Asset{},
	// },
	.Player_Run = {
		path = "assets/sprites/player/16x18_player_run.png",
		data = #load("assets/sprites/player/16x18_player_run.png"),
		type = Texture_Asset {
			sprite = Sprite_Info{width = 16, height = 18},
			animation = Animation_Info {
				frames = 8,
				speed = PLAYER_RUN_ANIMATION_SPEED,
				repeats = true,
			},
		},
	},
	.Player_Jump = {
		path = "assets/sprites/player/16x22_player_jump.png",
		data = #load("assets/sprites/player/16x22_player_jump.png"),
		type = Texture_Asset {
			sprite = Sprite_Info{width = 16, height = 22},
			animation = Animation_Info {
				frames = 6,
				speed = PLAYER_JUMP_ANIMATION_SPEED,
				repeats = false,
			},
		},
	},
	.Player_Hurt = {
		path = "assets/sprites/player/16x16_player_hurt.png",
		data = #load("assets/sprites/player/16x16_player_hurt.png"),
		type = Texture_Asset {
			sprite = Sprite_Info{width = 16, height = 16},
			animation = Animation_Info {
				frames = 3,
				speed = PLAYER_HURT_ANIMATION_SPEED,
				repeats = false,
			},
		},
	},
	// .Player_Attack = {
	// 	path = "assets/sprites/player/19x19_player_attack.png",
	// 	data = #load("assets/sprites/player/19x19_player_attack.png"),
	// 	type = Texture_Asset{},
	// },
	.Player_Dead = {
		path = "assets/sprites/player/21x15_player_dead.png",
		data = #load("assets/sprites/player/21x15_player_dead.png"),
		type = Texture_Asset {
			sprite = Sprite_Info{width = 21, height = 15},
			animation = Animation_Info {
				frames = 5,
				speed = PLAYER_DEATH_ANIMATION_SPEED,
				repeats = false,
			},
		},
	},

	// FLOOR
	.Floor = {
		path = "assets/sprites/floor/16x16_floor.png",
		data = #load("assets/sprites/floor/16x16_floor.png"),
		type = Texture_Asset{sprite = Sprite_Info{width = 16, height = 16}, animation = nil},
	},
}


//
// Fonts
//


fonts := [Font_Name]Asset {
	.Independent_Modern = {
		path = "assets/fonts/independent_modern.ttf",
		data = #load("assets/fonts/independent_modern.ttf"),
		type = Font_Asset{default_font_size = FONT_DEFAULT_SIZE},
	},
}

