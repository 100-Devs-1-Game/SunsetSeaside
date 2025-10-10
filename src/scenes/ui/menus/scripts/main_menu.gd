extends Control

func _on_button_levels_pressed() -> void:
	Events.open_level.emit(Enums.LevelGrouping.DEBUG, 0)

func _on_button_quit_pressed() -> void:
	get_tree().quit()
