extends Node3D
# creates a muzzle flash effect and light

# needs two children nodes:
# sprite for the flash named "flash sprite"
# a sprite for the lighting effect named "flash light"

@export var scale_variance : float ## variance in the flashes scale, in relation to its own default
@export var flash_lifespan : float ## amount of time (in seconds) a flash will be visible for

@onready var flash_sprite = $flash_sprite
@onready var flash_light = $flash_light

@export var flash_container : Node3D

@onready var trail_timer: Timer = $trail_timer
const SMOKE_SPREAD_EMITTER = preload("res://scenes/Player/smoke_spread.tscn")
const SMOKE_TRAIL_EMITTER = preload("res://scenes/Player/smoke_follow.tscn")
@onready var emitter_position: Node3D = $emitter_position
var trails_left = 0

var sprite_scale_default : Vector3

func _ready(): 
	sprite_scale_default = flash_sprite.scale
	
	flash_sprite.visible = false
	flash_light.visible = false

func flash():
	#look_at(Gamestate.player.head.global_position)

	var scale_random = randf_range(sprite_scale_default.x - scale_variance, sprite_scale_default.x + scale_variance)
	flash_sprite.scale = Vector3(scale_random, scale_random, scale_random)
	flash_sprite.rotation.z = randf_range(0.0, 2 * PI)
	
	flash_sprite.visible = true
	flash_light.visible = true
	
	await get_tree().create_timer(flash_lifespan).timeout
	flash_sprite.visible = false
	flash_light.visible = false
		
	var new_smoke_spread = SMOKE_SPREAD_EMITTER.instantiate()
	get_parent().get_parent().add_sibling(new_smoke_spread)
	new_smoke_spread.global_position = emitter_position.global_position
	new_smoke_spread.global_rotation = emitter_position.global_rotation
	
	# spawn trail particles
	trails_left = 5
	trail_timer.start()


func _on_trail_timer_timeout() -> void:
	var new_smoke_trail = SMOKE_TRAIL_EMITTER.instantiate()
	get_parent().get_parent().add_sibling(new_smoke_trail)
	new_smoke_trail.global_position = emitter_position.global_position
	new_smoke_trail.global_rotation = emitter_position.global_rotation
	new_smoke_trail.process_material.scale_min = 0.16 * trails_left * 1.4
	new_smoke_trail.process_material.scale_max = 0.24 * trails_left * 1.4
	trails_left -= 1
	if trails_left > 0:
		trail_timer.start()
