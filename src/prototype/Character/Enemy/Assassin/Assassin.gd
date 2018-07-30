extends "../Enemy.gd"

export (float) var lunge_attack_range = 250
export (float) var lunge_attack_force = 2000
export (float) var seconds_visible = 3

onready var appear_tween = $AppearTween
onready var disappear_tween = $DisappearTween

func _ready():
	$VisibleTimer.wait_time = seconds_visible

func _integrate_forces(state):
	if player.position.distance_to(position) > lunge_attack_range:
		._integrate_forces(state)
	else:
		var angle_to_player = player.position.angle_to(position)
		var lunge_vector = Vector2(0, lunge_attack_force).rotated(angle_to_player)
		appear_tween.interpolate_property($ColorBox.color, "a", 0.07, 1, 0.5, Tween.TRANS_LINEAR)
		apply_impulse(Vector2(0, 0), lunge_vector)

func _on_AppearTween_tween_completed(object, key):
	$VisibleTimer.start()

func _on_VisibleTimer_timeout():
	disappear_tween.interpolate_property($ColorBox.color, "a", 1, 0.07, 1.5, Tween.TRANS_LINEAR)
