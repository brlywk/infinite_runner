package global

import "assets"

Settings :: struct {
	volume_master: f32,
	volume_sound:  f32,
	volume_music:  f32,
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

