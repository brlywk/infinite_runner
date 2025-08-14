package assets

Music_Name :: enum {
	Main_Menu,
}

music := [Music_Name]Asset {
	.Main_Menu = {
		data = #load("../../../assets/sounds/music/main_menu.mp3"),
		type = Music_Info{base_volume = 0.42},
	},
}

