extends Control

@export var ammo_label: Label 
@onready var shots_label: Label = $VBoxContainer/MarginContainer3/shots_label

func _ready():
	Events.ui_ammo_update.connect(_update_ammo_label)
	Events.ui_shots_taken_update.connect(_update_shot_label)
	
func _update_ammo_label(ammo):
	ammo_label.text = str(ammo)
	
func _update_shot_label(amount):
	# should show level par amount as well. for now:
	shots_label.text = str(amount)
