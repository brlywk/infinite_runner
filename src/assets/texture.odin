package assets

import rl "vendor:raylib"

// Load texture by Asset_Name.
//
// Panics if name is not a Texture_Name.
@(private)
load_texture :: proc(texture_name: Texture_Name) -> rl.Texture2D {
	texture_asset := textures[texture_name]
	return load_texture_data(texture_asset.data)
}

@(private)
load_texture_data :: proc(data: []u8) -> rl.Texture2D {
	image := rl.LoadImageFromMemory(
		FILE_TYPE_PNG,
		// NOTE: (b/c otherwise I forget and wonder again in the future)
		// We get a reference to the first element of the slice, b/c in Odin a slice is a 
		// struct with a pointer to the array, length and capacity, but Raylib is in C,
		// and in C an array is just a pointer to the first element of that array...
		// so we need to get a pointer to the first element of our Odin slice!
		&data[0],
		i32(len(data)),
	)
	defer rl.UnloadImage(image)

	texture := rl.LoadTextureFromImage(image)
	rl.SetTextureFilter(texture, .BILINEAR)
	rl.SetTextureWrap(texture, .CLAMP)

	return texture
}

