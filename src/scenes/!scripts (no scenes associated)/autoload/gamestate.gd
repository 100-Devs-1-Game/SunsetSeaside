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
var hardcore_enabled = false

### level vars
# current values for the level being played
var current_ammo_amount : int = 1 # amount of shots before touching the ground
var current_max_ammo : int = 999
var current_par_limit : int = 999
var current_time_limit : float = 999.0

var current_level_grouping : Enums.LevelGrouping
var current_level_id : int

var ending_was_reached = false
var jug_grabbed = false 

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
	ending_was_reached = false

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
	current_ammo_amount = level_manager.fetch_ammo_amount(grouping)

func _setup_level_vars(max_ammo, par_limit, time_limit):
	current_max_ammo = max_ammo
	current_par_limit = par_limit
	current_time_limit = time_limit

#### player events
func _player_fucking_died(type : Enums.PlayerDeathType): # oogway is fucking dead
	if hardcore_enabled == true: 
		pass
		_respawn_player() 
	else:
		_respawn_player() 
	
func _first_player_movement():
	has_moved = true
	stopwatch.start()

func _count_shots():
	shots_taken += 1
	Events.ui_shots_taken_update.emit(shots_taken)

func _level_end_reached():
	if ending_was_reached == true: return
	
	# finish calcs
	stopwatch.stop()
	ending_was_reached = true
	
	# get level history
	Keeper.load_records()
	var level_history = Keeper.get_level_history(current_level_grouping, current_level_id)
	
	# send values to results screen
	Events.open_menu.emit(Enums.Menus.RESULTS)
	Events.ui_send_level_history.emit(level_history["time_best"], level_history["par_best"], level_history["jug_history"], level_history["hardcore_history"])
	Events.ui_send_end_results.emit(stopwatch.time, current_time_limit, shots_taken, current_par_limit, null) # replace nulls once these are implemented
										#(time, time_limit, time_best, shots_taken, par_limit, shots_best, jug_grabbed, jug_history)
	# save new progress and completion
	
	# compare and write to records
	var new_time = null; var new_par = null; var new_jug = null; var new_hardcore = null;
	if level_history["time_best"] == null: 
		new_time = snapped(stopwatch.time, 0.00001)
	elif level_history["time_best"] > snapped(stopwatch.time, 0.00001): 
		new_time = snapped(stopwatch.time, 0.00001)
		
	if level_history["par_best"] == null: 
		new_par  = shots_taken
	elif level_history["par_best"] > shots_taken: 
		new_par = shots_taken
		
	if level_history["jug_history"] == false && jug_grabbed == true:
		new_jug = true
		
	if level_history["hardcore_history"] == false && hardcore_enabled == true:
		new_hardcore = true
		
	# if vals are null then nothing is written to the respective slot
	Keeper.write_level_history(current_level_grouping, current_level_id, new_time, new_par, new_jug, new_hardcore)
	Keeper.save_records()
