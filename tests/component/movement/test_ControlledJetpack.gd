extends "res://addons/gut/test.gd"

var component_cls = preload('res://src/component/movement/ControlledJetpack.gd')

var velocity = Vector2()
var comp

var _is_on_floor = false

func is_on_floor():
    return _is_on_floor

func setup():
	comp = component_cls.new()
	add_child(comp)

func teardown():
	remove_child(comp)

func test_init():
	assert_true(comp != null)

func test_activates_when_input_given_and_not_on_floor():
    _is_on_floor = false
    comp.active = false
    Input.action_press("jump")

    comp._physics_process(0)

    assert_true(comp.active)

    Input.action_release("jump")

func test_doesnt_activate_when_input_given_and_on_floor():
    _is_on_floor = true
    comp.active = false
    Input.action_press("jump")

    comp._physics_process(0)

    assert_false(comp.active)

    Input.action_release("jump")

func test_deactivates_when_on_floor():
    _is_on_floor = true
    comp.active = true

    comp._physics_process(0)
 
    assert_false(comp.active)

func test_doesnt_move_when_active_and_no_input_given():
    var old_velocity = velocity
    comp.active = true

    comp._physics_process(0)
 
    assert_eq(velocity, old_velocity)

func test_doesnt_moves_up_when_active_and_input_given():
    var old_velocity = velocity
    comp.active = true
    Input.action_press("move_up")

    comp._physics_process(0)
    
    assert_lt(velocity, old_velocity)

    Input.action_release("move_up")

func test_doesnt_moves_down_when_active_and_input_given():
    var old_velocity = velocity
    comp.active = true
    Input.action_press("move_down")

    comp._physics_process(0)
    
    assert_gt(velocity, old_velocity)

    Input.action_release("move_down")