extends SpringArm3D

var max_zoom : float = 20

func zoom_in():
	if spring_length > 0:
		spring_length -= .2

func zoom_out():
	if spring_length < max_zoom:
		spring_length += .2
	
