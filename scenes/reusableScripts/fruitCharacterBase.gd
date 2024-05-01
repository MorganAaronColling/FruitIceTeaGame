extends CharacterBody2D

func _physics_process(delta):
	var direction = Input.get_axis('left', 'right')
	if direction:
		$AnimationPlayer.play('walk')
	else:
		$AnimationPlayer.play('idle')
	velocity.x = direction * 200
	set_facing_direction()
	move_and_slide()
	
func set_facing_direction():
	if velocity.x < -10:
		$Sprite2D.flip_h = true
	elif velocity.x > 10:
		$Sprite2D.flip_h = false
	
