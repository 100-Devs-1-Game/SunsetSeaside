extends Control

@onready var icon_under_par: PanelContainer = $VBoxContainer/HBoxContainer/icon_under_par
@onready var icon_under_time_limit: PanelContainer = $VBoxContainer/HBoxContainer/icon_under_time_limit
@onready var icon_jug_collected: PanelContainer = $VBoxContainer/HBoxContainer/icon_jug_collected

@export var id_label : Label

signal slot_clicked(slot, button : int)

var level_grouping : Enums.LevelGrouping
var level_id : int

func set_level_data(grouping, id):
	# need to set texture or text for level selection. depends on preference
	level_grouping = grouping
	level_id = id
	id_label.text = str(id)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton \
			and (event.button_index == MOUSE_BUTTON_LEFT \
			or event.button_index == MOUSE_BUTTON_RIGHT) \
			and event.is_pressed():
		slot_clicked.emit(self, event.button_index)

func _on_texture_rect_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton \
			and (event.button_index == MOUSE_BUTTON_LEFT \
			or event.button_index == MOUSE_BUTTON_RIGHT) \
			and event.is_pressed():
		slot_clicked.emit(self, event.button_index)
