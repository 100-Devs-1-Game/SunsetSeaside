extends Menu

@onready var menu_selection: MarginContainer = $menu_root/menu_selection
@onready var menu_settings: MarginContainer = $menu_root/menu_settings

func on_menu_close():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if menu_settings.visible: menu_settings.visible = false
	queue_free()

func _on_button_settings_open_pressed() -> void:
	menu_settings.visible = true
	menu_selection.visible = false
 
func _on_button_return_pressed() -> void:
	Events.close_menu.emit()

func _on_button_restart_pressed() -> void:
	Events.player_death.emit(Enums.PlayerDeathType.INSTANT)
	Events.close_menu.emit()

func _on_button_quit_pressed() -> void:
	Events.queue_menu_package.emit(Enums.LevelGrouping.DEBUG, 0, Enums.Menus.TITLE)

func _on_button_return_settings_pressed() -> void:
	menu_settings.visible = false
	menu_selection.visible = true
