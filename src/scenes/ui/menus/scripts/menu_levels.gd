extends MarginContainer

const LEVEL_SLOT = preload("res://scenes/ui/menus/level_slot.tscn")
const LEVEL_IMAGE_PLACEHOLDER = preload("res://scenes/ui/menus/level_images/level_image_placeholder.tres")

@export_subgroup("level info labels")
@export var level_info_grid : GridContainer
@export var time_record_label : HBoxContainer
@export var time_limit_label: HBoxContainer
@export var par_record_label : Label
@export var par_limit_label : Label
@export var jug_collected_label : Label
@export_subgroup("level info spinners")
@export var spinner_time : SubViewportContainer
@export var spinner_par : SubViewportContainer
@export var spinner_jug : SubViewportContainer
@export_subgroup("level info misc")
@export var level_title_label : Label
@export var image_spinner_container : HBoxContainer
@export var level_image : TextureRect
@export var button_play_level : Button
@export var animation_player : AnimationPlayer
@export var label_bonus_slots : RichTextLabel

@export_subgroup("level slots")
@export var level_slots_debug : HBoxContainer
@export var level_slots_tutorial : HBoxContainer
@export var level_slots_easy : HBoxContainer
@export var level_slots_medium : HBoxContainer
@export var level_slots_hard : HBoxContainer
@export var level_slots_bonus : HBoxContainer
@export var label_debug_slots : Label

@onready var level_slots = [level_slots_debug, level_slots_tutorial, level_slots_easy, level_slots_medium, level_slots_hard, level_slots_bonus]
@onready var spinners_list = [spinner_time, spinner_par, spinner_jug]

var level_amount_debug = Gamestate.level_manager.levels_debug.size()
var level_amount_tutorial = Gamestate.level_manager.levels_tutorial.size()
var level_amount_easy = Gamestate.level_manager.levels_easy.size()
var level_amount_medium = Gamestate.level_manager.levels_medium.size()
var level_amount_hard = Gamestate.level_manager.levels_hard.size()
var level_amount_bonus = Gamestate.level_manager.levels_bonus.size()

var show_debug_levels = true # intended for development only
var all_levels_selectable = true # ^

var spinner_count = 0
var current_slot_info = {"grouping" : null, "id" : null}

func _ready():
	for spinner in spinners_list:
		if spinner != null:
			spinner.offset_position(spinner_count)
			spinner_count += 1

func _on_visibility_changed() -> void:
	if visible:
		# load saves so that information is fresh and can be accessed by population methods
		Keeper.load_records()
		Keeper.load_completion()
		
		if show_debug_levels == true:  
			_populate_level_slots(level_amount_debug, level_slots_debug, Enums.LevelGrouping.DEBUG)
			label_debug_slots.visible = true;
		else: label_debug_slots.visible = false; level_slots_debug.visible = false
		_populate_level_slots(level_amount_tutorial, level_slots_tutorial, Enums.LevelGrouping.DAYLIGHT)
		_populate_level_slots(level_amount_easy, level_slots_easy, Enums.LevelGrouping.SUNSET)
		_populate_level_slots(level_amount_medium, level_slots_medium, Enums.LevelGrouping.MIDNIGHT)
		_populate_level_slots(level_amount_hard, level_slots_hard, Enums.LevelGrouping.SUNRISE)
		_check_bonus_availability()

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
	DJ.create_audio(SFX_Setting.SOUND_EFFECT.UI_PRESSED)
	_update_skybox(slot.level_grouping)

