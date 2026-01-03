extends MarginContainer

@export var line_edit : LineEdit
@export var button_delete_yes: Button

func _on_line_edit_text_changed(new_text: String) -> void:
	if new_text == "424":
		button_delete_yes.disabled = false
	else: button_delete_yes.disabled = true

func _on_visibility_changed() -> void:
	line_edit.text = ""
	button_delete_yes.disabled = true
