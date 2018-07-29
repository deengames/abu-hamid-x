extends "Lava.gd"

export (float) var movement_speed = 400

signal relocate(thing)

onready var velocity = Vector2(0, movement_speed)

func _ready():
	var notifier = $VisibilityNotifier2D
	while notifier.is_on_screen():
		emit_signal("relocate", self)

func _physics_process(delta):
	position += velocity * delta
