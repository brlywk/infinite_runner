package game

import "core:fmt"
import "core:log"
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


UI_Slider_Func :: #type proc(slider: ^UI_Slider, value_ref_normalized: bool = true)

UI_Slider_State :: enum {
	None,
	Increment,
	Decrement,
}

UI_Slider :: struct {
	using control:    UI_Control,
	state:            UI_Slider_State,
	value_ref:        ^f32,
	min_value:        f32,
	max_value:        f32,
	step:             f32,
	buttons_size:     f32,
	label_size:       Vec2,
	max_value_size:   Vec2,
	text_button_gap:  f32,
	inner_button_gap: f32,
	increment:        UI_Slider_Func,
	decrement:        UI_Slider_Func,
}

ui_slider_create :: proc(
	label: cstring,
	value_ref: ^f32,
	min_value, max_value, step: f32,
	increment_func, decrement_func: UI_Slider_Func,
) -> UI_Slider {
	text_button_gap :: 4.0
	inner_button_gap :: 1.0

	font := ui_font_default
	font.color = UI_BUTTON_FONT_COLOR

	label_size := rl.MeasureTextEx(ui_font_default.face, label, ui_font_default.size, 0)
	max_value_size := rl.MeasureTextEx(
		ui_font_default.face,
		fmt.ctprintf("%.0f", max_value),
		ui_font_default.size,
		0,
	)
	button_size := label_size.y // button should be square so as wide as the label is high

	return UI_Slider {
		control = UI_Control{label = label, selectable = true, font = font},
		rect = {
			x = 0,
			y = 0,
			width = label_size.x +
			text_button_gap +
			max_value_size.x +
			2 * inner_button_gap +
			2 * button_size,
			height = label_size.y,
		},
		state = .None,
		value_ref = value_ref,
		min_value = min_value,
		max_value = max_value,
		step = step,
		buttons_size = button_size,
		text_button_gap = text_button_gap,
		inner_button_gap = inner_button_gap,
		label_size = label_size,
		max_value_size = max_value_size,
		increment = increment_func,
		decrement = decrement_func,
	}
}

ui_slider_draw :: proc(slider: UI_Slider, game: Game) {
	// state-based colors
	increment_button_color := slider.focused ? UI_BUTTON_FONT_COLOR_FOCUS : UI_BUTTON_FONT_COLOR
	decrement_button_color := slider.focused ? UI_BUTTON_FONT_COLOR_FOCUS : UI_BUTTON_FONT_COLOR
	value_text_color := slider.focused ? UI_BUTTON_FONT_COLOR_FOCUS : UI_BUTTON_FONT_COLOR
	value_text := ui_slider_format_value(slider.value_ref, slider.min_value, slider.max_value)
	value_text_size := rl.MeasureTextEx(slider.font.face, value_text, slider.font.size, 0)


	// change color based on which state of "selection" the slider is in
	switch slider.state {
	case .Increment:
		increment_button_color = UI_BUTTON_FONT_COLOR_FOCUS
		value_text_color = UI_BUTTON_FONT_COLOR_FOCUS

	case .Decrement:
		decrement_button_color = UI_BUTTON_FONT_COLOR_FOCUS
		value_text_color = UI_BUTTON_FONT_COLOR_FOCUS

	case .None:
	}

	// draw buttons: left/right or decrease/increase
	decr_button_x := slider.rect.x + slider.label_size.x + slider.text_button_gap
	value_text_x :=
		decr_button_x +
		slider.buttons_size +
		slider.inner_button_gap +
		slider.max_value_size.x / 2 -
		value_text_size.x / 2
	inc_button_x := value_text_x + slider.max_value_size.x + slider.inner_button_gap * 2

	// triangle stuff
	center_y := slider.rect.y + slider.buttons_size / 2

	// decrement
	decr_v1 := Vec2{decr_button_x, center_y}
	decr_v2 := Vec2{decr_button_x + slider.buttons_size, slider.rect.y}
	decr_v3 := Vec2{decr_button_x + slider.buttons_size, slider.rect.y + slider.buttons_size}

	rl.DrawTriangleLines(
		v1 = decr_v1 + 1,
		v2 = decr_v2 + 1,
		v3 = decr_v3 + 1,
		color = slider.font.shadow_color,
	)
	rl.DrawTriangleLines(v1 = decr_v1, v2 = decr_v2, v3 = decr_v3, color = decrement_button_color)

	// text
	draw_cool_text(
		value_text,
		slider.font.size,
		{value_text_x, slider.rect.y},
		value_text_color,
		slider.font.shadow_color,
	)

	// increment
	inc_v1 := Vec2{inc_button_x, slider.rect.y}
	inc_v2 := Vec2{inc_button_x + slider.buttons_size, center_y}
	inc_v3 := Vec2{inc_button_x, slider.rect.y + slider.buttons_size}

	rl.DrawTriangleLines(
		v1 = inc_v1 + 1,
		v2 = inc_v2 + 1,
		v3 = inc_v3 + 1,
		color = slider.font.shadow_color,
	)
	rl.DrawTriangleLines(v1 = inc_v1, v2 = inc_v2, v3 = inc_v3, color = increment_button_color)

	// label
	draw_cool_text(
		slider.label,
		slider.font.size,
		{slider.rect.x, slider.rect.y},
		slider.focused ? UI_BUTTON_FONT_COLOR_FOCUS : slider.font.color,
		slider.font.shadow_color,
	)
}

ui_slider_unfocus :: proc(slider: ^UI_Slider) {
	// it should have been set to false by the menu itself, but in case that failed,
	// set it to false either way
	if slider.focused do slider.focused = false

	if !slider.focused {
		slider.state = .None
	}
}

ui_slider_size :: proc(slider: UI_Slider) -> Vec2 {
	log.debugf(
		"SLIDER: rect=%v label=%s label_size=%v value_ref_size=%v",
		slider.rect,
		slider.label,
		slider.label_size,
		slider.max_value_size,
	)

	return {slider.rect.width, slider.rect.height}
}

ui_slider_set_pos :: proc(slider: ^UI_Slider, pos: Vec2) {
	slider.rect.x = pos.x
	slider.rect.y = pos.y
}

ui_slider_format_value :: proc(value_ref: ^f32, min_value, max_value: f32) -> cstring {
	actual_value := value_ref^ * (max_value - min_value) + min_value
	return fmt.ctprintf("%.0f", actual_value)
}

ui_slider_step_func :: proc(slider: ^UI_Slider, increment: bool, value_ref_normalized := true) {
	actual_step := increment ? slider.step : -slider.step

	if value_ref_normalized {
		actual_value :=
			slider.value_ref^ * (slider.max_value - slider.min_value) + slider.min_value

		actual_value += actual_step
		actual_value = clamp(actual_value, slider.min_value, slider.max_value)

		slider.value_ref^ =
			(actual_value - slider.min_value) / (slider.max_value - slider.min_value)
	} else {
		slider.value_ref^ += actual_step
		slider.value_ref^ = clamp(slider.value_ref^, slider.min_value, slider.max_value)
	}
}

ui_slider_increment_func :: proc(slider: ^UI_Slider, value_ref_normalized := true) {
	slider.state = .Increment
	ui_slider_step_func(slider, true, value_ref_normalized)
}

ui_slider_decrement_func :: proc(slider: ^UI_Slider, value_ref_normalized := true) {
	slider.state = .Decrement
	ui_slider_step_func(slider, false, value_ref_normalized)
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

