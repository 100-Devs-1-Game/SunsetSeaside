extends Control

@export var ammo_label: Label 
@export var shots_label: Label
@export var time_limit_label: HBoxContainer
@export var par_amount_label: Label

func _ready():
	Events.ui_ammo_update.connect(_update_ammo_label)
	Events.ui_shots_taken_update.connect(_update_shot_label)
	Events.ui_set_level_vars.connect(_update_level_vars)
	_update_level_vars(Gamestate.current_max_ammo, Gamestate.current_par, Gamestate.current_time_limit)

func _update_ammo_label(ammo):
	ammo_label.text = str(ammo)
	
func _update_shot_label(amount):
	# should show level par amount as well. for now:
	shots_label.text = str(amount)

func _update_level_vars(max_ammo, par_limit, time_limit): # setting levels that display limits, par, etc
	time_limit_label.time = time_limit
	par_amount_label.text = str(par_limit)
