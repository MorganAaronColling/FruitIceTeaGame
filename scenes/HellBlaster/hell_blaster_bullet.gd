extends Node2D

var BULLET_DIRECTION
var SPEED = 600
var DAMAGE = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position += BULLET_DIRECTION * SPEED * delta
	rotation_degrees += 30

func _on_timer_timeout():
	queue_free()
