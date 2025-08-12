#+private file
package game

import rl "vendor:raylib"

/* NOTE:
   This file contains code that I initially needed for my own little
   UI implementation, but after some refactoring became useless.
   Nevertheless, I want to keep the code in case it might become useful
   again, or it might become useful for another project ;)
*/


UI_Toggle :: struct {
	using control:   UI_Control,
	toggle_box_size: Vec2,
	toggle_box_gap:  f32, // gap between label and checkbox
	text_size:       Vec2,
	value_ref:       ^bool,
}

ui_toggle_create :: proc(label: cstring, value_ref: ^bool) -> UI_Toggle {
	toggle_box_gap: f32 : 4.0

	toggle_text_size := rl.MeasureTextEx(ui_font_default.face, label, ui_font_default.size, 0.0)
	toggle_box_size_outer_side: f32 = toggle_text_size.y

	toggle_height := toggle_text_size.y
	toggle_width := toggle_text_size.x + toggle_box_gap + toggle_box_size_outer_side

	return UI_Toggle {
		control = UI_Control {
			label = label,
			selectable = true,
			font = ui_font_default,
			rect = {0, 0, toggle_width, toggle_height},
		},
		toggle_box_size = {toggle_box_size_outer_side, toggle_box_size_outer_side},
		toggle_box_gap = toggle_box_gap,
		text_size = toggle_text_size,
		value_ref = value_ref,
	}
}

ui_toggle_size :: proc(toggle: UI_Toggle) -> Vec2 {
	return {toggle.rect.width, toggle.rect.height}
}

ui_toggle_set_pos :: proc(toggle: ^UI_Toggle, pos: Vec2) {
	toggle.rect.x = pos.x
	toggle.rect.y = pos.y
}

ui_toggle_draw :: proc(toggle: UI_Toggle, game: Game) {
	// draw text
	draw_cool_text(
		toggle.label,
		toggle.font.size,
		{toggle.rect.x, toggle.rect.y},
		toggle.focused ? UI_BUTTON_FONT_COLOR_FOCUS : UI_BUTTON_FONT_COLOR,
		toggle.font.shadow_color,
	)

	// draw checkbox
	box_outer_x := toggle.rect.x + toggle.text_size.x + toggle.toggle_box_gap
	box_outer_y := toggle.rect.y

	// outer box shadow
	rl.DrawRectangleLinesEx(
		Rect {
			box_outer_x + FONT_SHADOW_OFFSET.x,
			box_outer_y + FONT_SHADOW_OFFSET.y,
			toggle.toggle_box_size.x,
			toggle.toggle_box_size.y,
		},
		1.0,
		toggle.font.shadow_color,
	)

	// outer box border
	rl.DrawRectangleLinesEx(
		Rect{box_outer_x, box_outer_y, toggle.toggle_box_size.x, toggle.toggle_box_size.y},
		1.0,
		toggle.focused ? UI_BUTTON_FONT_COLOR_FOCUS : UI_BUTTON_FONT_COLOR,
	)

	if toggle.value_ref != nil && toggle.value_ref^ {
		box_inner_gap: f32 : 1.0
		box_inner_pos := Vec2{box_outer_x + 2 * box_inner_gap, box_outer_y + 2 * box_inner_gap}
		box_inner_size := Vec2 {
			toggle.toggle_box_size.x - 4 * box_inner_gap,
			toggle.toggle_box_size.y - 4 * box_inner_gap,
		}

		rl.DrawRectangleV(
			box_inner_pos,
			box_inner_size,
			toggle.focused ? UI_BUTTON_FONT_COLOR_FOCUS : UI_BUTTON_FONT_COLOR,
		)
	}
}

