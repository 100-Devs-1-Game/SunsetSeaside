extends MarginContainer

@export_subgroup("value labels")
@export var label_sens_val : Label
@export var label_fov_val : Label
@export var label_res_scale_val : Label

@export var label_master_vol : Label
@export var label_sfx_vol : Label
@export var label_music_vol : Label
@export var label_ambient_vol : Label

func _on_visibility_changed() -> void:
	if self.visible == false:
		pass
		# save settings data
 


func _on_slider_sens_value_changed(value: float) -> void:
	label_sens_val.text = " " + str(value)

func _on_slider_fov_value_changed(value: float) -> void:
	label_fov_val.text = " " + str(snapped(value, 1))

func _on_slider_res_scale_value_changed(value: float) -> void:
	label_res_scale_val.text = " " + str(snapped(value, 1)) + "x"



func _on_slider_master_vol_value_changed(value: float) -> void:
	label_master_vol.text = " " + str(snapped(value, 1)) 

func _on_slider_sfx_vol_value_changed(value: float) -> void:
	label_sfx_vol.text = " " + str(snapped(value, 1)) 

func _on_slider_music_vol_value_changed(value: float) -> void:
	label_music_vol.text = " " + str(snapped(value, 1)) 

func _on_slider_ambient_vol_value_changed(value: float) -> void:
	label_ambient_vol.text = " " + str(snapped(value, 1)) 



func _on_checkbox_fullscreen_toggled(toggled_on: bool) -> void:
	pass # Replace with function body.


func _on_checkbox_4_by_3_toggled(toggled_on: bool) -> void:
	pass # Replace with function body.


func _on_checkbox_hide_labels_toggled(toggled_on: bool) -> void:
	pass # Replace with function body.


func _on_checkbox_crouch_toggle_toggled(toggled_on: bool) -> void:
	pass # Replace with function body.
