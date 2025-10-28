class_name Main
extends Node3D
# main fundamental highest level control

@onready var menu_system = $menu_system
@onready var scene_container = $scene_container

## need a proper way to store / choose level scenes ( should call the file when chosen in a menu by an autoload)
 
func _ready():
	Events.open_level.connect(_open_level)
	Events.open_menu.emit(Enums.Menus.TITLE)
	#_load_scene(TEST_LEVEL)

func _open_level(grouping, id):
	_load_scene(load(Gamestate.level_manager.fetch_level_path(grouping, id)))
	Events.close_menu.emit()

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
	if Input.is_action_just_pressed("menu_back"): 
		if menu_system.get_children().size() > 0:
			menu_system.get_child(0).on_menu_close()
		else: Events.open_menu.emit(Enums.Menus.PAUSE)
