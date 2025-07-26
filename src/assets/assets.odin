package assets

import sprite "../sprite"
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


Cache :: struct {
	textures:      map[Texture_Name]Texture_Handle,
	fonts:         map[Font_Name]rl.Font,
	ui_sounds:     map[Sound_UI_Name]rl.Sound,
	player_sounds: map[Sound_Player_Name]rl.Sound,
	music_tracks:  map[Music_Name]rl.Music,
}


Asset :: struct {
	path: string,
	data: []u8,
	type: Type,
}

Type :: union {
	Texture,
	Music,
	Sound,
	Font,
}

Sound :: struct {}

Music :: struct {}

Texture :: struct {
	sprite_info: sprite.Info,
	animation:   sprite.Animation,
}

Font :: struct {
	default_font_size: i32,
}


//
// Procs
//


// Creates a new Asset_Cache and loads all existing assets into it.
//
// Note: All assets are defined in asset_files.odin.
cache_init :: proc() -> Cache {
	cache := Cache{}

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


cache_destroy :: proc(asset_cache: ^Cache) {
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

// Retrieve an asset from the asset cache.
get :: proc {
	get_texture,
	get_font,
	get_sound_player,
	get_sound_ui,
	get_music,
}

get_texture :: proc(asset_cache: Cache, texture_name: Texture_Name) -> Texture_Handle {
	if texture, exists := asset_cache.textures[texture_name]; exists {
		return texture
	}

	p := fmt.tprintf("texture does not exist: %v", texture_name)
	panic(p)
}


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

get_font :: proc(asset_cache: Cache, font_name: Font_Name) -> rl.Font {
	if font, exists := asset_cache.fonts[font_name]; exists {
		return font
	}

	p := fmt.tprintf("font does not exist: %v", font_name)
	panic(p)
}


@(private)
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

get_sound_player :: proc(asset_cache: Cache, player_sound: Sound_Player_Name) -> rl.Sound {
	if sound, exists := asset_cache.player_sounds[player_sound]; exists {
		return sound
	}

	p := fmt.tprintf("player sound does not exists: %v", player_sound)
	panic(p)
}

get_sound_ui :: proc(asset_cache: Cache, ui_sound: Sound_UI_Name) -> rl.Sound {
	if sound, exists := asset_cache.ui_sounds[ui_sound]; exists {
		return sound
	}

	p := fmt.tprintf("ui sound does not exists: %v", ui_sound)
	panic(p)
}


@(private)
load_music :: proc(music_name: Music_Name) -> rl.Music {
	// TODO: Implement!
	return rl.Music{}
}

get_music :: proc(asset_cache: Cache, music_name: Music_Name) -> rl.Music {
	if music, exists := asset_cache.music_tracks[music_name]; exists {
		return music
	}

	p := fmt.tprintf("music track does not exist: %v", music_name)
	panic(p)
}

