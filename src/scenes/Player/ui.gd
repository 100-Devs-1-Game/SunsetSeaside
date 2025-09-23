extends Control

@onready var ammo_label: Label = $MarginContainer/ammo_label

func _ready():
	Events.ui_ammo_update.connect(_update_ammo_label)
	
func _update_ammo_label(ammo):
	ammo_label.text = str(ammo)
