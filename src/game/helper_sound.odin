package game

import "../global"
import rl "vendor:raylib"

play_sound :: proc(sound_name: Sound_Name) {
	sound := global.get_asset(sound_name)

	rl.SetSoundVolume(sound.rl_sound, global.sound_volume(sound))
	rl.PlaySound(sound.rl_sound)
}

