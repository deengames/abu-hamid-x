extends "../Character.gd"

export (int) var max_movement_speed = 800
export (int) var acceleration = 2000
export (float) var float_down_speed = 50
export (bool) var allow_jetpack = true

export (int) var max_jetpack_fuel = 500
export (int) var jetpack_consumption_rate = 25
export (int) var jetpack_recharge_rate = 200

export (float) var health_regen_per_second = 0.5
export (int) var num_attacks_to_fly = 3
export (float) var flying_impulse_velocity = 4500
export (float) var flying_attack_min_velocity = 600
export (float) var flying_attack_cooldown = 1.5

export (int) var clip_size = 6
export (float) var seconds_to_reload = 1.5
export (int) var starting_bullets = 30

export (float) var bullets_per_second = 3.0

signal fuel_change(new_fuel, max_fuel)
signal health_change(new_hp, max_hp)
signal shoot_bullet(bullet)
signal num_bullet_change(new_clip, new_outside)

var is_using_jetpack = false
onready var fuel = max_jetpack_fuel
var is_dead = false

var seconds_since_last_flying_attack = 999
var seconds_since_last_gunfire = 999

var bullet_cls = preload('res://prototype/Bullet/PlayerBullet.tscn')
onready var bullets_outside_clip = starting_bullets - clip_size
onready var bullets_in_clip = clip_size
var reloading = false

onready var reload_timer = $ReloadTimer  # cache for faster use

onready var sword = preload('res://prototype/Sword.tscn').instance()


func pickup_bullets(bullets_to_pickup):
	bullets_outside_clip += bullets_to_pickup
	


func _reload_gun():
	reloading = true
	reload_timer.start()


func _on_finish_reload():
	var bullets_to_fill_clip = clip_size - bullets_in_clip
	var bullets_to_reload
	
	if bullets_to_fill_clip > bullets_outside_clip:
		bullets_to_reload = bullets_outside_clip
	else:
		bullets_to_reload = bullets_to_fill_clip
	
	bullets_in_clip += bullets_to_reload
	bullets_outside_clip -= bullets_to_reload
	reloading = false


func _free():
	$ui/DeathLabel.visible = true
	visible = false
	is_dead = true


func _ready():	
	sword.connect('finish_swing', self, '_on_sword_finish_swing')
	register_damaging_group('enemies')
	register_damaging_group('enemybullet')
	var width = ProjectSettings.get_setting('display/window/size/width')
	var height = ProjectSettings.get_setting('display/window/size/height')
	$ui/DeathLabel.rect_position = (Vector2(width, height) - $ui/DeathLabel.rect_size) / 2
	if health_regen_per_second == 0:
		$HealthRegenTimer.autostart = false
	else:
		$HealthRegenTimer.wait_time = 1/health_regen_per_second
	reload_timer.wait_time = seconds_to_reload


func _process(delta):
	if is_dead:
		return
	
	seconds_since_last_flying_attack += delta
	seconds_since_last_gunfire += delta

	if (global.config.enable_gun == true 
		and Input.is_action_pressed('shoot') 
		and seconds_since_last_gunfire > 1/bullets_per_second 
		and not reloading
		and bullets_in_clip > 0):

			bullets_in_clip -= 1
			seconds_since_last_gunfire = 0

			var angle = global_position.angle_to_point(get_global_mouse_position())
			var bullet = bullet_cls.instance()
			bullet.init(position.x, position.y, angle)
			emit_signal("shoot_bullet", bullet)
			if bullets_in_clip == 0:
				_reload_gun()
		
	if global.config.enable_gun == true and Input.is_action_just_pressed('reload') and not reloading:
		_reload_gun()
	
	if global.config.enable_sword == true and Input.is_action_just_pressed('attack'):
		add_child(sword)
		var starting_angle = get_angle_to(get_global_mouse_position())
		var target_angle = starting_angle + PI
		sword.rotation = starting_angle
		sword.swing_to(target_angle)
		
		if (global.config.flying_attacks == true 
			and is_using_jetpack 
			and linear_velocity.length() > flying_attack_min_velocity 
			and Input.is_action_pressed('boost')
			and seconds_since_last_flying_attack > flying_attack_cooldown):
				seconds_since_last_flying_attack = 0
				self.apply_impulse(
					Vector2(0, 0), 
					Vector2(flying_impulse_velocity, 0).rotated(linear_velocity.angle())
				)
	
	emit_signal("num_bullet_change", bullets_in_clip, bullets_outside_clip)


func _on_sword_finish_swing():
	remove_child(sword)


func _integrate_forces(state):
	if is_dead:
		return
	
	var velocity = state.get_linear_velocity()
	
	if not is_using_jetpack:
		if fuel < max_jetpack_fuel:
			fuel += jetpack_recharge_rate * state.step
	fuel = clamp(fuel, 0, max_jetpack_fuel + 1)
	
	var gained_velocity = acceleration * state.step
	if Input.is_action_pressed('boost'):
		gained_velocity *= 2
	
	if Input.is_action_pressed('move_left') and velocity.x > -max_movement_speed:
		velocity.x -= gained_velocity
	if Input.is_action_pressed('move_right') and velocity.x < max_movement_speed:
		velocity.x += gained_velocity
	if Input.is_action_just_pressed('toggle_jetpack') and allow_jetpack:
		is_using_jetpack = not is_using_jetpack
		gravity_scale = 0 if is_using_jetpack else 2
	# Vy is never zero. But often it's like 0.0019 or -0.0002.
	# > 0.01 means we're for sure in the air.
	if abs(velocity.y) > 0.01 and Input.is_action_just_pressed('jump') and allow_jetpack and not is_using_jetpack:
		is_using_jetpack = true
		gravity_scale = 0
	
	if is_using_jetpack:
		if Input.is_action_pressed('move_up') and velocity.y > -max_movement_speed:
			velocity.y -= gained_velocity
		if Input.is_action_pressed('move_down') and velocity.y < max_movement_speed:
			velocity.y += gained_velocity
	
		rotate(velocity.x / max_movement_speed)
	
	$Collision.rotation = rotation
	
	var lost_fuel = jetpack_consumption_rate * state.step
	if is_using_jetpack and velocity.abs().length() < 20:
		lost_fuel /= 6
		velocity = Vector2(0, float_down_speed)
	
	velocity = Vector2(lerp(velocity.x, 0, 0.05), lerp(velocity.y, 0, 0.05))
	velocity += state.get_total_gravity() * state.step
	state.set_linear_velocity(velocity)
	
	if Input.is_action_just_pressed('jump') and not is_using_jetpack:
		self.apply_impulse(Vector2(0, 0), Vector2(0, -1500))
	
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
	
	sword.damage_to_deal = sword.damage + velocity.length() / 200
	
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