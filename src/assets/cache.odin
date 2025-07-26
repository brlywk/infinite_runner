package assets

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
	animations:   map[Animation_Name]Animation,
	textures:     map[Texture_Name]rl.Texture2D,
	fonts:        map[Font_Name]rl.Font,
	sounds:       map[Sound_Name]rl.Sound,
	music_tracks: map[Music_Name]rl.Music,
}


Asset :: struct {
	data: []u8,
	type: Type,
}

Type :: union {
	Animation_Info,
	Texture,
	Music,
	Sound,
	Font,
}

Sound :: struct {}

Music :: struct {}

Font :: struct {
	default_font_size: i32,
}

Texture :: struct {}


//
// Procs
//


// Creates a new Asset_Cache and loads all existing assets into it.
//
// Note: All assets are defined in asset_files.odin.
cache_init :: proc() -> Cache {
	cache := Cache{}

	// animations
	for _, k in animations {
		cache.animations[k] = load_animation(k)
	}

	// texture loading
	for _, k in textures {
		cache.textures[k] = load_texture(k)
	}

	// font loading
	for _, k in fonts {
		cache.fonts[k] = load_font(k)
	}

	// sound loading
	for _, k in sounds {
		cache.sounds[k] = load_sound(k)
	}

	// music loading
	for _, k in music {
		cache.music_tracks[k] = load_music(k)
	}


	return cache
}

cache_destroy :: proc(asset_cache: ^Cache) {
	// Animation
	for _, a in asset_cache.animations {
		rl.UnloadTexture(a.texture)
	}


	// Textures
	for _, th in asset_cache.textures {
		// does all cleanup work for a Texture_Handle
		rl.UnloadTexture(th)
	}

	// Fonts
	for _, f in asset_cache.fonts {
		rl.UnloadFont(f)
	}

	// Sounds
	for _, s in asset_cache.sounds {
		rl.UnloadSound(s)
	}

	// Music
	for _, m in asset_cache.music_tracks {
		rl.UnloadMusicStream(m)
	}

	// delete maps
	delete(asset_cache.animations)
	delete(asset_cache.textures)
	delete(asset_cache.fonts)
	delete(asset_cache.sounds)
	delete(asset_cache.music_tracks)
}

// Retrieve an asset from the asset cache.
get :: proc {
	get_animation,
	get_texture,
	get_font,
	get_sound,
	get_music,
}

get_animation :: proc(asset_cache: Cache, animation_name: Animation_Name) -> Animation {
	if animation, exists := asset_cache.animations[animation_name]; exists {
		return animation
	}

	p := fmt.tprintf("animation does not exist: %v", animation_name)
	panic(p)
}

get_texture :: proc(asset_cache: Cache, texture_name: Texture_Name) -> rl.Texture2D {
	if texture, exists := asset_cache.textures[texture_name]; exists {
		return texture
	}

	p := fmt.tprintf("texture does not exist: %v", texture_name)
	panic(p)
}

get_font :: proc(asset_cache: Cache, font_name: Font_Name) -> rl.Font {
	if font, exists := asset_cache.fonts[font_name]; exists {
		return font
	}

	p := fmt.tprintf("font does not exist: %v", font_name)
	panic(p)
}

get_sound :: proc(asset_cache: Cache, sound_name: Sound_Name) -> rl.Sound {
	if sound, exists := asset_cache.sounds[sound_name]; exists {
		return sound
	}

	p := fmt.tprintf("player sound does not exists: %v", sound_name)
	panic(p)
}

get_music :: proc(asset_cache: Cache, music_name: Music_Name) -> rl.Music {
	if music, exists := asset_cache.music_tracks[music_name]; exists {
		return music
	}

	p := fmt.tprintf("music track does not exist: %v", music_name)
	panic(p)
}

