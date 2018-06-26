extends CanvasLayer

var instructions = [
	"""Finally decided to do some reading, eh? Alrighty, listen up. I'm going to tell you how this pile of bugs works.

You move with the `wasd` keys and jump with space.

Left click and you'll swing your sword in the general direction of your mouse.

Press ctrl and you'll activate your jetpack, which allows you to fly. It runs on fuel. Luckily, it recharges quite fast when you're not using it, so go nuts.

Slow down and you'll float gently down while drastically reducing your fuel usage.""",
	"""Hold shift while flying and you'll activate boost mode, which increases your speed in exchange for higher fuel usage.

What's the point of speed, you ask? You deal more damage with your sword the faster you go. There are also flying attacks which propel you in the direction you're heading ridiculously fast, provided you're swinging like crazy and crossed the speed threshold.

Right click and you'll shoot a bullet. You have a limited amount of bullets, but enemies drop ammo. Your gun automatically reloads once it's empty, and you can also press R to reload manually.

That's about it for you.""",
	"""As for your enemies, there are a few so far:

- Dumbo follower enemies, which follow the player wherever he is found on the map. They bite.
They're the red half-player-sized squares.

- Giants. They're the huge monsters of pushing-the-player-outside-the-box. As you probably already noticed, you can't hurt them except by attacking their hitspots, which are the little white dots on themselves. They also bite.
They're the crimson red behemoths. You'll recognize them, trust me."""
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
