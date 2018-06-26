extends CanvasLayer


func _on_NewGameButton_pressed():
	get_tree().change_scene('res://prototype/Main.tscn')


func _on_InstructionsButton_pressed():
	get_tree().change_scene('res://prototype/Instructions.tscn')
