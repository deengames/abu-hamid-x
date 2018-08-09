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


func _get_swing_direction(mouse_pos):
	return DIRECTION.LEFT if global_position.x > mouse_pos.x else DIRECTION.RIGHT

func _process_swing(mouse_pos):
	# minus PI/2 for correction: needed because 
	# angle_to_point gets angle relative to `x` axis
	# while rotation is relative to `y` axis
	# that is, if rotation == 0, object points towards -y
	var angle_to_mouse = global_position.angle_to_point(mouse_pos) - PI/2
	
	var swing_range
	if _get_swing_direction(mouse_pos) == DIRECTION.LEFT:
		swing_range = deg2rad(swing_angle_degrees)
	else:
		swing_range = -deg2rad(swing_angle_degrees)
	
	var starting_angle = angle_to_mouse - swing_range
	var ending_angle = angle_to_mouse + swing_range
	
	return {start=starting_angle, end=ending_angle}

func swing():
	if not is_swinging:
		is_swinging = true
	
		var m = get_global_mouse_position()
		var swing_angle = _process_swing(m)
		
		tween.interpolate_property(
				self, 'rotation', swing_angle.start, swing_angle.end,
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
