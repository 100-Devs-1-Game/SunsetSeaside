extends HBoxContainer

func _process(delta):
	if Gamestate.stopwatch == null : return
	var time = Gamestate.stopwatch.time
	var min = snapped(time / 60, 1)
	var secs = snapped(time, 1)
	var msecs = snapped((fmod(time, .99) * 100), 1)
	if min > 0.0: $label_min.visible = true; $label_min.text = (str(min) + ":")
	else: $label_min.visible = false
	if secs > 0.0: $label_sec.visible = true; $label_sec.text = (str(secs) + ".")
	else: $label_sec.visible = false	
	if msecs > 0.0: $label_msec.visible = true; $label_msec.text = "%02d" % msecs
	else: $label_msec.text = " " # stay visible for the sake of labels above not moving 
 
	# print(str(min) + ":", str(secs) + ".", "%02d" % msecs) 
