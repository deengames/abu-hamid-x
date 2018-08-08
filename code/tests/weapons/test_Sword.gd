extends "res://addons/gut/test.gd"

var sword_cls = preload('res://src/weapons/Sword.tscn')

var position = Vector2()
var sword

func setup():
	sword = sword_cls.instance()
	add_child(sword)

func teardown():
	remove_child(sword)

func test_init():
	assert_true(sword != null)
	
func test_toggle_toggles_sword():
	sword._toggle(true)
	assert_true(sword.visible)
	assert_true(sword.is_swinging)
	assert_false(sword.get_node("CollisionShape2D").disabled)
	
	sword._toggle(false)
	assert_false(sword.visible)
	assert_false(sword.is_swinging)
	assert_true(sword.get_node("CollisionShape2D").disabled)

func test_ready_toggles_sword_off_when_ready():
	assert_false(sword.visible)
	assert_false(sword.is_swinging)
	assert_true(sword.get_node("CollisionShape2D").disabled)

func test_swing_does_nothing_if_swinging():
	sword.is_swinging = true
	
	sword.swing()
	
	assert_true(sword.is_swinging)

func test_swing_starts_swinging_if_not_swinging():
	sword.is_swinging = false
	
	sword.swing()
	
	assert_true(sword.is_swinging)
