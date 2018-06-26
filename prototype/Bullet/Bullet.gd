extends KinematicBody2D

export (float) var bullet_speed = 1500
export (int) var damage_to_deal = 1

var velocity


func _process(delta):
	collide(move_and_collide(velocity * delta))


func collide(info):
	if info == null:
		return
	# immediately free in not hitting enemy
	# otherwise, let it call _on_deal_damage
	# once it registers damage
	if not info.collider.is_in_group('enemies'):
		queue_free()
	if info.collider.is_in_group('giants'):
		queue_free()


func init(x, y, angle):
	position.x = x
	position.y = y
	velocity = Vector2(-bullet_speed, 0).rotated(angle)
	
func _on_deal_damage(other):
	queue_free()