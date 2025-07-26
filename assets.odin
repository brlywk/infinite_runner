package main

import "core:fmt"
import rl "vendor:raylib"

//
// Constants
//

FILE_TYPE_PNG :: ".png"
FILE_TYPE_TTF :: ".ttf"
FILE_TYPE_WAV :: ".wav"


//
// Structs
//


Asset_Cache :: struct {
	textures:      map[Texture_Name]Texture_Handle,
	fonts:         map[Font_Name]rl.Font,
	ui_sounds:     map[Sound_UI_Name]rl.Sound,
	player_sounds: map[Sound_Player_Name]rl.Sound,
	music_tracks:  map[Music_Name]rl.Music,
}


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


asset_cache_init :: proc() -> Asset_Cache {
	cache := Asset_Cache{}

	// texture loading
	for _, k in textures {
		cache.textures[k] = load_texture(k)
	}

	// font loading
	for _, k in fonts {
		cache.fonts[k] = load_font(k)
	}

	// sound loading
	for _, k in player_sounds {
		cache.player_sounds[k] = load_sound(k)
	}
	for _, k in ui_sounds {
		cache.ui_sounds[k] = load_sound(k)
	}

	// music loading
	for _, k in music {
		cache.music_tracks[k] = load_music(k)
	}


	return cache
}


asset_cache_destroy :: proc(asset_cache: ^Asset_Cache) {
	// Textures
	for _, th in asset_cache.textures {
		rl.UnloadTexture(th.texture)
		// TODO: Depending on Sprite and Animation fields do more cleanup
	}

	// Fonts
	for _, f in asset_cache.fonts {
		rl.UnloadFont(f)
	}

	// Sounds
	for _, ps in asset_cache.player_sounds {
		rl.UnloadSound(ps)
	}
	for _, us in asset_cache.ui_sounds {
		rl.UnloadSound(us)
	}

	// Music
	for _, m in asset_cache.music_tracks {
		rl.UnloadMusicStream(m)
	}

	// delete maps
	delete(asset_cache.textures)
	delete(asset_cache.fonts)
	delete(asset_cache.player_sounds)
	delete(asset_cache.ui_sounds)
	delete(asset_cache.music_tracks)
}


// Load texture by Asset_Name.
//
// Panics if name is not a Texture_Name.
load_texture :: proc(texture_name: Texture_Name) -> Texture_Handle {
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

get_asset :: proc {
	get_texture,
	get_font,
	get_sound_player,
	get_sound_ui,
	get_music,
}

get_texture :: proc(asset_cache: Asset_Cache, texture_name: Texture_Name) -> Texture_Handle {
	if texture, exists := asset_cache.textures[texture_name]; exists {
		return texture
	}

	p := fmt.tprintf("texture does not exist: %v", texture_name)
	panic(p)
}

get_font :: proc(asset_cache: Asset_Cache, font_name: Font_Name) -> rl.Font {
	if font, exists := asset_cache.fonts[font_name]; exists {
		return font
	}

	p := fmt.tprintf("font does not exist: %v", font_name)
	panic(p)
}

get_sound_player :: proc(asset_cache: Asset_Cache, player_sound: Sound_Player_Name) -> rl.Sound {
	if sound, exists := asset_cache.player_sounds[player_sound]; exists {
		return sound
	}

	p := fmt.tprintf("player sound does not exists: %v", player_sound)
	panic(p)
}

get_sound_ui :: proc(asset_cache: Asset_Cache, ui_sound: Sound_UI_Name) -> rl.Sound {
	if sound, exists := asset_cache.ui_sounds[ui_sound]; exists {
		return sound
	}

	p := fmt.tprintf("ui sound does not exists: %v", ui_sound)
	panic(p)
}

get_music :: proc(asset_cache: Asset_Cache, music_name: Music_Name) -> rl.Music {
	if music, exists := asset_cache.music_tracks[music_name]; exists {
		return music
	}

	p := fmt.tprintf("music track does not exist: %v", music_name)
	panic(p)
}

// Loads font by Asset_Name.
//
// Panics if name is not a Font_Name or the asset's type of a loaded Asset is not Font_Asset.
load_font :: proc(font_name: Font_Name) -> rl.Font {
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


load_sound :: proc(sound_name: Sound_Name) -> rl.Sound {
	sound_asset: Asset = ---

	switch s in sound_name {
	case Sound_Player_Name:
		sound_asset = player_sounds[s]
	case Sound_UI_Name:
		sound_asset = ui_sounds[s]
	case:
		panic("unknown sound name")
	}

	wave := rl.LoadWaveFromMemory(FILE_TYPE_WAV, &sound_asset.data[0], i32(len(sound_asset.data)))
	defer rl.UnloadWave(wave)

	sound := rl.LoadSoundFromWave(wave)

	return sound
}

load_music :: proc(music_name: Music_Name) -> rl.Music {
	// TODO: Implement!
	return rl.Music{}
}

