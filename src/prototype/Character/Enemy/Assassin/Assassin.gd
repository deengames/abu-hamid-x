extends "../Enemy.gd"

export (float) var lunge_attack_range = 200
export (float) var lunge_attack_force = 2000
export (float) var lunge_cool_down = 2

var seconds_since_last_lunge = 999

func _integrate_forces(state):
	seconds_since_last_lunge += state.step
	if player.position.distance_to(position) < lunge_attack_range and seconds_since_last_lunge > lunge_cool_down:
		seconds_since_last_lunge = 0
		var angle_to_player = player.position.angle_to_point(position) + PI/2
		var lunge_vector = Vector2(0, -lunge_attack_force).rotated(angle_to_player)
		apply_impulse(Vector2(0, 0), lunge_vector)
	else:
		._integrate_forces(state)
