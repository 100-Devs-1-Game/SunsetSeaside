extends Control

const LEVEL_SLOT_SELECTABLE = preload("res://scenes/ui/menus/label_settings/level_slot_selectable.tres")
const LEVEL_SLOT_UNSELECTABLE = preload("res://scenes/ui/menus/label_settings/level_slot_unselectable.tres")

@export var icon_time: TextureRect
@export var icon_par: TextureRect
@export var icon_jug: TextureRect

@export var id_label : Label

signal slot_clicked(slot, button : int)

var level_grouping : Enums.LevelGrouping
var level_id : int
var level_selectable : bool = false

func set_level_data(grouping, id, selectable, time_history, par_history, jug_history):
	# need to set texture or text for level selection. depends on preference
	level_grouping = grouping
	level_id = id
	level_selectable = selectable
	
	# set slot graphics
	id_label.text = str(id)
	if selectable == false:
		id_label.label_settings = LEVEL_SLOT_UNSELECTABLE
	if time_history == false:
		icon_time.visible = false
	if par_history == false:
		icon_par.visible = false
	if jug_history == false:
		icon_jug.visible = false

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
