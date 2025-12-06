extends Menu
# handles ending menu updates and animations
@export_subgroup("labels")
@export var timer_label : HBoxContainer
@export var label_jug_state : Label

@export_subgroup("labels amount")
@export var label_time_limit_amount : HBoxContainer
@export var label_shots_amount : Label
@export var label_par_amount : Label

@export_subgroup("labels best")
@export var label_time_best : HBoxContainer
@export var label_time_na : Label
@export var label_par_best : Label
#@export var label_jug_best : Label

@export_subgroup("labels_record")
@export var label_time_record : RichTextLabel
@export var label_par_record : RichTextLabel
@export var label_jug_cheers : RichTextLabel

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

# storing vars for animating
var current_time
var current_shots
var current_jug
var current_hardcore

var previous_time
var previous_shots
var previous_jug
var previous_hardcore

var time_limit_made = false
var par_made = false

func on_menu_close():
	Events.close_menu.emit()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _ready():
	# setup
	Events.ui_send_end_results.connect(_update_end_results)
	Events.ui_send_level_history.connect(_update_level_history)
	timer_label.time_ticking_finished.connect(_animate_endscreen)
	
	# position spinners to prevent overlap in camera views

func _process(_delta):
	if Input.is_action_just_pressed("restart"):
		restart_level()

func _update_level_history(time_best, shots_best, jug_history, hardcore_history): 
	previous_time = time_best
	if shots_best == null: previous_shots = null
	else: previous_shots = snapped(shots_best, 1) # was putting previous shots as a float???
	previous_jug = jug_history
	previous_hardcore = hardcore_history
	
	if previous_time != null:
		update_time_best_label(previous_time)
		
	if previous_shots != null:
		label_par_best.text = str(previous_shots)
		
	if jug_history == true:
		spinner_jug.mesh_visibility(true)

func _update_end_results(time, time_limit, shots_taken, par_limit, jug_grabbed):
	# best and jug related vars are currently null
	
	current_time = time
	current_shots = shots_taken
	current_jug = jug_grabbed
	# current_hardcore = hardcore
	
	# label setups
	timer_label.time = time
	label_shots_amount.text = str(shots_taken)
	
	label_time_limit_amount.time = time_limit
	label_time_limit_amount.display_time = time_limit
	
	label_par_amount.text = str(par_limit)
	
	# update labels
	if time < time_limit:
		time_limit_made = true
	if previous_time == null: pass
	elif time_limit > previous_time:
		spinner_time.mesh_visibility(true)
	
	if shots_taken <= par_limit:
		par_made = true
	if previous_shots == null: pass
	elif par_limit >= previous_shots:
		spinner_par.mesh_visibility(true)
	
	if jug_grabbed == true:
		label_jug_state.text = "collected!"
	if previous_jug == true:
		spinner_jug.mesh_visibility(true)
	
var animate_time_gap = 0.3
var spinners_shake_amount = 0.14
func _animate_endscreen():
	# debug spinner animation
	
	var time_shaken
	var par_shaken
	var jug_shaken
	
	# timer spinner
	if time_limit_made && spinner_time.get_mesh_visibility() == false:
		spinner_time.mesh_visibility(true)
		spinner_time.shake_amount += 0.14
	
	if previous_time == null:
		label_time_record.visible = true
		update_time_best_label(current_time)
		if !time_shaken: spinner_time.shake_amount += spinners_shake_amount
	elif previous_time > current_time:
		label_time_record.visible = true
		update_time_best_label(current_time)
		if !time_shaken: spinner_time.shake_amount += spinners_shake_amount
	
	await get_tree().create_timer(animate_time_gap).timeout
	
	# par spinner
	if par_made && spinner_par.get_mesh_visibility() == false:
		spinner_par.mesh_visibility(true)
		spinner_par.shake_amount += 0.14
	
	if previous_shots == null:
		label_par_record.visible = true
		label_par_best.text = str(current_shots)
		if !par_shaken: spinner_par.shake_amount += spinners_shake_amount
	elif previous_shots > current_shots:
		label_par_record.visible = true
		label_par_best.text = str(current_shots)
		if !par_shaken: spinner_par.shake_amount += spinners_shake_amount
	
	await get_tree().create_timer(animate_time_gap).timeout
	
	# jug spinner
	if current_jug == true && spinner_jug.get_mesh_visibility() == false:
		spinner_jug.mesh_visibility(true)
	
	if current_jug:
		spinner_jug.shake_amount += spinners_shake_amount
		label_jug_cheers.visible = true
		
		
func update_time_best_label(value):
		label_time_best.visible = true
		label_time_best.set_process(true)
		label_time_best.time = value
		label_time_best.display_time = value
		
		label_time_na.visible = false

func restart_level():
	Events.player_death.emit(Enums.PlayerDeathType.INSTANT)
	Events.close_menu.emit()


# signal functions
func _on_button_main_menu_pressed() -> void:
	Events.queue_menu_package.emit(Enums.LevelGrouping.DEBUG, 0, Enums.Menus.TITLE)

func _on_button_restart_pressed() -> void:
	restart_level()

func _on_button_next_level_pressed() -> void:
	Events.open_next_level.emit()
