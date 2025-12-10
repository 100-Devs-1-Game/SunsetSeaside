extends Menu

# master node for opening and closing the submenus
@onready var menu_root: Control = $menu_root
@onready var menu_title: MarginContainer = $menu_root/menu_title
@onready var menu_levels: MarginContainer = $menu_root/menu_levels
@onready var menu_settings: MarginContainer = $menu_root/menu_settings
@onready var menu_delete_confirm: MarginContainer = $menu_root/menu_delete_confirm

enum MenuType { TITLE, LEVELS, SETTINGS, CONFIRMATION }

func _ready():	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE # should put this in main script in an "open menu" function. for now:
func _on_button_levels_pressed() -> void: _open_menu(MenuType.LEVELS)
func _on_button_settings_pressed() -> void: _open_menu(MenuType.SETTINGS); Events.set_title_position.emit(Enums.TitlePosition.SETTINGS)
func _on_button_return_settings_pressed() -> void: _open_menu(MenuType.TITLE); Events.set_title_position.emit(Enums.TitlePosition.TITLE)
func _on_button_delete_confirm_open_pressed() -> void: _open_menu(MenuType.CONFIRMATION)
func _on_button_delete_no_pressed() -> void: _open_menu(MenuType.SETTINGS)
func _on_button_delete_yes_pressed() -> void: Keeper.erase_progress(); _open_menu(MenuType.TITLE)

func _on_button_quit_pressed() -> void: get_tree().quit()

func _open_menu(menu): # rename this!
	for node in menu_root.get_children(): node.visible = false
	# come get your child bro
	
	match menu:
		MenuType.TITLE: menu_title.visible = true 
		MenuType.LEVELS: menu_levels.visible = true
		MenuType.SETTINGS: menu_settings.visible = true
		MenuType.CONFIRMATION: menu_delete_confirm.visible = true

func on_menu_close():
	_open_menu(MenuType.TITLE)
