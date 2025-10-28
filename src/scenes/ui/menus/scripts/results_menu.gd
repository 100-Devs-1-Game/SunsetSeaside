extends Menu

# handles ending menu updates and animations

@export var timer_label : HBoxContainer
@export var label_shots_amount : Label

@export_category("spinners")
@export var spinner_time : SubViewportContainer
@export var spinner_par : SubViewportContainer
@export var spinner_jug : SubViewportContainer

@export var spinner_hardcore : SubViewportContainer
@export var spinner_finished_3 : SubViewportContainer
@export var spinner_complete : SubViewportContainer

@onready var spinners_list = [spinner_time, spinner_par, spinner_jug, spinner_hardcore, spinner_finished_3, spinner_complete]

# calc vars
var spinner_count : int

var previous_time_best
var previous_shots_best
var previous_jug_history
var previous_hardcore_history

var time_limit_made = false
var par_limit_made = false

func on_menu_close():
	Events.close_menu.emit()

func _ready():
	Events.ui_send_end_results.connect(_update_end_results)
	Events.ui_send_level_history.connect(_update_level_history)
	timer_label.time_ticking_finished.connect(_animate_endscreen)
	
	for spinner in spinners_list:
		if spinner != null:
			spinner.offset_position(spinner_count)
			spinner_count += 1

func _update_end_results(time, time_limit, shots_taken, par_limit, jug_grabbed):
	# best and jug related vars are currently null
	
	# label setups
	timer_label.time = time
	label_shots_amount.text = str(shots_taken)
	
	if time < time_limit:
		time_limit_made = true
	if shots_taken < par_limit:
		par_limit_made = true
	
	
func _update_level_history(time_best, shots_best, jug_history, hardcore_history): 
	previous_time_best = time_best
	previous_shots_best = shots_best
	previous_jug_history = jug_history
	previous_hardcore_history = hardcore_history

func update_level_calcs():
	pass

func _animate_endscreen():
	pass
