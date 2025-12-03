extends MarginContainer

const LEVEL_SLOT = preload("res://scenes/ui/menus/level_slot.tscn")


@onready var level_slots_root: VBoxContainer = $level_slots_root

@export var level_slots_debug : HBoxContainer
@export var level_slots_tutorial : HBoxContainer
@export var level_slots_easy : HBoxContainer
@export var level_slots_medium : HBoxContainer
@export var level_slots_hard : HBoxContainer

var level_amount_debug = Gamestate.level_manager.levels_debug.size()
var level_amount_tutorial = Gamestate.level_manager.levels_tutorial.size()
var level_amount_easy = Gamestate.level_manager.levels_easy.size()
var level_amount_medium = Gamestate.level_manager.levels_medium.size()
var level_amount_hard = Gamestate.level_manager.levels_hard.size()

var show_debug_levels = true # intended for development only

func _on_visibility_changed() -> void:
	if visible:
		# load saves so that information is fresh and can be accessed by population methods
		Keeper.load_records()
		Keeper.load_completion()
		
		if show_debug_levels == true:  
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
		# instantiate current slot
		var slot = LEVEL_SLOT.instantiate()
		slots.add_child(slot)
		var level_history = Keeper.get_level_completion(grouping, i)
		slot.set_level_data(grouping, i, _check_selectablity(grouping, i), level_history["time_complete"], level_history["par_complete"], level_history["jug_complete"])	
		slot.slot_clicked.connect(_on_slot_clicked)

func _on_slot_clicked(slot, button):
	Events.open_level.emit(slot.level_grouping, slot.level_id)

func _check_selectablity(grouping, id): # checking to see if previous level was completed, or if its the starting level
	if grouping == Enums.LevelGrouping.DEBUG: return true
	if grouping == Enums.LevelGrouping.DAYLIGHT && id == 0: return true
	
	var previous_level = Gamestate.level_manager.fetch_previous_level_info(grouping, id)
	var previous_level_completion = Keeper.get_level_completion(previous_level["grouping"], previous_level["id"])
	return previous_level_completion["level_complete"]
