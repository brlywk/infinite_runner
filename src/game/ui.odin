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


UI_Slider_Func :: #type proc(
	value_ref: ^f32,
	min_value, max_value, step: f32,
	value_ref_normalized: bool,
)


UI_Slider :: struct {
	using control: UI_Control,
	value_ref:     ^f32,
	min_value:     f32,
	max_value:     f32,
	step:          f32,
	buttons_size:  f32,
	increment:     UI_Slider_Func,
	decrement:     UI_Slider_Func,
}

ui_slider_create :: proc(
	label: cstring,
	value_ref: ^f32,
	min_value, max_value, step: f32,
	increment_func, decrement_func: UI_Slider_Func,
) -> UI_Slider {
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
		increment = increment_func,
		decrement = decrement_func,
	}
}

ui_slider_draw :: proc(slider: UI_Slider, game: Game) {
	// draw buttons: left/right or decrease/increase


	// text
	draw_cool_text(
		slider.label,
		slider.font.size,
		{slider.rect.x, slider.rect.y}, // TODO: Adjust for buttons
		slider.font.color,
		slider.font.shadow_color,
	)
}

ui_slider_size :: proc(slider: UI_Slider) -> Vec2 {
	return {slider.rect.width, slider.rect.height}
}

ui_slider_set_pos :: proc(slider: ^UI_Slider, pos: Vec2) {
	slider.rect.x = pos.x
	slider.rect.y = pos.y
}

ui_slider_step_func :: proc(
	value_ref: ^f32,
	min_value, max_value, step: f32,
	increment: bool,
	value_ref_normalized := true,
) {
	actual_step := increment ? step : -step

	if value_ref_normalized {
		actual_value := value_ref^ * (max_value - min_value) + min_value

		actual_value += actual_step
		actual_value = clamp(actual_value, min_value, max_value)

		value_ref^ = (actual_value - min_value) / (max_value - min_value)
	} else {
		value_ref^ += actual_step
		value_ref^ = clamp(value_ref^, min_value, max_value)
	}
}

ui_slider_increment_func :: proc(
	value_ref: ^f32,
	min_value, max_value, step: f32,
	value_ref_normalized := true,
) {
	ui_slider_step_func(value_ref, min_value, max_value, step, true, value_ref_normalized)
}

ui_slider_decrement_func :: proc(
	value_ref: ^f32,
	min_value, max_value, step: f32,
	value_ref_normalized := true,
) {
	ui_slider_step_func(value_ref, min_value, max_value, step, false, value_ref_normalized)
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

