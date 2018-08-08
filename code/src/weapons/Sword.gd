extends KinematicBody2D

export (float) var swing_angle_degrees = 90
export (float) var seconds_per_swing = 0.2

enum DIRECTION {RIGHT, LEFT}

onready var tween = $Tween
var is_swinging = false


func _ready():
	_toggle(false)


func _process(delta):
	if Input.is_action_just_pressed("attack"):
		swing()


func _get_swing_direction():
	return DIRECTION.LEFT if get_local_mouse_position().x < 0 else DIRECTION.RIGHT

func swing():
	if not is_swinging:
		is_swinging = true
		
		# minus PI/2 for correction
		# there's probably a non-correction-needy way to do it
		# but nothing else I've tried works, soooo
		var angle_to_mouse = get_parent().position.angle_to_point(get_global_mouse_position()) - PI/2
		
		var swing_range
		if _get_swing_direction() == DIRECTION.LEFT:
			swing_range = deg2rad(swing_angle_degrees)
		else:
			swing_range = -deg2rad(swing_angle_degrees)
		
		var starting_angle = angle_to_mouse - swing_range
		var ending_angle = angle_to_mouse + swing_range
		
		tween.interpolate_property(
				self, 'rotation', starting_angle, ending_angle,
				seconds_per_swing, Tween.TRANS_LINEAR, Tween.EASE_IN)
		tween.start()


func _toggle(value):
	is_swinging = value
	visible = value
	$CollisionShape2D.disabled = not value


func _on_Tween_tween_completed(object, key):
	_toggle(false)

func _on_Tween_tween_started(object, key):
	_toggle(true)
