package main

import rl "vendor:raylib"

//
// Constants
//

FILE_TYPE_PNG :: ".png"
FILE_TYPE_TTF :: ".ttf"


//
// Structs
//


Asset :: struct {
	path: string,
	data: []u8,
	type: Asset_Type,
}

Asset_Type :: union {
	Texture_Asset,
	Music_Asset,
	Sound_Asset,
	Font_Asset,
}

Sound_Asset :: struct {}

Music_Asset :: struct {}

Texture_Asset :: struct {
	sprite:    Sprite_Info,
	animation: Animation,
}

Font_Asset :: struct {
	default_font_size: i32,
}

Texture_Handle :: struct {
	texture:   rl.Texture2D,
	sprite:    Sprite_Info,
	animation: Animation,
}


//
// Procs
//


// Load texture by Asset_Name.
//
// Panics if name is not a Texture_Name.
load_texture :: proc(name: Asset_Name) -> Texture_Handle {
	texture_name := name.(Texture_Name)
	texture_asset := textures[texture_name]
	texture_info := texture_asset.type.(Texture_Asset)

	image := rl.LoadImageFromMemory(
		FILE_TYPE_PNG,
		// NOTE: (b/c otherwise I forget and wonder again in the future)
		// We get a reference to the first element of the slice, b/c in Odin a slice is a 
		// struct with a pointer to the array, length and capacity, but Raylib is in C,
		// and in C an array is just a pointer to the first element of that array...
		// so we need to get a pointer to the first element of our Odin slice!
		&texture_asset.data[0],
		i32(len(texture_asset.data)),
	)
	defer rl.UnloadImage(image)

	texture := rl.LoadTextureFromImage(image)
	rl.SetTextureFilter(texture, .BILINEAR)
	rl.SetTextureWrap(texture, .CLAMP)

	return Texture_Handle {
		texture = texture,
		sprite = texture_info.sprite,
		animation = texture_info.animation,
	}
}

// Loads font by Asset_Name.
//
// Panics if name is not a Font_Name or the asset's type of a loaded Asset is not Font_Asset.
load_font :: proc(name: Asset_Name) -> rl.Font {
	font_name := name.(Font_Name)
	font_asset := fonts[font_name]
	font_info := font_asset.type.(Font_Asset)

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

