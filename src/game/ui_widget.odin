package game

import "core:testing"


UI_Widget :: union {
	UI_Label,
	UI_Button,
	UI_Slider,
}


ui_widget_draw :: proc(widget: UI_Widget, game: Game) {
	switch w in widget {
	case UI_Label:
		ui_label_draw(w, game)
	case UI_Button:
		ui_button_draw(w, game)
	case UI_Slider:
		ui_slider_draw(w, game)
	}
}

@(private)
ui_widget_count_focusable :: proc(widgets: []UI_Widget) -> (n: int) {
	for widget in widgets {
		if _, ok := widget.(UI_Label); !ok {
			n += 1
		}
	}

	return
}

@(test)
test_ui_widget_count_focusable :: proc(t: ^testing.T) {
	widgets := [?]UI_Widget {
		UI_Label{},
		UI_Label{},
		UI_Button{}, // 1
		UI_Label{},
		UI_Button{}, // 2
		UI_Label{},
		UI_Slider{}, // 3
		UI_Label{},
	}

	got := ui_widget_count_focusable(widgets[:])
	testing.expect_value(t, got, 4)
}

@(private)
ui_widget_set_focus :: proc(widget: ^UI_Widget, focused: bool) {
	switch &w in widget {
	case UI_Button:
		w.focused = focused
	case UI_Slider:
		w.focused = focused
	case UI_Label:
	// do nothing
	}
}

@(private)
ui_widget_get_focusable_at_index :: proc(widgets: []UI_Widget, index: int) -> (UI_Widget, bool) {
	current_index := 0

	for widget in widgets {
		if _, ok := widget.(UI_Label); ok {
			continue
		}

		if current_index == index {
			return widget, true
		}

		current_index += 1
	}

	return {}, false
}

