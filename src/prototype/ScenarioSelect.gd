extends CanvasLayer

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Button_pressed():
	
	global.current_spawns = {
		preload("res://prototype/Character/Enemy/Enemy.tscn"): 1,
		preload("res://prototype/Character/Enemy/ShooterEnemy.tscn"): 3
	}
	
	global.special_spawns = {
		3: preload("res://prototype/Character/Enemy/Giant/Giant.tscn"),
		global.FINAL_WAVE_NUMBER: preload("res://prototype/Character/Enemy/Giant/Giant.tscn")
	}
	
	get_tree().change_scene('res://prototype/Main.tscn')
