package game

import "core:testing"

@(test)
test_min_vec2 :: proc(t: ^testing.T) {
	Test_Case :: struct {
		name:   string,
		v1, v2: Vec2,
		want:   Vec2,
	}

	test_cases := []Test_Case {
		{"basic case", {1, 2}, {3, 4}, {1, 2}},
		{"reversed", {3, 4}, {1, 2}, {1, 2}},
		{"mixed components", {1, 5}, {3, 2}, {1, 2}},
		{"equal vectors", {2, 2}, {2, 2}, {2, 2}},
		{"negatives", {-1, 2}, {1, -2}, {-1, -2}},
		{"with zeros", {0, 0}, {1, 1}, {0, 0}},
	}

	for tc in test_cases {
		got := min_vec2(tc.v1, tc.v2)
		testing.expect_value(t, got, tc.want)
	}
}

