package game

import rl "vendor:raylib"


// 
// GLOBALS
//


ui_font_default: UI_Font


//
// GENERAL TYPES
//


// Callback proc for all UI controls that need to run some arbitrary code.
UI_Callback :: #type proc(game: ^Game)

UI_Font :: struct {
	face:         rl.Font,
	size:         f32,
	color:        rl.Color,
	shadow:       bool,
	shadow_color: rl.Color,
}

UI_Control :: struct {
	rect:       Rect,
	label:      cstring,
	font:       UI_Font,
	selectable: bool,
	focused:    bool,
	hovered:    bool,
}


//
// BUTTON
//


UI_Button :: struct {
	using control: UI_Control,
	callback:      UI_Callback,
}

ui_button_create :: proc(
	label: cstring,
	rect: Rect,
	callback: UI_Callback,
	font: UI_Font = ui_font_default,
) -> UI_Button {
	return UI_Button {
		control = UI_Control{label = label, rect = rect, selectable = true, font = font},
		callback = callback,
	}
}

ui_button_draw :: proc(button: UI_Button, game: Game) {
	rl.DrawRectangleRec(button.rect, button.focused ? UI_BUTTON_BG_FOCUS : UI_BUTTON_BG)
	rl.DrawRectangleLinesEx(
		button.rect,
		UI_BUTTON_BORDER,
		button.focused ? UI_BUTTON_BORDER_COLOR_FOCUS : UI_BUTTON_BORDER_COLOR,
	)

	text_size := rl.MeasureTextEx(button.font.face, button.label, button.font.size, 0)
	text_x := button.rect.x + (button.rect.width - text_size.x) / 2
	text_y := button.rect.y + (button.rect.height - text_size.y) / 2
	draw_cool_text(
		button.label,
		button.font.size,
		Vec2{text_x, text_y},
		button.focused ? UI_BUTTON_FONT_COLOR_FOCUS : button.font.color,
	)
}


//
// SLIDER
//


UI_Slider :: struct {
	using control: UI_Control,
	value_ref:     ^f32,
	min_value:     i32,
	max_value:     i32,
	step:          i32,
}

ui_slider_create :: proc(
	label: cstring,
	value_ref: ^f32,
	min_value, max_value, step: i32,
) -> UI_Slider {
	// TODO: Sliders need to create their buttons first, and probably need enter, exit, key-press
	// callbacks :o

	return UI_Slider {
		control = UI_Control {
			label      = label,
			// rect = rect,
			selectable = true,
			font       = ui_font_default,
		},
		value_ref = value_ref,
		min_value = min_value,
		max_value = max_value,
		step = step,
	}
}

ui_slider_draw :: proc(slider: UI_Slider, game: Game) {
	rl.DrawText("I'm a slider!", 16, game.screen_height / 2, 8, rl.WHITE)
}


//
// LABEL
//


UI_Label :: struct {
	using control: UI_Control,
}

ui_label_create :: proc(
	label: cstring,
	font: UI_Font,
	pos: Vec2,
	font_size: f32 = FONT_SIZE_DEFAULT,
) -> UI_Label {
	modified := font
	modified.size = font_size

	label_size := rl.MeasureTextEx(font.face, label, font.size, 0.0)

	return UI_Label {
		label = label,
		font = modified,
		rect = {pos.x, pos.y, label_size.x, label_size.y},
	}

}

ui_label_draw :: proc(label: UI_Label, game: Game, center := true) {
	if center {
		draw_center_text_x(
			label.label,
			label.font.size,
			game,
			label.rect.y,
			label.font.color,
			label.font.shadow_color,
		)
	} else {
		draw_cool_text(
			label.label,
			label.font.size,
			{label.rect.x, label.rect.y},
			label.font.color,
			label.font.shadow_color,
		)
	}
}

