extends Area2D

### ABSTRACT CLASS. DO NOT INSTANTIATE.

export (float) var bullet_speed = 1500
export (int) var damage_to_deal = 1

var velocity
var damageable_group

func _physics_process(delta):
	position += velocity * delta

func on_collision(body):
	if body.is_in_group(damageable_group):
		body.damage_with(self, damage_to_deal)
	queue_free()

func init(damageable_group_, x, y, angle):
	damageable_group = damageable_group_
	position.x = x
	position.y = y
	velocity = Vector2(-bullet_speed, 0).rotated(angle)
