extends "../Character.gd"


func _on_body_entered(body):
	if body.is_in_group('sword'):
		_damage(body.damage_to_deal)
