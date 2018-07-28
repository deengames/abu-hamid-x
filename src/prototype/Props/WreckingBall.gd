extends StaticBody2D

export (float) var swing_extent_in_radian = PI/3
export (float) var seconds_per_full_swing = 1.5

onready var tween = $Tween
onready var swinger = $SwingingSegment

enum DIRECTION {LEFT, RIGHT}
var swing_direction = DIRECTION.LEFT

func _ready():
	swinger.rotation = swing_extent_in_radian
	_start_swing()

func _start_swing():
	if swing_direction == DIRECTION.LEFT:
		tween.interpolate_property(swinger, "rotation", 
			swing_extent_in_radian, -swing_extent_in_radian,
			seconds_per_full_swing, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT
		)
		tween.start()
		swing_direction = DIRECTION.RIGHT
	elif swing_direction == DIRECTION.RIGHT:
		tween.interpolate_property(swinger, "rotation", 
				-swing_extent_in_radian, swing_extent_in_radian,
				seconds_per_full_swing, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT
			)
		tween.start()
		swing_direction = DIRECTION.LEFT

func _on_finish_swing(object, key):
	_start_swing()
