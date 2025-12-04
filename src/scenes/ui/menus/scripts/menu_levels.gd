extends MarginContainer

const LEVEL_SLOT = preload("res://scenes/ui/menus/level_slot.tscn")

@export_subgroup("level info screen")
@export var level_title_label : Label
@export var level_image : TextureRect
@export var level_info_grid : GridContainer
@export var time_record_label : HBoxContainer
@export var par_record_label : Label
@export var jug_collected_label : Label
@export var button_play_level : Button

@export_subgroup("level slots")
@export var level_slots_debug : HBoxContainer
@export var level_slots_tutorial : HBoxContainer
@export var level_slots_easy : HBoxContainer
@export var level_slots_medium : HBoxContainer
@export var level_slots_hard : HBoxContainer

@onready var level_slots = [level_slots_debug, level_slots_tutorial, level_slots_easy, level_slots_medium, level_slots_hard]

var level_amount_debug = Gamestate.level_manager.levels_debug.size()
var level_amount_tutorial = Gamestate.level_manager.levels_tutorial.size()
var level_amount_easy = Gamestate.level_manager.levels_easy.size()
var level_amount_medium = Gamestate.level_manager.levels_medium.size()
var level_amount_hard = Gamestate.level_manager.levels_hard.size()

var show_debug_levels = true # intended for development only
var all_levels_selectable = true # ^

var current_slot_info = {"grouping" : null, "id" : null}

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
		
		_reset_level_info()

func _populate_level_slots(amount, slots, grouping):
	# firstly, delete all slots if they exist
	for slot in slots.get_children():
		slot.queue_free()
	
	for i in amount:
		# instantiate current slot
		var slot = LEVEL_SLOT.instantiate()
		slots.add_child(slot)
		var level_history = Keeper.get_level_completion(grouping, i)
		
		var selectable = all_levels_selectable
		if selectable == false: 
			selectable = _check_selectablity(grouping, i)
		slot.set_level_data(grouping, i, selectable, level_history["time_complete"], level_history["par_complete"], level_history["jug_complete"])	
		
		slot.slot_clicked.connect(_on_slot_clicked)

func _on_slot_clicked(slot, button):
	current_slot_info["grouping"] = slot.level_grouping
	current_slot_info["id"] = slot.level_id
	_show_level_info(slot, button)

func _show_level_info(slot, button):
	# level title
	level_title_label.text = Gamestate.level_manager.fetch_level_name(slot.level_grouping, slot.level_id)
	level_title_label.label_settings.font_color = Color.WHITE
	
	# level image
	level_image.visible = true
	#level_image.texture = load(Gamestate.level_manager.fetch_level_image(slot.level_grouping, slot.level_id)
	
	# level records and info
	level_info_grid.visible = true
	if Keeper.get_level_completion(slot.level_grouping, slot.level_id)["level_complete"] == false:
		time_record_label.label_msec.text = "n/a"; time_record_label.set_process(false)
		time_record_label.hide_min_and_sec() # we are a broken species
		par_record_label.text = "n/a"
		jug_collected_label.text = "n/a"
	else:
		var level_records = Keeper.get_level_history(slot.level_grouping, slot.level_id)
		time_record_label.time = level_records["time_best"]; time_record_label.set_process(true)
		time_record_label.display_time = level_records["time_best"]
		par_record_label.text = str(snapped(level_records["par_best"], 0))
		if level_records["jug_history"]: jug_collected_label.text = "aye!"
		else: jug_collected_label.text = "nay!"
	
	# button
	button_play_level.visible = true
	if slot.level_selectable == false:
		button_play_level.disabled = true
	else: button_play_level.disabled = false
	
	# slot selection
	for slot_group in level_slots:
		for slut in slot_group.get_children(): # ;)
			slut.selection_indicator.visible = false
	slot.selection_indicator.visible = true


func _reset_level_info():
	level_title_label.text = "unselected!"
	level_title_label.label_settings.font_color = Color.WEB_GRAY
	level_image.visible = false
	level_info_grid.visible = false
	time_record_label.set_process(true)
	button_play_level.visible = false

func _check_selectablity(grouping, id): # checking to see if previous level was completed, or if its the starting level
	if grouping == Enums.LevelGrouping.DEBUG: return true
	if grouping == Enums.LevelGrouping.DAYLIGHT && id == 0: return true
	
	
	var previous_level = Gamestate.level_manager.fetch_previous_level_info(grouping, id)
	if previous_level["grouping"] == null || previous_level["id"] == null: 
		return true
	else:
		var previous_level_completion = Keeper.get_level_completion(previous_level["grouping"], previous_level["id"])
		return previous_level_completion["level_complete"]

func _on_button_play_level_pressed() -> void:
	Events.open_level.emit(current_slot_info["grouping"], current_slot_info["id"])
