extends Node2D

@export var bullet : PackedScene
var original_position

# Called when the node enters the scene tree for the first time.
func _ready():
	original_position = position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if position != original_position:
		var position_difference = position - original_position
		position -= position_difference / 2
	
func apply_recoil(recoil_direction):
	position -= recoil_direction * 10
	
func fire_bullet(bullet_direction):
	var b = bullet.instantiate()
	b.BULLET_DIRECTION = bullet_direction
	b.global_position = $BulletSpawnPoint.global_position
	get_parent().get_parent().get_parent().add_child(b)
	
func _on_muzzle_flash_animation_finished():
	if $MuzzleFlash.animation == 'flash':
		$MuzzleFlash.play('blank')
