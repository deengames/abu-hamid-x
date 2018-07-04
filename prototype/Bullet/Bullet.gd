extends KinematicBody2D

export (float) var bullet_speed = 1500
export (int) var damage_to_deal = 1

var velocity
var collide_with = "enemies"

func _process(delta):
	collide(move_and_collide(velocity * delta))


func collide(info):
	if info == null:
		return
	if info.collider.is_in_group(self.collide_with):
		# bullets are a pain.
		# for giants, we have to choose between two:
			# damaging giants even outside hitspots
			# not damaging giants even in hitspots
		# I chose the former and called it a feature >:]
		info.collider._on_body_entered(self)
	queue_free()


func init(x, y, angle):
	position.x = x
	position.y = y
	velocity = Vector2(-bullet_speed, 0).rotated(angle)
	
func _on_deal_damage(other):
	queue_free()