extends "res://addons/gut/test.gd"

var bullet_cls = preload('res://src/weapons/Bullet/Bullet.tscn')

var bullet

func setup():
	bullet = bullet_cls.instance()
	add_child(bullet)

func teardown():
	remove_child(bullet)

func test_init():
	assert_true(bullet != null)

func test_collide_ignores_if_info_is_null():
	bullet.collide(null)

	assert_false(bullet.is_queued_for_deletion())

func test_collide_frees_if_info_is_not_null():
	bullet.collide(true)

	assert_true(bullet.is_queued_for_deletion())

func test_physics_process_moves_bullet():
	var test_table = [
		Vector2(5, 0),
		Vector2(-5, 0),
		Vector2(0, 5),
		Vector2(0, -5),
	]

	for velocity in test_table:
		bullet.velocity = velocity
		bullet.position = Vector2()

		bullet._physics_process(1)

		assert_eq(bullet.position, velocity)

func test_init_initializes_bullet_sets_velocity():
	var speed = 2000
	var angle = PI/2
	var position = Vector2(5, 5)

	bullet.init(speed, angle, position)

	assert_eq(bullet.velocity, Vector2(0, -speed).rotated(angle))
	assert_eq(bullet.position, position)