extends HBoxContainer

var time = 0.0:
	get: return time
	set(value):
		time = value
		_time_updated()
		
func _time_updated():
	var min = fmod(time, 3600) / 60
	var secs = fmod(time, 60)
	var msecs = fmod(time, 1) * 1000
	
	if min > 1.0: $label_min.visible = true; $label_min.text = ("%01d:" % min)
	else: $label_min.visible = false
	
	if secs > 1.0 || min > 1.0: 
		$label_sec.visible = true 
		if secs >= 10.0 || min > 1.0: 
			$label_sec.text = ("%02d" % secs)
		else: $label_sec.text = ("%01d" % secs)
	else: $label_sec.visible = false	
	
	if msecs > 0.0 || secs > 1.0 || min > 1.0: $label_msec.visible = true; $label_msec.text = ".%03d" % msecs
	else: $label_msec.text = " " # stay visible for the sake of labels above not moving 
 
	# print(str(min) + ":", str(secs) + ".", "%02d" % msecs) 
