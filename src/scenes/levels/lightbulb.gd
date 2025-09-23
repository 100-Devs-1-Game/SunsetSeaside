extends OmniLight3D


@onready var orig_range = omni_range

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Gamestate.light_val > randf_range(0.0, 1.0):
		omni_range = orig_range
	else :
		omni_range = 0.0
