extends "res://addons/gut/test.gd"

var component_cls = preload('res://src/component/SpawnsWaves.tscn')

var comp

func setup():
	comp = component_cls.instance()
	add_child(comp)

func teardown():
	remove_child(comp)

func test_init():
	assert_true(comp != null)
