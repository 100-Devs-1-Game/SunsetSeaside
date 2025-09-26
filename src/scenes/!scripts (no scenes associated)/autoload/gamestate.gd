extends Node
# processes gamerules and holds vital information that other nodes can get

const PLAYER_TSCN = preload("res://scenes/player/player.tscn")

var player_global_position := Vector3.ZERO
var player_spawnpoint : Node3D = null
var player : CharacterBody3D # registered by player script on ready

func _ready():
	Events.establish_spawnpoint.connect(_establish_spawnpoint)
	Events.player_death.connect(_player_fucking_died)

func _respawn_player():
	var new_player = PLAYER_TSCN.instantiate()
	player_spawnpoint.add_sibling(new_player)
	new_player.global_position = player_spawnpoint.global_position
	new_player.global_rotation = player_spawnpoint.global_rotation
	
func _establish_spawnpoint(node):
	if player_spawnpoint != null:
		print_debug("multiple player spawnpoints have been placed!")
	player_spawnpoint = node
	
	await get_tree().process_frame # needed, otherwise player script breaks
	_respawn_player()

func _player_fucking_died(type : Enums.PlayerDeathType):
	_respawn_player()
