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
	music_asset := music[music_name]
	music_info := music_asset.type.(Music_Info)

	mp3 := rl.LoadMusicStreamFromMemory(
		FILE_TYPE_MP3,
		&music_asset.data[0],
		i32(len(music_asset.data)),
	)
	// NOTE: Music stream will be unloaded in destroy_cache

	return Music{info = music_info, rl_music = mp3}
}

