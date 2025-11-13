extends MarginContainer

# reminder: defaults established in settings file creation

@export_subgroup("value labels")
@export var label_sens_val : Label
@export var label_fov_val : Label
@export var label_res_scale_val : Label

@export var label_master_vol : Label
@export var label_sfx_vol : Label
@export var label_music_vol : Label
@export var label_ambient_vol : Label

@export_subgroup("sliders")
@export var slider_sens : HSlider
@export var slider_fov : HSlider
@export var slider_res_scale : HSlider
@export var slider_master_vol : HSlider
@export var slider_sfx_vol : HSlider
@export var slider_music_vol : HSlider
@export var slider_ambient_vol : HSlider

@export_subgroup("checkboxes")
@export var checkbox_fullscreen : CheckBox
@export var checkbox_4by3 : CheckBox
@export var checkbox_labels_hidden : CheckBox
@export var checkbox_crouch_toggle : CheckBox

var current_settings_data : Dictionary = {}

func _on_visibility_changed() -> void:
	if self.visible == true:
		Keeper.load_settings()
		current_settings_data = Keeper.get_settings_data()
		
		# populate current settings (please help me)
		slider_sens.value = current_settings_data["sensitivity"]
		label_sens_val.text = " " + str(current_settings_data["sensitivity"])
		
		slider_fov.value = current_settings_data["fov"]
		label_fov_val.text = " " + str(snapped(current_settings_data["fov"], 1))
		
		slider_res_scale.value = current_settings_data["resolution scale"]
		label_res_scale_val.text = " " + str(snapped(current_settings_data["resolution scale"], 1)) + "x"
		
		slider_master_vol.value = current_settings_data["master vol"]
		label_master_vol.text = " " + str(snapped(current_settings_data["master vol"], 1)) 
		
		slider_sfx_vol.value = current_settings_data["sfx vol"]
		label_sfx_vol.text = " " + str(snapped(current_settings_data["sfx vol"], 1)) 
		
		slider_music_vol.value = current_settings_data["music vol"]
		label_music_vol.text = " " + str(snapped(current_settings_data["music vol"], 1)) 
		
		slider_ambient_vol.value = current_settings_data["ambient vol"]
		label_ambient_vol.text = " " + str(snapped(current_settings_data["ambient vol"], 1)) 		
		
		checkbox_fullscreen.button_pressed = current_settings_data["fullscreen"]
		checkbox_4by3.button_pressed = current_settings_data["4by3"]
		checkbox_labels_hidden.button_pressed = current_settings_data["hidden labels"]
		checkbox_crouch_toggle.button_pressed = current_settings_data["crouch toggle"]

	if self.visible == false:
		Keeper.write_settings_data(current_settings_data)
		Keeper.save_settings()
		# save settings data


func _on_slider_sens_value_changed(value: float) -> void:
	label_sens_val.text = " " + str(value)
	Events.set_sens.emit(value)
	current_settings_data["sensitivity"] = value
	print(2.0 - value)

func _on_slider_fov_value_changed(value: float) -> void:
	label_fov_val.text = " " + str(snapped(value, 1))
	Events.set_fov.emit(snapped(value, 1))
	current_settings_data["fov"] = value
	
func _on_slider_res_scale_value_changed(value: float) -> void:
	label_res_scale_val.text = " " + str(snapped(value, 1)) + "x"
	Events.set_reso_scale.emit(snapped(value, 1))
	current_settings_data["resolution scale"] = value



func _on_slider_master_vol_value_changed(value: float) -> void:
	label_master_vol.text = " " + str(snapped(value, 1)) 
	Events.set_master_vol.emit(snapped(value, 1))
	current_settings_data["master vol"] = value

func _on_slider_sfx_vol_value_changed(value: float) -> void:
	label_sfx_vol.text = " " + str(snapped(value, 1)) 
	Events.set_sfx_vol.emit(snapped(value, 1))
	current_settings_data["sfx vol"] = value
	
func _on_slider_music_vol_value_changed(value: float) -> void:
	label_music_vol.text = " " + str(snapped(value, 1)) 
	Events.set_music_vol.emit(snapped(value, 1))
	current_settings_data["music vol"] = value

func _on_slider_ambient_vol_value_changed(value: float) -> void:
	label_ambient_vol.text = " " + str(snapped(value, 1)) 
	Events.set_ambient_vol.emit(snapped(value, 1))
	current_settings_data["ambient vol"] = value



func _on_checkbox_fullscreen_toggled(toggled_on: bool) -> void:
	Events.set_fullscreen.emit(toggled_on)
	current_settings_data["fullscreen"] = toggled_on

func _on_checkbox_4_by_3_toggled(toggled_on: bool) -> void:
	Events.set_4by3.emit(toggled_on)
	current_settings_data["4by3"] = toggled_on
	
func _on_checkbox_hide_labels_toggled(toggled_on: bool) -> void:
	Events.set_labels_hidden.emit(toggled_on)
	current_settings_data["hidden labels"] = toggled_on
	
func _on_checkbox_crouch_toggle_toggled(toggled_on: bool) -> void:
	Events.set_crouch_toggle.emit(toggled_on)
	current_settings_data["crouch toggle"] = toggled_on
