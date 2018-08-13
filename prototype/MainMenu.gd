extends CanvasLayer

func _on_NewGameButton_pressed():
	randomize()
	get_tree().change_scene('res://prototype/ScenarioSelect.tscn')


func _on_InstructionsButton_pressed():
	get_tree().change_scene('res://prototype/Instructions.tscn')
