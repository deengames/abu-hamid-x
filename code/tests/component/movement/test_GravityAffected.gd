extends "res://addons/gut/test.gd"

var component_cls = preload('res://src/component/movement/GravityAffected.gd')

var velocity = Vector2()
var comp

func setup():
	comp = component_cls.new()
	add_child(comp)

func teardown():
    remove_child(comp)
    
func test_init():
    assert_true(comp != null)

func test_physics_process_applies_gravity():
    var test_table = [
        {times=10, delta=1},
        {times=20, delta=0.5},
        {times=50, delta=5}
    ]

    for data in test_table:
        var old_velocity = velocity

        gut.simulate(comp, data.times, data.delta)

        assert_eq(velocity, old_velocity + comp.gravity_vec * data.times * data.delta)
