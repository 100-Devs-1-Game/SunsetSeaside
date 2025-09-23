extends Node
# the director is responsible for not only the current state of the enemy
# but also how and in what regard it currently functions

@onready var search_timer = $search_timer
@onready var bamboozle_timer = $bamboozle_timer
@onready var cooldown_timer = $cooldown_timer


@onready var audio_stream_player = $AudioStreamPlayer

# info vars
var searching_possible = true
var bamboozle_possible = true

var cooldown_min = 15.0 # in seconds
var cooldown_max = 30.0 # in seconds

# operative vars
var searching = false
var bamboozling = false
var search_time = 15.0
var bamboozle_time = 8.0

var bamboozle_chance = 33 # %

# Called when the node enters the scene tree for the first time.
func _ready():
	cooldown_timer.wait_time = 5.0
	cooldown_timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if searching == true:
		if Gamestate.light_val > 0:
			Gamestate.light_val -= ((search_timer.wait_time - search_timer.time_left) / 20) * delta
#			print(Gamestate.light_val)
	elif bamboozling == true: 
		if Gamestate.light_val > 0.1:
			Gamestate.light_val -= ((bamboozle_timer.wait_time - bamboozle_timer.time_left) / 20) * delta
#			print(Gamestate.light_val)
	else:
		if Gamestate.light_val < 1:
			Gamestate.light_val += 0.2 * delta
#			print(Gamestate.light_val)
	
func _on_cooldown_timer_timeout():
	print("cooldown over")
	if searching_possible:
		if bamboozle_possible:
			print("bruh")
			if randi_range(1, 100) <= bamboozle_chance:
				print("seh")
				bamboozling = true
				bamboozle_timer.wait_time = bamboozle_time
				bamboozle_timer.start()
				
				audio_stream_player.stream = preload("res://sounds/demon/background3.wav")
				audio_stream_player.play()
				
				return
		
		searching = true
		Gamestate.searching = true
		
		search_timer.wait_time = search_time
		search_timer.start()
		audio_stream_player.stream = preload("res://sounds/demon/whistle_long3_Pstretch_x2.wav")
		audio_stream_player.play()

func _on_search_timer_timeout():
	print("search over")
	searching = false
	Gamestate.searching = false
	
	cooldown_timer.wait_time = randf_range(cooldown_min, cooldown_max)
	cooldown_timer.start()

func _on_bamboozle_timer_timeout():
	print("bamboozle over")
	bamboozling = false

	cooldown_timer.wait_time = randf_range(cooldown_min, cooldown_max)
	cooldown_timer.start()
