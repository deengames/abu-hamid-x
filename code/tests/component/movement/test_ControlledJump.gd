extends "res://addons/gut/test.gd"

var component_cls = preload('res://src/component/movement/ControlledJump.gd')

var velocity = Vector2()
var comp

var _is_on_floor = true

func is_on_floor():
    return _is_on_floor

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

func test_physics_process_does_nothing_if_input_given_but_not_on_floor():
    var old_velocity = velocity
    _is_on_floor = false
    Input.action_press('jump')

    comp._physics_process(0)

    assert_eq(velocity, old_velocity)

    Input.action_release('jump')

func test_physics_process_jumps_if_input_given_and_on_floor():
    var old_velocity = velocity
    _is_on_floor = true
    Input.action_press('jump')

    comp._physics_process(0)

    assert_eq(velocity, old_velocity + Vector2(0, -comp.jump_velocity))

    Input.action_release('jump')