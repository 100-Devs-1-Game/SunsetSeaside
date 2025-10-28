extends Control

var last_menu_opened : Enums.Menus
var last_title_menu_state # basically, wherever the title menu was when last opened

func _ready():
	get_tree().get_root().size_changed.connect(_update_menu_sizes) 
	Events.open_menu.connect(_open_menu)
	Events.close_menu.connect(_close_menu)
	
func _update_menu_sizes():
	self.set_anchors_preset(PRESET_FULL_RECT)

func _open_menu(menu : Enums.Menus):
	_close_menu() # clear any previous menus

	var menu_path : String
	match menu: # storing menu paths here, FUCK IT
		Enums.Menus.TITLE: menu_path = "res://scenes/ui/menus/main_menu.tscn"
		Enums.Menus.RESULTS: menu_path = "res://scenes/ui/menus/results_menu.tscn"
		Enums.Menus.PAUSE: return # for now, no pause menu
		
	var new_menu = load(menu_path).instantiate()
	self.add_child(new_menu)
	
	if menu == Enums.Menus.TITLE: # put title back to where it was
		Events.ui_update_title_state.emit(last_title_menu_state)
	last_menu_opened = menu
	
func _close_menu():
	for node in self.get_children():
		node.queue_free()
