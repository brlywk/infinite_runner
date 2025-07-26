package assets

import sprite "../sprite"
import rl "vendor:raylib"

//
// Structs
//


Texture_Handle :: struct {
	texture:     rl.Texture2D,
	sprite_info: sprite.Info,
	animation:   sprite.Animation,
}


//
// Procs
//


// Load texture by Asset_Name.
//
// Panics if name is not a Texture_Name.
@(private)
load_texture :: proc(texture_name: Texture_Name) -> Texture_Handle {
	texture_asset := textures[texture_name]
	texture_info := texture_asset.type.(Texture)

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
		sprite_info = texture_info.sprite_info,
		animation = texture_info.animation,
	}
}


texture_handle_destroy :: proc(texture_handle: ^Texture_Handle) {
	texture_handle.texture = rl.Texture2D{}
	// TODO: Sprite and animation freeing if necessary
}

