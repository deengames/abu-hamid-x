extends StaticBody2D

export (int) var damage = 2
export (float) var seconds_per_oscillation = 2
export (Color) var disabled_color = Color("8f8484")

onready var damage_to_deal = damage
onready var enabled_color = $ColorRect.color
var seconds_since_switch = 0

enum MODE {ON, OFF}
var current_mode = MODE.ON

func _process(delta):
	seconds_since_switch += delta
	
	if seconds_since_switch > seconds_per_oscillation and current_mode == MODE.ON:
		damage_to_deal = 0
		current_mode = MODE.OFF
		seconds_since_switch = 0
		for rect in get_children():
			if rect.name.begins_with("ColorRect"):
				rect.color = disabled_color
	
	if seconds_since_switch > seconds_per_oscillation and current_mode == MODE.OFF:
		damage_to_deal = damage
		current_mode = MODE.ON
		seconds_since_switch = 0
		for rect in get_children():
			if rect.name.begins_with("ColorRect"):
				rect.color = enabled_color
