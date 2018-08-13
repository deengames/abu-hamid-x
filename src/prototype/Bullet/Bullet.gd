extends Area2D

### ABSTRACT CLASS. DO NOT INSTANTIATE.

export (float) var bullet_speed = 1500
export (int) var damage_to_deal = 1

var velocity
var collider_group

func _physics_process(delta):
	position += velocity * delta

func collide(body):
	if body.is_in_group(self.collider_group):
		body._on_body_entered(self)
	queue_free()

func init(collider_group, x, y, angle):
	self.collider_group = collider_group
	position.x = x
	position.y = y
	velocity = Vector2(-bullet_speed, 0).rotated(angle)
