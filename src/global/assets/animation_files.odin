package assets

PLAYER_IDLE_ANIMATION_DURATION :: 0.75
PLAYER_RUN_ANIMATION_DURATION :: 0.5
PLAYER_JUMP_ANIMATION_DURATION :: 0.25
PLAYER_HURT_ANIMATION_DURATION :: 0.5
PLAYER_DEATH_ANIMATION_DURATION :: 0.5


Animation_Name :: enum {
	// Player sprites
	Player_Idle,
	Player_Run,
	Player_Jump,
	Player_Hurt,
	Player_Dead,
}


animations := [Animation_Name]Asset {
	.Player_Idle = {
		data = #load("../../../assets/sprites/player/16x17_player_idle.png"),
		type = Animation_Info {
			num_frames = 6,
			frame_width = 16,
			frame_height = 17,
			duration = PLAYER_IDLE_ANIMATION_DURATION,
			repeats = true,
		},
	},
	.Player_Run = {
		data = #load("../../../assets/sprites/player/16x18_player_run.png"),
		type = Animation_Info {
			num_frames = 8,
			frame_width = 16,
			frame_height = 18,
			duration = PLAYER_RUN_ANIMATION_DURATION,
			repeats = true,
		},
	},
	.Player_Jump = {
		data = #load("../../../assets/sprites/player/16x22_player_jump.png"),
		type = Animation_Info {
			num_frames = 4,
			frame_width = 16,
			frame_height = 22,
			duration = PLAYER_JUMP_ANIMATION_DURATION,
			repeats = false,
		},
	},
	.Player_Hurt = {
		data = #load("../../../assets/sprites/player/16x16_player_hurt.png"),
		type = Animation_Info {
			num_frames = 3,
			frame_width = 16,
			frame_height = 16,
			duration = PLAYER_HURT_ANIMATION_DURATION,
			repeats = false,
		},
	},
	.Player_Dead = {
		data = #load("../../../assets/sprites/player/21x15_player_dead.png"),
		type = Animation_Info {
			num_frames = 5,
			frame_width = 21,
			frame_height = 15,
			duration = PLAYER_DEATH_ANIMATION_DURATION,
			repeats = false,
		},
	},
}

