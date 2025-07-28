package assets

import rl "vendor:raylib"


Sound :: struct {}


@(private)
load_sound :: proc(sound_name: Sound_Name) -> rl.Sound {
	sound_asset := sounds[sound_name]

	wave := rl.LoadWaveFromMemory(FILE_TYPE_WAV, &sound_asset.data[0], i32(len(sound_asset.data)))
	defer rl.UnloadWave(wave)

	sound := rl.LoadSoundFromWave(wave)

	return sound
}

