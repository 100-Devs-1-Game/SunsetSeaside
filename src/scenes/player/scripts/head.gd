extends Node3D

@onready var camera_main: Camera3D = $headbob_pivot/Camera3D
@onready var camera_viewmodel: Camera3D = $headbob_pivot/Camera3D/SubViewportContainer/SubViewport/viewmodel_camera

var camera_shake_fade = 5.0

### calc vars
var recoil_y = 0.0
var recoil_x = 0.0
var camera_shake = 0.0

func _ready():
	Events.add_camera_shake.connect(_add_camera_shake)
	Events.head_recoil_affect.connect(_head_recoil_affect)

func _process(delta):
	
	# head recoil from weapons
	camera_main.rotation.x = lerp(camera_main.rotation.x, recoil_y, delta * 20)
	camera_main.rotation.y = lerp(camera_main.rotation.y, recoil_x, delta * 20)
	recoil_y = lerp(recoil_y, 0.0, delta * 5)
	recoil_x = lerp(recoil_x, 0.0, delta * 5)
	
	# camera shake
	if camera_shake > 0:
		camera_shake = lerpf(camera_shake, 0.0, camera_shake_fade * delta)
		var camera_offset = Vector2(randf_range(-camera_shake, camera_shake),randf_range(-camera_shake, camera_shake))
		camera_main.h_offset = camera_offset.x
		camera_main.v_offset = camera_offset.y
		### this is a work around, maybe find the true solution later? (the division)
		camera_viewmodel.h_offset = -camera_offset.x / 18
		camera_viewmodel.v_offset = -camera_offset.y / 18
		

func _head_recoil_affect(recoil_dynamic, recoil_instant, camera_shake):
	# instant recoil
	camera_main.rotation.x += recoil_instant.y # these are swapped,
	camera_main.rotation.y += recoil_instant.x # vector rotation is fucking stupid
	
	# dynamic recoil
	recoil_x += recoil_dynamic.x
	recoil_y += recoil_dynamic.y
	_add_camera_shake(camera_shake)


func _add_camera_shake(amount):
	#print_debug("shake added: ", amount)
	camera_shake += amount
