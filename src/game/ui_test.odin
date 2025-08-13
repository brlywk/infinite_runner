package game

import "core:testing"

@(test)
test_ui_slider_step_both_directions :: proc(t: ^testing.T) {
	// test increment then decrement (normalized)
	value: f32 = 0.5 // 50%

	ui_slider_increment_func(&value, 0, 100, 10, true)
	testing.expect(t, abs(value - 0.6) < 0.0001)

	ui_slider_decrement_func(&value, 0, 100, 10, true)
	testing.expect(t, abs(value - 0.5) < 0.0001)

	// test direct step function
	ui_slider_step_func(&value, 0, 100, 20, false, true) // decrement by 20
	testing.expect(t, abs(value - 0.3) < 0.0001)
}

@(test)
test_ui_slider_step_precision :: proc(t: ^testing.T) {
	// test with fractional steps that can cause floating point errors
	value: f32 = 0.1

	// increment by 0.1 multiple times (normalized, range 0..1, step 0.1)
	for i in 0 ..< 5 {
		ui_slider_increment_func(&value, 0, 1, 0.1, true)
	}
	testing.expect(t, abs(value - 0.6) < 0.0001)

	// decrement back
	for i in 0 ..< 3 {
		ui_slider_decrement_func(&value, 0, 1, 0.1, true)
	}
	testing.expect(t, abs(value - 0.3) < 0.0001)
}

@(test)
test_ui_slider_step_boundary_conditions :: proc(t: ^testing.T) {
	// test at exact boundaries
	value: f32 = 0.0 // at minimum
	ui_slider_decrement_func(&value, 0, 100, 10, true)
	testing.expect(t, abs(value - 0.0) < 0.0001)

	value = 1.0 // at maximum
	ui_slider_increment_func(&value, 0, 100, 10, true)
	testing.expect(t, abs(value - 1.0) < 0.0001)
}

@(test)
test_ui_slider_step_non_normalized :: proc(t: ^testing.T) {
	// test non-normalized mode
	value: f32 = 25.0

	ui_slider_increment_func(&value, 10, 50, 5, false)
	testing.expect_value(t, value, 30.0)

	ui_slider_decrement_func(&value, 10, 50, 5, false)
	testing.expect_value(t, value, 25.0)
}

@(test)
test_ui_slider_step_clamping :: proc(t: ^testing.T) {
	// test clamping in normalized mode
	value: f32 = 0.9 // 90% = actual value 9 in 0..10 range
	ui_slider_increment_func(&value, 0, 10, 3, true)
	testing.expect_value(t, value, 1.0) // should clamp to 1.0

	// test clamping in non-normalized mode
	value2: f32 = 9
	ui_slider_increment_func(&value2, 0, 10, 3, false)
	testing.expect_value(t, value2, 10.0) // should clamp to 10
}

