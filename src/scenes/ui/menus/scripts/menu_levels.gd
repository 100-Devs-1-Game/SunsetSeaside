extends MarginContainer

const LEVEL_SLOT = preload("res://scenes/ui/menus/level_slot.tscn")


@onready var level_slots_root: VBoxContainer = $level_slots_root

@export var level_slots_debug : HBoxContainer
@export var level_slots_tutorial : HBoxContainer
@export var level_slots_easy : HBoxContainer
@export var level_slots_medium : HBoxContainer
@export var level_slots_hard : HBoxContainer

# defining the amount of levels for each category here
# maybe pull from the level data list instead later? 
var level_amount_debug = 1
var level_amount_tutorial = 4
var level_amount_easy = 6
var level_amount_medium = 8
var level_amount_hard = 5

func _on_visibility_changed() -> void:
	if visible:
		_populate_level_slots(level_amount_debug, level_slots_debug, Enums.LevelGrouping.DEBUG)
		_populate_level_slots(level_amount_tutorial, level_slots_tutorial, Enums.LevelGrouping.DAYLIGHT)
		_populate_level_slots(level_amount_easy, level_slots_easy, Enums.LevelGrouping.SUNSET)
		_populate_level_slots(level_amount_medium, level_slots_medium, Enums.LevelGrouping.MIDNIGHT)
		_populate_level_slots(level_amount_hard, level_slots_hard, Enums.LevelGrouping.SUNRISE)

func _populate_level_slots(amount, slots, grouping):
	# firstly, delete all slots if they exist
	for slot in slots.get_children():
		slot.queue_free()
	
	for i in amount:
		var slot = LEVEL_SLOT.instantiate()
		slots.add_child(slot)
		slot.set_level_data(grouping, i)	
		slot.slot_clicked.connect(_on_slot_clicked)			

func _on_slot_clicked(slot, button):
	Events.open_level.emit(slot.level_grouping, slot.level_id)
