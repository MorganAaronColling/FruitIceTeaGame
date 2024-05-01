extends CharacterBody2D

#CONSTANT
const ACCELERATION = 900.0
const FRICTION = 7.5
const MAX_DASHES = 1
const DASH_SPEED = 750
const HELL_BLASTER_COOLDOWN = 0.2
const MAX_AMMO = 12

#FLAGS
var moving = false
var dashing = false
var firing = false
var reloading = false

#COUNTS
var dash_count = 1
var ammo_count = MAX_AMMO

func _ready():
	Game.update_ammo_count(ammo_count)
	
func _process(delta):
	if reloading:
		$ReloadProgressBar.value = 100 - (100 * $ReloadCooldown.time_left)

func _input(event):
	if event.is_action_pressed('left_click'):
		if ammo_count > 0 and !reloading:
			fire_weapon()
			$ShotCooldown.start()
		else:
			reload_weapon()
	elif event.is_action_released('left_click'):
		$ShotCooldown.stop()
	elif event.is_action_pressed('reload') and ammo_count < MAX_AMMO:
		reload_weapon()
	if event.is_action_pressed('dash'):
		dash()

func _physics_process(delta: float) -> void:
	apply_traction(delta)
	apply_friction(delta)
	move_and_slide()
	set_facing_direction()
	animation_controller()
	
func apply_traction(delta: float) -> void:
	var traction = Input.get_vector("left","right","up","down")
	if traction != Vector2.ZERO:
		velocity += traction * ACCELERATION * delta
		moving = true
	else:
		moving = false
	
func apply_friction(delta: float) -> void:
	velocity -= velocity * FRICTION * delta
	
func set_facing_direction():
	var mouse_position = get_global_mouse_position()
	if mouse_position.x - global_position.x < 0:
		$AnimatedSprite2D.flip_h = true
		update_weapon_rotation(mouse_position, true)
	elif mouse_position.x - global_position.x > 0:
		$AnimatedSprite2D.flip_h = false
		update_weapon_rotation(mouse_position, false)
		
func animation_controller():
	if dashing:
		$AnimatedSprite2D.play('dash')
	elif moving:
		$AnimatedSprite2D.play('run')
	else:
		$AnimatedSprite2D.play('idle')
		
func dash():
	if dash_count > 0:
		dashing = true
		dash_count -= 1
		$DashCooldown.start()
		velocity = velocity.normalized() * DASH_SPEED
		
func update_weapon_rotation(mouse_position, flipped):
	var point_gun_vector : Vector2 = mouse_position - $GunPivot.global_position
	if flipped:
		$GunPivot.rotation = point_gun_vector.angle()
		$GunPivot.scale.y = -1
	else:
		$GunPivot.rotation = point_gun_vector.angle()
		$GunPivot.scale.y = 1
	#update_weapon_z_index()
		
func update_weapon_z_index():
	if $GunPivot.rotation < 0:
		$GunPivot.show_behind_parent = true
	else: 
		$GunPivot.show_behind_parent = false
		
func fire_weapon():
	if ammo_count > 0 and !reloading:
		ammo_count -= 1
		Game.update_ammo_count(ammo_count)
		var mouse_position = get_global_mouse_position()
		var point_gun_vector : Vector2 = (mouse_position - $GunPivot.global_position).normalized()
		$GunPivot/HellBlaster.fire_bullet(point_gun_vector)
		$GunPivot/HellBlaster.apply_recoil(point_gun_vector)
		$GunPivot/HellBlaster/MuzzleFlash.play('flash')
	else:
		reload_weapon()

func reload_weapon():
	if !reloading:
		reloading = true
		$ReloadCooldown.start()
		$ReloadProgressBar.visible = true
		$ReloadProgressBar.value = 0
	
func _on_dash_cooldown_timeout():
	dash_count += 1

func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == 'dash':
		dashing = false

func _on_shot_cooldown_timeout():
	fire_weapon()

func _on_reload_cooldown_timeout():
	$ReloadProgressBar.visible = false
	reloading = false
	ammo_count = MAX_AMMO
	Game.update_ammo_count(ammo_count)
