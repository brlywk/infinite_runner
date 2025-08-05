package global

import "assets"
import "core:encoding/json"
import "core:log"
import "core:os"

SETTINGS_FILE :: "settings.json"
DEFAULT_SETTINGS :: Settings {
	volume_master = 1.0,
	volume_music  = 0.75,
	volume_sound  = 1.0,
	fullscreen    = false,
}


Settings :: struct {
	volume_master: f32,
	volume_sound:  f32,
	volume_music:  f32,
	fullscreen:    bool,
}


settings_load :: proc() -> Settings {
	// if no settings exist yet, create file with default settings
	// and return default settings
	if !os.exists(SETTINGS_FILE) {
		settings := DEFAULT_SETTINGS
		settings_save(settings)
		return settings
	}

	// read file
	data, read_ok := os.read_entire_file(SETTINGS_FILE)
	if !read_ok {
		log.error("Failed to read settings.json, using defaults.")
		return DEFAULT_SETTINGS
	}
	defer delete(data)

	settings := Settings{}
	unmarshal_err := json.unmarshal(data, &settings)
	if unmarshal_err != nil {
		log.errorf("Failed to parse settings: %v. Using defaults", unmarshal_err)
		return DEFAULT_SETTINGS
	}

	return settings
}

settings_save :: proc(settings: Settings) {
	data, marshal_err := json.marshal(settings, {pretty = true})
	if marshal_err != nil {
		log.errorf("Failed to save settings: %v.", marshal_err)
		return
	}
	defer delete(data)

	write_ok := os.write_entire_file(SETTINGS_FILE, data)
	if !write_ok {
		log.errorf("Failed to write settings: %v.")
	}

	log.info("Settings saved.")
}


// Returns the volume of a sound, taking global master and sound volume settings into account.
sound_volume :: proc(sound: assets.Sound) -> f32 {
	master_volume := ctx().settings.volume_master
	sound_volume := ctx().settings.volume_sound
	return master_volume * sound_volume * sound.base_volume
}


// Returns the volume of a music track, taking global master and music volume settings into account.
music_volume :: proc(music: assets.Music) -> f32 {
	master_volume := ctx().settings.volume_master
	sound_volume := ctx().settings.volume_music
	return master_volume * sound_volume * music.base_volume
}

