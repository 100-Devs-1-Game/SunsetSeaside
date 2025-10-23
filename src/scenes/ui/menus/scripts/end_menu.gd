extends CanvasLayer

# handles ending menu updates and animations

@export var timer_label : HBoxContainer
@export var label_shots_amount : Label

func _ready():
	Events.ui_send_level_end_results.connect(_update_end_results)
	timer_label.time_ticking_finished.connect(_post_timer_animation)
	
func _update_end_results(time, time_limit, time_best, shots_taken, par_limit, shots_best, jug_grabbed, jug_history):
	# best and jug related vars are currently null
	timer_label.time = time
	label_shots_amount.text = str(shots_taken)

func _post_timer_animation():
	pass
