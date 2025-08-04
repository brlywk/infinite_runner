package assets

import rl "vendor:raylib"

Music :: struct {
	using info: Music_Info,
	rl_music:   rl.Music,
}

Music_Info :: struct {
	base_volume: f32,
}


@(private)
load_music :: proc(music_name: Music_Name) -> Music {
	// TODO: Implement!
	return Music{}
}

