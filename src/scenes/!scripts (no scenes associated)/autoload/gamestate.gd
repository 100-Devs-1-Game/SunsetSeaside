extends Node
# processes gamerules and holds vital information that other nodes can get

@onready var stopwatch: Node = $stopwatch # keeps level time
@onready var level_manager: Node = $level_manager # contains references to level ids and groupings
####### ^^^ could prlly move this somewhere else

const PLAYER_TSCN = preload("res://scenes/player/player.tscn")

### player vars
var player_global_position := Vector3.ZERO
var player_spawnpoint : Node3D = null
var player : CharacterBody3D # registered by player script on ready
var has_moved = false # if the character has moved this reset, for starting the timer
var shots_taken = 0 # shots taken since respawn / restart

### level vars
const grouping_ammo_amount = [2, 1, 1, 2, 2]
# grouping order: debug, tutorial, easy, medium, hard

# current values for the level being played
var current_ammo_amount : int = 1 # amount of shots before touching the ground
var current_max_ammo : int = 999
var current_par_limit : int = 999
var current_time_limit : float = 999.0

var current_level_grouping : Enums.LevelGrouping
var current_level_id : int

func _ready():
	Events.establish_spawnpoint.connect(_establish_spawnpoint)
	Events.player_death.connect(_player_fucking_died)
	Events.level_end_reached.connect(_level_end_reached)
	Events.first_movement.connect(_first_player_movement)
	Events.weapon_fired.connect(_count_shots)
	Events.open_level.connect(_setup_level_id)
	Events.establish_level_vars.connect(_setup_level_vars)

func _respawn_player():
	var new_player = PLAYER_TSCN.instantiate()
	player_spawnpoint.add_sibling(new_player)
	new_player.global_position = player_spawnpoint.global_position
	new_player.global_rotation = player_spawnpoint.global_rotation
	stopwatch.reset(); has_moved = false
	shots_taken = 0
	
#### setup functions
func _establish_spawnpoint(node):
	if player_spawnpoint != null:
		print_debug("multiple player spawnpoints have been placed!")
	player_spawnpoint = node
	
	await get_tree().process_frame # needed, otherwise player script breaks
	_respawn_player()

func _setup_level_id(grouping, id):
	current_level_grouping = grouping
	current_level_id = id
	match grouping:
		Enums.LevelGrouping.DEBUG: current_ammo_amount = grouping_ammo_amount[0]
		Enums.LevelGrouping.DAYLIGHT: current_ammo_amount = grouping_ammo_amount[1]
		Enums.LevelGrouping.SUNSET: current_ammo_amount = grouping_ammo_amount[2]
		Enums.LevelGrouping.MIDNIGHT: current_ammo_amount = grouping_ammo_amount[3]
		Enums.LevelGrouping.SUNRISE: current_ammo_amount = grouping_ammo_amount[4]

func _setup_level_vars(max_ammo, par_limit, time_limit):
	current_max_ammo = max_ammo
	current_par_limit = par_limit
	current_par_limit = time_limit
	Events.ui_set_level_vars.emit(max_ammo, par_limit, time_limit)

#### player events
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
	# open end screen and compare values here
