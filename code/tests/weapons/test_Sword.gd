extends "res://addons/gut/test.gd"

var sword_cls = preload('res://src/weapons/Sword.tscn')

var sword

func setup():
	sword = sword_cls.instance()
	add_child(sword)

func teardown():
	remove_child(sword)

func test_init():
	assert_true(sword != null)
	
func test_toggle_toggles_sword_visibility_and_collision():
	sword._toggle(true)
	assert_true(sword.visible)
	assert_true(sword.is_swinging)
	assert_false(sword.get_node("CollisionShape2D").disabled)
	
	sword._toggle(false)
	assert_false(sword.visible)
	assert_false(sword.is_swinging)
	assert_true(sword.get_node("CollisionShape2D").disabled)

func test_ready_toggles_sword_off_when_ready():
	sword._ready()

	assert_false(sword.visible)
	assert_false(sword.is_swinging)
	assert_true(sword.get_node("CollisionShape2D").disabled)

func test_swing_does_nothing_if_already_swinging():
	sword.is_swinging = true
	
	sword.swing()
	
	assert_true(sword.is_swinging)

func test_swing_starts_swinging_if_not_swinging():
	sword.is_swinging = false
	
	sword.swing()
	
	assert_true(sword.is_swinging)

func test_get_swing_direction_returns_left_if_mouse_left_of_player():
	sword.global_position = Vector2()
	var mouse_pos = Vector2(-5, 0)

	var direction = sword._get_swing_direction(mouse_pos)

	assert_eq(direction, sword.DIRECTION.LEFT)

func test_get_swing_direction_returns_right_if_mouse_right_of_player():
	sword.global_position = Vector2()
	var mouse_pos = Vector2(5, 0)

	var direction = sword._get_swing_direction(mouse_pos)

	assert_eq(direction, sword.DIRECTION.RIGHT)

func test_process_swing_returns_angles_depending_on_mouse_pos():
	# this also implicitly tests direction
	# static input -> static output
	sword.global_position = Vector2()
	var test_table = {
		Vector2(-5, 0): {end=0, start=-PI},
		Vector2(5, 0): {end=0, start=PI},
		Vector2(-54, -134): {end=1.187719, start=-1.953873},
		Vector2(-211, -21): {end=0.099199, start=-3.042393},
		Vector2(-190, 81): {end=-0.402985, start=-3.544577},
		Vector2(140, 196): {end=-5.332638, start=-2.191046},
		Vector2(308, 100): {end=-5.969247, start=-2.827654},
		Vector2(250, -36): {end=-0.143017, start=2.998576},
		Vector2(-173, -15): {end=0.086489, start=-3.055104},
		Vector2(190, 162): {end=-5.577166, start=-2.435573},
		Vector2(204, -128): {end=-0.56036, start=2.581233},
		Vector2(-124, 117): {end=-0.756361, start=-3.897953},
		Vector2(169, 168): {end=-5.500755, start=-2.359162},
		Vector2(-129, -118): {end=0.740893, start=-2.400699}
	}
	
	# error margin for rounding errors
	var error_margin = 0.05
	
	for mouse_pos in test_table:
		var expected = test_table[mouse_pos]
		
		var actual = sword._process_swing(mouse_pos)
		print(actual, ' : ', expected)
		
		assert_almost_eq(actual.start, expected.start, error_margin)
		assert_almost_eq(actual.end, expected.end, error_margin)