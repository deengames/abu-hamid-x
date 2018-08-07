extends "res://addons/gut/test.gd"

var component_cls = preload('res://src/component/movement/ControlledHorizontalMovement.gd')

var velocity = Vector2()
var comp

func setup():
	comp = component_cls.new()
	add_child(comp)

func teardown():
	remove_child(comp)

func test_init():
	assert_true(comp != null)

func test_physics_process_does_nothing_if_no_input():
	var old_velocity = velocity

	comp._physics_process(0)

	assert_eq(velocity, old_velocity)


func test_physics_process_moves_left_if_input_left():
	var old_velocity = velocity
	Input.action_press('move_left')

	comp._physics_process(0)

	assert_lt(velocity, old_velocity)

	Input.action_release('move_left')


func test_physics_process_moves_right_if_input_right():
	var old_velocity = velocity
	Input.action_press('move_right')

	comp._physics_process(0)

	assert_gt(velocity, old_velocity)

	Input.action_release('move_right')