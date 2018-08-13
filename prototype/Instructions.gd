extends CanvasLayer

var instructions = [
	"""Finally decided to do some reading, eh? Alrighty, listen up. I'm going to tell you how this pile of bugs works.

You move with the `wasd` keys and jump with space or up.

Left click and you'll swing your sword in the general direction of your mouse.

Press ctrl or double-jump and you'll activate your jetpack, which allows you to fly. It runs on fuel. It recharges quite fast when you're not using it, so go nuts.

Slow down and you'll float gently down while drastically reducing your fuel usage. Touching the floor automatically deactivates your jetpack.

Right click and you'll shoot a bullet. You have a limited amount of bullets, but enemies drop ammo. Your gun automatically reloads once it's empty, and you can also press R to reload manually.

That's about it for you.""",
	"""As for your enemies, there are a few so far:

- Dumbo follower enemies, which follow the player wherever he is found on the map. They bite. They're the red half-player-sized squares.

- Giants. They're the crimson towering armoured monsters. You can sword-attack their hitspots, which are the little white dots on themselves, or you can shoot them to death. They also bite.

- Shooters. They shoot bullets at you. Be prepared to dodge and weave.
"""
]
var current_instruction = 0

func _set_labels():
	$IndicatorLabel.text = str(current_instruction + 1) + '/' + str(instructions.size())
	$InstructionsLabel.text = instructions[current_instruction]

func _ready():
	_set_labels()

func _unhandled_input(event):
	# ignore motion and mousedowns
	if (event is InputEventMouseMotion 
		or (event is InputEventMouseButton 
			and event.pressed
			)):
		return
	if current_instruction < instructions.size() - 1:
		current_instruction += 1
		_set_labels()
	else:
		get_tree().change_scene('res://prototype/MainMenu.tscn')
