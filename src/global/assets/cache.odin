package assets

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
	sounds:       map[Sound_Name]Sound,
	music_tracks: map[Music_Name]Music,
}


Asset :: struct {
	data: []u8,
	type: Type,
}

Type :: union {
	Animation_Info,
	Texture,
	Music_Info,
	Sound_Info,
	Font,
}

Name :: union {
	Animation_Name,
	Texture_Name,
	Font_Name,
	Sound_Name,
	Music_Name,
}


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
		rl.UnloadSound(s.rl_sound)
	}

	// Music
	for _, m in asset_cache.music_tracks {
		rl.UnloadMusicStream(m.rl_music)
	}

	// delete maps
	delete(asset_cache.animations)
	delete(asset_cache.textures)
	delete(asset_cache.fonts)
	delete(asset_cache.sounds)
	delete(asset_cache.music_tracks)
}

