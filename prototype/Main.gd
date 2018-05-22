extends Node2D


func _ready():
	$CanvasLayer/Label.text = 'FUEL: ' + str(int($Player.fuel)) + ' / ' + str($Player.max_jetpack_fuel)


func _on_Player_fuel_change(new_fuel, max_fuel):
	$CanvasLayer/Label.text = 'FUEL: ' + str(int(new_fuel)) + ' / ' + str(max_fuel)
