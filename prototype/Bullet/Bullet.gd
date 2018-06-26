extends KinematicBody2D

export (float) var bullet_speed = 1500
export (int) var damage_to_deal = 1

var velocity


func _process(delta):
	collide(move_and_collide(velocity * delta))


func collide(info):
	if info == null:
		return
	queue_free()


func init(x, y, angle):
	position.x = x
	position.y = y
	velocity = Vector2(-bullet_speed, 0).rotated(angle)
	
