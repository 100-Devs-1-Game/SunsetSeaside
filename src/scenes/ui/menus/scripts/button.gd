extends Button



func _on_pressed() -> void:
	DJ.create_audio(SFX_Setting.SOUND_EFFECT.UI_PRESSED)
