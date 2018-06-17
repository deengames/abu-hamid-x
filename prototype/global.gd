extends Node

export (Dictionary) var config = {}

func _ready():
	var file = File.new()
	file.open("res://prototype/config.json", file.READ)
	var text = file.get_as_text()
	file.close()
	
	config = JSON.parse(text).result
	print("Global config loaded")
	print(config)