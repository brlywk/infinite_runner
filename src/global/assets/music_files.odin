package assets

Music_Name :: enum {
	Main_Menu,
	InGame,
}

music := [Music_Name]Asset {
	.Main_Menu = {
		data = #load("../../../assets/sounds/music/menu.mp3"),
		type = Music_Info{base_volume = 0.42},
	},
	.InGame = {
		data = #load("../../../assets/sounds/music/game.mp3"),
		type = Music_Info{base_volume = 0.42},
	},
}

