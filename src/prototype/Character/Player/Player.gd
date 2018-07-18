extends "../Character.gd"

export (int) var max_movement_speed = 800
export (int) var acceleration = 2000
export (float) var float_down_speed = 50

export (bool) var allow_jetpack = true
export (int) var max_jetpack_fuel = 500
export (int) var jetpack_consumption_rate = 25
export (int) var jetpack_recharge_rate = 200

export (float) var health_regen_per_second = 0.5
export (float) var flying_impulse_velocity = 4500
export (float) var flying_attack_min_velocity = 600
export (float) var flying_attack_cooldown = 1.5

signal fuel_change(new_fuel, max_fuel)
signal health_change(new_hp, max_hp)
signal shoot_bullet(bullet)
signal num_bullet_change(new_clip, new_outside)

var is_using_jetpack = false
onready var fuel = max_jetpack_fuel

var is_dead = false
var seconds_since_last_flying_attack = 999

onready var movement_component = preload('res://prototype/Character/Player/Movement.gd').new(self)
onready var sword = preload('res://prototype/Sword.tscn').instance()
onready var gun = $Gun

func pickup_bullets(bullets_to_pickup):
	gun.pickup_bullets(bullets_to_pickup)
	
func _free():
	$ui/DeathLabel.visible = true
	visible = false
	is_dead = true

func _ready():
	sword.connect('finish_swing', self, '_on_sword_finish_swing')

	register_damaging_group('enemies')
	register_damaging_group('enemybullet')

	if health_regen_per_second == 0:
		$HealthRegenTimer.autostart = false
	else:
		$HealthRegenTimer.wait_time = 1/health_regen_per_second


func _process(delta):
	if is_dead:
		return

	seconds_since_last_flying_attack += delta
	
	if global.config.enable_sword == true and Input.is_action_just_pressed('attack'):
		add_child(sword)
		var starting_angle = get_angle_to(get_global_mouse_position())
		var target_angle = starting_angle + PI
		sword.rotation = starting_angle
		sword.swing_to(target_angle)
		
		if (global.config.flying_attacks == true 
			and is_using_jetpack 
			and linear_velocity.length() > flying_attack_min_velocity 
			and (Input.is_action_pressed('boost') or global.config.enable_boost == false)
			and seconds_since_last_flying_attack > flying_attack_cooldown):
				seconds_since_last_flying_attack = 0
				self.apply_impulse(
					Vector2(0, 0), 
					Vector2(flying_impulse_velocity, 0).rotated(linear_velocity.angle())
				)


func _on_sword_finish_swing():
	remove_child(sword)


func _integrate_forces(state):
	if is_dead:
		return
	
	movement_component._integrate_forces(state)
	
	if Input.is_action_just_pressed('jump') and not is_using_jetpack:
		self.apply_impulse(Vector2(0, 0), Vector2(0, -1500))
	
	# Vy is never zero. But often it's like 0.0019 or -0.0002.
	# > 0.01 means we're for sure in the air.
	if abs(state.get_linear_velocity().y) > 0.01 and Input.is_action_just_pressed('jump') and allow_jetpack and not is_using_jetpack:
		is_using_jetpack = true
		gravity_scale = 0
	
	if Input.is_action_just_pressed('toggle_jetpack') and allow_jetpack:
		is_using_jetpack = not is_using_jetpack
		gravity_scale = 0 if is_using_jetpack else 2
	
	if not is_using_jetpack:
		if fuel < max_jetpack_fuel:
			fuel += jetpack_recharge_rate * state.step
	fuel = clamp(fuel, 0, max_jetpack_fuel + 1)

	var lost_fuel = jetpack_consumption_rate * state.step

	if global.config.enable_float_down and is_using_jetpack and state.get_linear_velocity().abs().length() < 20:
		lost_fuel /= 6
		state.set_linear_velocity(Vector2(0, float_down_speed))
	
	if is_using_jetpack and (
		Input.is_action_pressed('move_left') 
		or Input.is_action_pressed('move_right')
		or Input.is_action_pressed('move_up')
		or Input.is_action_pressed('move_down')
		):
		lost_fuel *= 2
		if Input.is_action_pressed('boost'):
			lost_fuel *= 2
	
	fuel -= lost_fuel
	if fuel <= 0:
		self._disable_jetpack()
	
	sword.update_damage(state.get_linear_velocity())
	
	emit_signal('fuel_change', fuel, max_jetpack_fuel)
	emit_signal('health_change', health, max_health)

func _unhandled_input(event):
	# ignore motion and mousedowns
	if (event is InputEventMouseMotion 
		or (event is InputEventMouseButton 
			and event.pressed
			)):
		return
	if is_dead:
		if event is InputEventKey and event.scancode == KEY_ESCAPE:
			get_tree().change_scene('res://prototype/MainMenu.tscn')
		else:
			get_tree().change_scene('res://prototype/Main.tscn')

	
func _on_body_entered(body):
	._on_body_entered(body)
	
	if self.is_using_jetpack and body.is_in_group("floor"):
		self._disable_jetpack()

func _on_health_regen():
	if is_dead:
		return
	
	if health < max_health:
		health += 1
		
func _disable_jetpack():
	self.is_using_jetpack = false
	self.gravity_scale = 2

func _on_Gun_shoot_bullet(bullet):
	emit_signal('shoot_bullet', bullet)

func _on_Gun_num_bullet_change(new_clip, new_outside):
	emit_signal("num_bullet_change", new_clip, new_outside)
