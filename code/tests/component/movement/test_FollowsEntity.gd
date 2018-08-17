extends "res://addons/gut/test.gd"

var component_cls = preload('res://src/component/movement/FollowsEntity.gd')

var velocity = Vector2()
var comp
var _on_floor = true

func is_on_floor():
	return _on_floor

class EntityMock:
	var position = Vector2()

func setup():
	_on_floor = true
	velocity = Vector2()

	comp = component_cls.new()
	var e = EntityMock.new()
	comp.init(e)
	add_child(comp)

func teardown():
	remove_child(comp)

func test_init():
	assert_true(comp != null)

func test_physics_process_does_nothing_if_not_on_floor():
	_on_floor = false
	var old_velocity = velocity

	comp._physics_process(0)

	assert_eq(velocity, old_velocity)

func test_physics_process_moves_towards_entity_along_x_axis():
	comp.entity.position = Vector2(5, 0)
	var old_velocity = velocity
	var error_margin = 0.05

	comp._physics_process(0)

	assert_gt(velocity.x, old_velocity.x)
	assert_almost_eq(velocity.y, old_velocity.y, error_margin)


func test_physics_process_moves_towards_entity_along_y_axis():
	comp.entity.position = Vector2(0, 5)
	var old_velocity = velocity
	var error_margin = 0.05

	comp._physics_process(0)

	assert_gt(velocity.y, old_velocity.y)
	assert_almost_eq(velocity.x, old_velocity.x, error_margin)


func test_physics_process_moves_towards_entity_diagonally():
	comp.entity.position = Vector2(5, 5)
	var old_velocity = velocity

	comp._physics_process(0)

	assert_gt(velocity.y, old_velocity.y)
	assert_gt(velocity.x, old_velocity.x)