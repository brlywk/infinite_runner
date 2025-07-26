package assets

import rl "vendor:raylib"

// Loads font by Asset_Name.
//
// Panics if name is not a Font_Name or the asset's type of a loaded Asset is not Font_Asset.
@(private)
load_font :: proc(font_name: Font_Name) -> rl.Font {
	font_asset := fonts[font_name]
	font_info := font_asset.type.(Font)

	font := rl.LoadFontFromMemory(
		FILE_TYPE_TTF,
		&font_asset.data[0],
		i32(len(font_asset.data)),
		font_info.default_font_size,
		nil,
		0,
	)

	return font
}

