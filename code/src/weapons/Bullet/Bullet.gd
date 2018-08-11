extends KinematicBody2D

var velocity

func init(speed, angle, pos):
	velocity = Vector2(0, -speed).rotated(angle)
	position = pos

func _physics_process(delta):
	collide(move_and_collide(velocity * delta))

func collide(info):
	if info == null:
		return
	
	queue_free()