func _show_level_info(slot, button):
	# animate panel
	if animation_player.is_playing(): animation_player.stop()
	animation_player.play("new_selection")
	var level_info = Gamestate.level_manager.fetch_level_info(slot.level_grouping, slot.level_id)
	
	# level title
	level_title_label.text = level_info["name"]
	level_title_label.label_settings.font_color = Color.WHITE
	
	# level image and spinners
	image_spinner_container.visible = true
	var level_image_path = level_info["level_image_path"]
	if level_image_path != null: level_image.texture = load(level_image_path)
	else: level_image.texture = LEVEL_IMAGE_PLACEHOLDER
	var level_history = Keeper.get_level_completion(slot.level_grouping, slot.level_id)
	
	spinner_time.shake_amount = 0.0; spinner_par.shake_amount = 0.0; spinner_jug.shake_amount = 0.0
	if level_history["time_complete"]: spinner_time.mesh_visibility(true); spinner_time.shake_amount += 0.1
	else: spinner_time.mesh_visibility(false)
	if level_history["par_complete"]: spinner_par.mesh_visibility(true); spinner_par.shake_amount += 0.1
	else: spinner_par.mesh_visibility(false)
	if level_history["jug_complete"]: spinner_jug.mesh_visibility(true); spinner_jug.shake_amount += 0.1
	else: spinner_jug.mesh_visibility(false)
	
	# level records and info
	level_info_grid.visible = true
	# limits
	if level_info["time_limit"] == null:
		time_limit_label.label_msec.text = "n/a"; time_limit_label.set_process(false)
		time_limit_label.hide_min_and_sec()
	else:
		time_limit_label.time = level_info["time_limit"]; time_limit_label.set_process(true)
		time_limit_label.display_time = level_info["time_limit"]
	
	if level_info["par"] == null:
		par_limit_label.text = "n/a"
	else: par_limit_label.text = str(snapped(level_info["par"], 0))
	
	# records
	if level_history["level_complete"] == false:
		time_record_label.label_msec.text = "n/a"; time_record_label.set_process(false)
		time_record_label.hide_min_and_sec() # we are a broken species
		par_record_label.text = "n/a"
		par_record_label.label_settings.font_color = Color.WEB_GRAY # sets colors for all record labels since they share the same label settings
		jug_collected_label.text = "n/a"
	else:
		var level_records = Keeper.get_level_history(slot.level_grouping, slot.level_id)
		time_record_label.time = level_records["time_best"]; time_record_label.set_process(true)
		time_record_label.display_time = level_records["time_best"]
		par_record_label.text = str(snapped(level_records["par_best"], 0))
		par_record_label.label_settings.font_color = Color.WHITE
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
	level_title_label.text = "unselected..."
	level_title_label.label_settings.font_color = Color.WEB_GRAY
	image_spinner_container.visible = false
	level_info_grid.visible = false
	time_record_label.set_process(true)
	button_play_level.visible = false

func _check_selectablity(grouping, id): # checking to see if previous level was completed, or if its the starting level
	if grouping == Enums.LevelGrouping.DEBUG: return true
	if grouping == Enums.LevelGrouping.BONUS: return true
	if grouping == Enums.LevelGrouping.DAYLIGHT && id == 0: return true

	var previous_level = Gamestate.level_manager.fetch_previous_level_info(grouping, id)
	if previous_level["grouping"] == null || previous_level["id"] == null: 
		return true
	else:
		var previous_level_completion = Keeper.get_level_completion(previous_level["grouping"], previous_level["id"])
		return previous_level_completion["level_complete"]

func _check_bonus_availability(): # these could only unlock if all time, par or jugs are grabbed
	# for now, if the hardest level of the last section if complete
	if Gamestate.level_manager.levels_hard.size() != 0:
		if all_levels_selectable:
			_populate_level_slots(level_amount_bonus, level_slots_bonus, Enums.LevelGrouping.BONUS)
		elif Keeper.get_level_completion(Enums.LevelGrouping.SUNRISE, Gamestate.level_manager.levels_hard.size() - 1)["level_complete"] == true:
			_populate_level_slots(level_amount_bonus, level_slots_bonus, Enums.LevelGrouping.BONUS)
		else:
			label_bonus_slots.text = "[wave freq=2 amp=30][rainbow freq=0.15]?"
	else:
		label_bonus_slots.text = "[wave freq=2 amp=30][rainbow freq=0.15]?"
	
func _update_skybox(level_grouping):
	match level_grouping:
		Enums.LevelGrouping.DAYLIGHT: Events.skybox_switch.emit(Enums.Skybox.SUNSET)
		Enums.LevelGrouping.SUNSET: Events.skybox_switch.emit(Enums.Skybox.SUNSET)
		Enums.LevelGrouping.MIDNIGHT: Events.skybox_switch.emit(Enums.Skybox.MIDNIGHT)
		Enums.LevelGrouping.SUNRISE: Events.skybox_switch.emit(Enums.Skybox.SUNSET)
		Enums.LevelGrouping.BONUS: Events.skybox_switch.emit(Enums.Skybox.BONUS)

func _on_button_play_level_pressed() -> void:
	Events.open_level.emit(current_slot_info["grouping"], current_slot_info["id"])
