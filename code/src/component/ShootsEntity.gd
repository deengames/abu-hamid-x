extends Node2D

signal bullet_shot(bullet)

export (float) var bullet_speed = 1500
export (float) var bullets_per_second = 3.0

onready var bullet_prototype = $PrototypeBullet
var entity

# DRY with gun

func init(entity_):
	entity = entity_

func _ready():
	remove_child(bullet_prototype)

var seconds_since_last_shot = 999

func _create_bullet(mouse_pos):
	var bullet = bullet_prototype.duplicate()
	
	# minus PI/2 for correction: needed because 
	# angle_to_point gets angle relative to `x` axis
	# while rotation is relative to `y` axis
	# that is, if rotation == 0, object points towards -y
	var shoot_angle = global_position.angle_to_point(mouse_pos) - PI/2
	
	bullet.init(bullet_speed, shoot_angle, global_position)
	return bullet

func shoot():
	var bullet = _create_bullet(entity.position)
	emit_signal("bullet_shot", bullet)
	get_tree().current_scene.add_child(bullet)

func _process(delta):
	seconds_since_last_shot += delta
	
	if seconds_since_last_shot > 1/bullets_per_second:
		seconds_since_last_shot = 0
		shoot()
