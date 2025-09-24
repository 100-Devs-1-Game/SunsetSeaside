extends Camera3D

@onready var fps_rig = $fps_rig

func _process(delta):
	fps_rig.position.x = lerp(fps_rig.position.x , 0.0 , delta * 5)
	fps_rig.position.y = lerp(fps_rig.position.y , 0.0 , delta * 5)

func sway(sway_amount):
	fps_rig.position.x -= sway_amount.x * 0.00002
	fps_rig.position.y += sway_amount.y * 0.00002
