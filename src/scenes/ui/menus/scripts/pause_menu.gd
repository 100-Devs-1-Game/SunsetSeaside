extends Menu


func on_menu_close():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	queue_free()

func _on_button_settings_open_pressed() -> void:
	pass # Replace with function body.
 
func _on_button_return_pressed() -> void:
	pass # Replace with function body.

func _on_button_quit_pressed() -> void:
	Events.queue_menu_package.emit(Enums.LevelGrouping.DEBUG, 0, Enums.Menus.TITLE)
