extends Node2D

export (float) var movement_speed = 1000

var entity

onready var parent = get_parent()

func init(entity_):
	entity = entity_


func _physics_process(delta):
	parent.velocity += Vector2(-movement_speed, 0).rotated(position.angle_to_point(entity.position))
	parent.velocity = Vector2(lerp(parent.velocity.x, 0, 0.05), lerp(parent.velocity.y, 0, 0.05))
