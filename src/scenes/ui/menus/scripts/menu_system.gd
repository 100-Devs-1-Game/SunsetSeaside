extends Control

func _ready():
	get_tree().get_root().size_changed.connect(_update_menu_sizes) 
	
func _update_menu_sizes():
	self.set_anchors_preset(PRESET_FULL_RECT)
