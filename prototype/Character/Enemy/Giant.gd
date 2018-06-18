extends "Enemy.gd"

func _ready():
	self.max_health = 30
	self.health = self.max_health
	print("Giant reporting.")
