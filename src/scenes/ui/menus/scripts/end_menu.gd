extends CanvasLayer

# handles ending menu updates and animations

@export var label_time_amount : Label
@export var label_shots_amount : Label

func _ready():
	Events.ui_send_level_end_results.connect(_update_end_results)
	
func _update_end_results():
	pass
