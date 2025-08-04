package assets

import rl "vendor:raylib"

Sound :: struct {
	using info: Sound_Info,
	rl_sound:   rl.Sound,
}

Sound_Info :: struct {
	base_volume: f32,
}


@(private)
load_sound :: proc(sound_name: Sound_Name) -> Sound {
	sound_asset := sounds[sound_name]
	sound_info := sound_asset.type.(Sound_Info)

	wave := rl.LoadWaveFromMemory(FILE_TYPE_WAV, &sound_asset.data[0], i32(len(sound_asset.data)))
	defer rl.UnloadWave(wave)

	rl_sound := rl.LoadSoundFromWave(wave)

	return Sound{rl_sound = rl_sound, info = sound_info}
}

