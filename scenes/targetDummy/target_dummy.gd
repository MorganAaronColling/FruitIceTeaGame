extends Node2D

var MAX_HEALTH = 10
var health = MAX_HEALTH

var dead = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_target_area_area_entered(area):
	if area.is_in_group('player_bullet'):
		receive_damage(area)

func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == 'hurt':
		$AnimatedSprite2D.play('idle')

func receive_damage(area):
	Game.update_souls_count(1)
	area.get_parent().queue_free()
	$AnimatedSprite2D.play('hurt')
	health -= area.get_parent().DAMAGE
	if health < 1 and !dead:
		dead = true
		$AnimatedSprite2D.play('death')
		$TargetArea.queue_free()
	
