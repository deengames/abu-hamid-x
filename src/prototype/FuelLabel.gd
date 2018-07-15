extends Label


func _on_Player_fuel_change(new_fuel, max_fuel):
	text = 'FUEL: ' + str(int(new_fuel)) + ' / ' + str(max_fuel)
