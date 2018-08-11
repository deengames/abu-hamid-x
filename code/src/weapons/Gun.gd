extends Node2D

signal bullet_shot(bullet)

export (float) var bullet_speed = 1500
export (float) var bullets_per_second = 3.0

var bullet_cls = preload("res://src/weapons/Bullet/Bullet.tscn")

var seconds_since_last_shot = 999

func _create_bullet(mouse_pos):
	var bullet = bullet_cls.instance()
	
	# minus PI/2 for correction
	var shoot_angle = global_position.angle_to_point(mouse_pos) - PI/2
	
	bullet.init(bullet_speed, shoot_angle, global_position)
	return bullet

func shoot():
	var bullet = _create_bullet(get_global_mouse_position())
	emit_signal("bullet_shot", bullet)
	get_tree().current_scene.add_child(bullet)

func _process(delta):
	seconds_since_last_shot += delta
	
	if Input.is_action_pressed('shoot') and seconds_since_last_shot > 1/bullets_per_second:
		seconds_since_last_shot = 0
		shoot()
