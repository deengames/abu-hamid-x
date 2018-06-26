extends Label


func _on_Player_num_bullet_change(new_clip, new_outside):
	text = "AMMO: " + str(new_clip) + " / " + str(new_outside)
