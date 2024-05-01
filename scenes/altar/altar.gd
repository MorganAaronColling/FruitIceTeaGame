extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_sacrifice_area_body_entered(body):
	if body.is_in_group('player'):
		toggle_sacrifice_action(true)
		
		
func _on_sacrifice_area_body_exited(body):
	if body.is_in_group('player'):
		toggle_sacrifice_action(false)
		
		
func toggle_sacrifice_action(value):
	if value:
		$Altarfloor.modulate = Color(1.2, 1.2, 1.2)
	else:
		$Altarfloor.modulate = Color(1, 1, 1)
		
func _input(event):
	if event.is_action("interaction"):
		if Game.souls_count > 0:
			Game.update_souls_count(-1)
