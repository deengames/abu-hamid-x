extends ProgressBar

func _on_Player_health_change(new_hp, max_hp):
	self.value = new_hp
	self.max_value = max_hp
