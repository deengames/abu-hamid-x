extends "res://addons/gut/test.gd"

var gun_cls = preload('res://src/weapons/Gun.tscn')

var gun

func setup():
	gun = gun_cls.instance()
	add_child(gun)

func teardown():
	remove_child(gun)

func test_init():
	assert_true(gun != null)

func test_process_counts_seconds_since_last_shot():
	gun.seconds_since_last_shot = 0
	var delta = 500

	gun._process(delta)

	assert_eq(gun.seconds_since_last_shot, delta)

func test_process_calls_shoot_if_input_given_and_not_cooldown():
	Input.action_press('shoot')
	gun.seconds_since_last_shot = 999

	gun._process(0)

	# i.e: shoot was called
	assert_eq(gun.seconds_since_last_shot, 0)

	Input.action_release('shoot')

func test_process_doesnt_call_if_no_input_given():
	var orig_value = 999
	gun.seconds_since_last_shot = orig_value

	gun._process(0)

	assert_eq(gun.seconds_since_last_shot, orig_value)

func test_process_doesnt_call_if_cooldown():
	Input.action_press('shoot')
	gun.seconds_since_last_shot = -1

	gun._process(0)

	assert_eq(gun.seconds_since_last_shot, -1)

	Input.action_release('shoot')

func test_create_bullet_creates_and_prepares_bullet():
	gun.global_position = Vector2()
	gun.bullet_speed = 1500

	var error_margin = 0.05

	var test_table = { # mouse position: velocity after rotation
		Vector2(-194, 17): Vector2(-1494.273804, 130.941422),
		Vector2(-177, -63): Vector2(-1413.154053, -502.986694),
		Vector2(-68, -139): Vector2(-659.163086, -1347.406494),
		Vector2(139, -115): Vector2(1155.7323, -956.181396),
		Vector2(202, 54): Vector2(1449.114014, 387.386658),
		Vector2(84, 175): Vector2(649.096375, 1352.284668),
		Vector2(-138, 151): Vector2(-1011.925415, 1107.251953),
		Vector2(-195, -39): Vector2(-1470.870972, -294.174103),
		Vector2(23, -166): Vector2(205.864639, -1485.806152),
		Vector2(141, -91): Vector2(1260.313599, -813.393921),
		Vector2(157, 185): Vector2(970.575195, 1143.671143),
		Vector2(-62, 237): Vector2(-379.629852, 1451.165527),
		Vector2(-188, 110): Vector2(-1294.668091, 757.518677),
		Vector2(-148, -111): Vector2(-1200.000122, -899.999878),
		Vector2(81, -192): Vector2(583.050598, -1382.046265)
	}

	for mouse_pos in test_table:
		var expected_velocity = test_table[mouse_pos]
		
		var bullet = gun._create_bullet(mouse_pos)
		assert_almost_eq(bullet.velocity.x, expected_velocity.x, error_margin)
		assert_almost_eq(bullet.velocity.y, expected_velocity.y, error_margin)
		assert_eq(bullet.position, gun.global_position)
