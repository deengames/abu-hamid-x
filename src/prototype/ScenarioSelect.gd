extends CanvasLayer


func _on_Level1Button_pressed():
	global.current_spawns = {
		preload("res://prototype/Character/Enemy/Enemy.tscn"): 1,
		preload("res://prototype/Character/Enemy/ShooterEnemy.tscn"): 3
	}
	
	global.special_spawns = {
		3: preload("res://prototype/Character/Enemy/Giant/Giant.tscn"),
		global.FINAL_WAVE_NUMBER: preload("res://prototype/Character/Enemy/Giant/Giant.tscn")
	}
	
	get_tree().change_scene('res://prototype/Level1.tscn')

func _on_Level2BUtton_pressed():
	global.current_spawns = {
		preload("res://prototype/Character/Enemy/Enemy.tscn"): 1,
		preload("res://prototype/Character/Enemy/ShooterEnemy.tscn"): 3,
		preload("res://prototype/Character/Enemy/Kamikaze/Kamikaze.tscn"): 2
	}
	
	get_tree().change_scene('res://prototype/Level2.tscn')

func _on_Level3Button_pressed():
	global.current_spawns = {
		preload("res://prototype/Character/Enemy/Enemy.tscn"): 1,
		preload("res://prototype/Character/Enemy/ShooterEnemy.tscn"): 3,
		preload("res://prototype/Character/Enemy/Kamikaze/Kamikaze.tscn"): 2
	}
	
	get_tree().change_scene('res://prototype/Level3.tscn')

func _on_Level4Button_pressed():
	global.current_spawns = {
		preload("res://prototype/Character/Enemy/Enemy.tscn"): 1,
		preload("res://prototype/Character/Enemy/ShooterEnemy.tscn"): 3,
		preload("res://prototype/Character/Enemy/Kamikaze/Kamikaze.tscn"): 2,
		preload("res://prototype/Character/Enemy/Assassin/Assassin.tscn"): 2
	}
	
	get_tree().change_scene('res://prototype/Level4.tscn')
