package global

import "assets"
import "core:fmt"
import rl "vendor:raylib"

// Retrieve an asset from the asset cache.
//
// Note: Prefer using get over the respective get_* method.
get_asset :: proc {
	get_asset_animation,
	get_asset_texture,
	get_asset_font,
	get_asset_sound,
	get_asset_music,
}

get_asset_animation :: proc(animation_name: assets.Animation_Name) -> ^assets.Animation {
	if animation, exists := &ctx().assets.animations[animation_name]; exists {
		return animation
	}

	p := fmt.tprintf("animation does not exist: %v", animation_name)
	panic(p)
}

get_asset_texture :: proc(texture_name: assets.Texture_Name) -> rl.Texture2D {
	if texture, exists := ctx().assets.textures[texture_name]; exists {
		return texture
	}

	p := fmt.tprintf("texture does not exist: %v", texture_name)
	panic(p)
}

get_asset_font :: proc(font_name: assets.Font_Name) -> rl.Font {
	if font, exists := ctx().assets.fonts[font_name]; exists {
		return font
	}

	p := fmt.tprintf("font does not exist: %v", font_name)
	panic(p)
}

get_asset_sound :: proc(sound_name: assets.Sound_Name) -> assets.Sound {
	if sound, exists := ctx().assets.sounds[sound_name]; exists {
		return sound
	}

	p := fmt.tprintf("player sound does not exists: %v", sound_name)
	panic(p)
}

get_asset_music :: proc(music_name: assets.Music_Name) -> assets.Music {
	if music, exists := ctx().assets.music_tracks[music_name]; exists {
		return music
	}

	p := fmt.tprintf("music track does not exist: %v", music_name)
	panic(p)
}

