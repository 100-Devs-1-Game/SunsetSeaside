class_name Main
extends Node3D
# main fundamental highest level control

@onready var menu_system = $menu_system
@onready var scene_container = $scene_container

var last_menu_opened : Enums.Menus
var last_title_menu_state # basically, wherever the title menu was when last opened

## need a proper way to store / choose level scenes ( should call the file when chosen in a menu by an autoload)
 
func _ready():
	Events.open_level.connect(_open_level)
	Events.open_menu.connect(_open_menu)
	_open_menu(Enums.Menus.TITLE)
	#_load_scene(TEST_LEVEL)

func _open_level(grouping, id):
	_load_scene(load(Gamestate.level_manager.fetch_level_path(grouping, id)))
	_close_menu()

func _load_scene(scene : PackedScene):
	if scene_container.get_children().size() != 0:
		scene_container.get_child(0).queue_free()
	
	var level = scene.instantiate()
	scene_container.add_child(level)
	if level.has_meta(&"Level"):
		Events.establish_level_vars.emit(level.ammo_max, level.par_limit, level.time_limit)
	
	if scene_container.get_children().size() > 1:
		print_debug("WARNING: more than one child in scene container of the main scene!")

func _process(_delta):
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene() ## change this to reload current level

func _open_menu(menu : Enums.Menus):
	_close_menu() # clear any previous menus
	
	var menu_path : String
	match menu: # storing menu paths here, FUCK IT
		Enums.Menus.TITLE: menu_path = "res://scenes/ui/menus/main_menu.tscn"
		Enums.Menus.RESULTS: menu_path = "res://scenes/ui/menus/end_menu.tscn"
		
	var new_menu = load(menu_path).instantiate()
	menu_system.add_child(new_menu)
	
	if menu == Enums.Menus.TITLE: # put title back to where it was
		Events.ui_update_title_state.emit(last_title_menu_state)
	last_menu_opened = menu
	
func _close_menu():
	for node in menu_system.get_children():
		node.queue_free()
