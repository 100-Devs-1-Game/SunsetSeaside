extends Menu
# handles ending menu updates and animations
@export_subgroup("labels")
@export var timer_label : HBoxContainer

@export_subgroup("labels amount")
@export var label_time_limit_amount : HBoxContainer
@export var label_shots_amount : Label
@export var label_par_amount : Label

@export_subgroup("labels best")
@export var label_time_best : Label
@export var label_par_best : Label
@export var label_jug_best : Label

@export_subgroup("buttons")
@export var button_main_menu : Button
@export var button_resart : Button
@export var button_next_level : Button

@export_subgroup("spinners")
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
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _ready():
	# setup
	Events.ui_send_end_results.connect(_update_end_results)
	Events.ui_send_level_history.connect(_update_level_history)
	timer_label.time_ticking_finished.connect(_animate_endscreen)
	
	# position spinners to prevent overlap in camera views
	for spinner in spinners_list:
		if spinner != null:
			spinner.offset_position(spinner_count)
			spinner_count += 1

func _process(_delta):
	if Input.is_action_just_pressed("restart"):
		restart_level()

func _update_end_results(time, time_limit, shots_taken, par_limit, jug_grabbed):
	# best and jug related vars are currently null
	
	# label setups
	timer_label.time = time
	label_shots_amount.text = str(shots_taken)
	
	label_time_limit_amount.time = time_limit
	label_time_limit_amount.display_time = time_limit
	
	label_par_amount.text = str(par_limit)
	
	if time < time_limit:
		time_limit_made = true
	if shots_taken < par_limit:
		par_limit_made = true
	
	
func _update_level_history(time_best, shots_best, jug_history, hardcore_history): 
	previous_time_best = time_best
	previous_shots_best = shots_best
	previous_jug_history = jug_history
	previous_hardcore_history = hardcore_history
	
	if previous_time_best != null:
		label_time_best.text = str(previous_time_best)

func update_level_calcs():
	pass

func _animate_endscreen():
	# debug spinner animation
	spinner_time.mesh_visibility(true)
	spinner_time.shake_amount += 0.14
	await get_tree().create_timer(0.3).timeout
	spinner_par.mesh_visibility(true)
	spinner_par.shake_amount += 0.14
	await get_tree().create_timer(0.3).timeout
	spinner_jug.mesh_visibility(true)
	spinner_jug.shake_amount += 0.14

func restart_level():
	Events.player_death.emit(Enums.PlayerDeathType.INSTANT)
	Events.close_menu.emit()

func _on_button_main_menu_pressed() -> void:
	pass # Replace with function body.

func _on_button_restart_pressed() -> void:
	restart_level()

func _on_button_next_level_pressed() -> void:
	pass # Replace with function body.
