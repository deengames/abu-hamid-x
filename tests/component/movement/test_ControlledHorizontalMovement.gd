extends "res://addons/gut/test.gd"

var component_cls = preload('res://src/component/movement/ControlledHorizontalMovement.gd')

func test_init():
    var comp = component_cls.new()
    assert_true(comp != null)
