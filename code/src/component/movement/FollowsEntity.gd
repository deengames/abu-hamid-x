extends Node2D

export (float) var movement_speed = 250

var entity

onready var parent = get_parent()

func init(entity_):
	entity = entity_

func _physics_process(delta):
	if parent is KinematicBody2D and parent.is_on_floor():
		var velocity = Vector2(-movement_speed, 0).rotated(global_position.angle_to_point(entity.position))
		parent.velocity = Vector2(lerp(parent.velocity.x, velocity.x, 0.1), lerp(parent.velocity.y, velocity.y, 0.1))
