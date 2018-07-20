extends Area2D

export (int) var damage = 2

onready var damage_to_deal = damage
onready var anim = $AnimationPlayer
onready var color_rect = $ColorRect
var entities_damaged = []

func swing_towards(angle_to_mouse):
	if not anim.is_playing():
		rotation = angle_to_mouse - PI/2
		anim.play("slash")

func process_overlapper(overlapper):
	if overlapper.is_in_group('sword_damageable') and !overlapper in entities_damaged:
		overlapper.apply_impulse(Vector2(0, 0), Vector2(20000, 0).rotated(rotation))
		overlapper.damage_with(self, damage_to_deal)
		entities_damaged.append(overlapper)

func update_damage(velocity):
	damage_to_deal = damage + velocity.length() / 200

func _on_AnimationPlayer_animation_finished(anim_name):
	monitoring = false
	visible = false

func _on_AnimationPlayer_animation_started(anim_name):
	monitoring = true
	visible = true
	entities_damaged = []
