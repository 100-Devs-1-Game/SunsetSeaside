extends Node3D

@onready var muzzle: Node3D = $mesh_mover/mesh/muzzle
@onready var mesh_mover: Node3D = $mesh_mover
@onready var cannon_decal_ray: RayCast3D = $cannon_decal_ray # creates decals on firing
@onready var shot_delay_timer: Timer = $shot_delay_timer
@onready var cannon_damager: Node3D = $cannon_damager

# recoil vars
var recoil_dynamic = Vector2(0.02, 0.24)## NOTE: first val for this is a random range
var recoil_instant = Vector2(0.0, 0.1)
var camera_shake : float = 0.1
var bounce_force = 12.0
var cycle_delay = 0.1

var cycled = true
var fired_this_frame = false

var ammo = 2
var max_ammo = 2

func _ready():
	Events.floor_reload.connect(_floor_reload)
	Events.fire_weapon.connect(_blaow)
	shot_delay_timer.wait_time = cycle_delay
	Events.ui_ammo_update.emit(ammo)

func _process(_delta):
	fired_this_frame = false

func _blaow():
	if cycled == false: return
	if ammo <= 0 : return
	
	Events.shotgun_bounce.emit(global_basis.z, bounce_force) # affect player movement
	Events.head_recoil_affect.emit(Vector2(randf_range(-recoil_dynamic.x, recoil_dynamic.x), recoil_dynamic.y), recoil_instant, camera_shake)
	muzzle.flash()
	mesh_mover.recoil()
	cannon_decal_ray.create_decal()
	shot_delay_timer.start()
	cannon_damager.damage()
	ammo -= 1
	Events.ui_ammo_update.emit(ammo)
	Events.weapon_fired.emit()
	
	fired_this_frame = true
	cycled = false

func _floor_reload():
	if fired_this_frame: return
	if ammo != max_ammo:
		ammo = max_ammo
		Events.ui_ammo_update.emit(ammo)
		
func _on_shot_delay_timer_timeout() -> void:
	cycled = true
	shot_delay_timer.wait_time = cycle_delay
