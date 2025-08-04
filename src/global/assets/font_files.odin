package assets

FONT_DEFAULT_SIZE :: 8

Font_Name :: enum {
	Independent_Modern,
}

fonts := [Font_Name]Asset {
	.Independent_Modern = {
		data = #load("../../../assets/fonts/independent_modern.ttf"),
		type = Font{default_font_size = FONT_DEFAULT_SIZE},
	},
}

