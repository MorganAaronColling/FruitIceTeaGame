extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	Game.gui = self

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func update_gui():
	$SoulsCounter.text = 'SOULS: ' + str(Game.souls_count)
	$AmmoCounter.text = 'AMMO: ' + str(Game.ammo_count)
