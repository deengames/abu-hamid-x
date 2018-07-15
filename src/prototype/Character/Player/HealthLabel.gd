extends Label


func _on_Player_health_change(new_hp, max_hp):
	text = 'HP: ' + str(new_hp) + ' / ' + str(max_hp)
