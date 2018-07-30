extends CanvasLayer


func _on_Button_pressed():
	
	global.current_spawns = {
		preload("res://prototype/Character/Enemy/Enemy.tscn"): 1,
		preload("res://prototype/Character/Enemy/ShooterEnemy.tscn"): 3,
		preload("res://prototype/Character/Enemy/Kamikaze/Kamikaze.tscn"): 2
	}
	
	global.special_spawns = {
		3: preload("res://prototype/Character/Enemy/Giant/Giant.tscn"),
		global.FINAL_WAVE_NUMBER: preload("res://prototype/Character/Enemy/Giant/Giant.tscn")
	}
	
	get_tree().change_scene('res://prototype/Main.tscn')


func _on_Button2_pressed():
	global.current_spawns = {
		preload("res://prototype/Character/Enemy/Enemy.tscn"): 1,
		preload("res://prototype/Character/Enemy/ShooterEnemy.tscn"): 3,
		preload("res://prototype/Character/Enemy/Kamikaze/Kamikaze.tscn"): 2,
		preload("res://prototype/Character/Enemy/Assassin/Assassin.tscn"): 2
	}
	
	get_tree().change_scene('res://prototype/Scenario2.tscn')
