extends Node
# processes gamerules and holds vital information that other nodes can get

@onready var stopwatch: Node = $stopwatch # keeps level time
@onready var level_manager: Node = $level_manager # contains references to level ids and groupings
####### ^^^ could prlly move this somewhere else

const PLAYER_TSCN = preload("res://scenes/player/player.tscn")

var player_global_position := Vector3.ZERO
var player_spawnpoint : Node3D = null
var player : CharacterBody3D # registered by player script on ready
var has_moved = false # if the character has moved this reset, for starting the timer
var shots_taken = 0 # shots taken since respawn / restart

func _ready():
	Events.establish_spawnpoint.connect(_establish_spawnpoint)
	Events.player_death.connect(_player_fucking_died)
	Events.level_end_reached.connect(_level_end_reached)
	Events.first_movement.connect(_first_player_movement)
	Events.weapon_fired.connect(_count_shots)

func _respawn_player():
	var new_player = PLAYER_TSCN.instantiate()
	player_spawnpoint.add_sibling(new_player)
	new_player.global_position = player_spawnpoint.global_position
	new_player.global_rotation = player_spawnpoint.global_rotation
	stopwatch.reset(); has_moved = false
	shots_taken = 0
	
func _establish_spawnpoint(node):
	if player_spawnpoint != null:
		print_debug("multiple player spawnpoints have been placed!")
	player_spawnpoint = node
	
	await get_tree().process_frame # needed, otherwise player script breaks
	_respawn_player()

func _player_fucking_died(type : Enums.PlayerDeathType): # oogway is fucking dead
	_respawn_player() 

func _first_player_movement():
	has_moved = true
	stopwatch.start()

func _count_shots():
	shots_taken += 1
	Events.ui_shots_taken_update.emit(shots_taken)

func _level_end_reached():
	stopwatch.stop()
