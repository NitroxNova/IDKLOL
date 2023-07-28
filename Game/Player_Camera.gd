extends SpringArm3D

var max_zoom : float = 20

func zoom_in():
	if spring_length > 0:
		spring_length -= .2

func zoom_out():
	if spring_length < max_zoom:
		spring_length += .2

func rotate_around_player(amount:Vector2):
#	print("rotating camera around player")
	var x = amount.x * -0.007
	rotate(Vector3.UP,x)
##	rotate_y(x)
#	rotation.y += x
	
#	var y = amount.y * 0.007
#	var max_up_down : float = PI/2
#	var new_rotation = rotation.x - y
#	new_rotation = min(new_rotation,max_up_down)
#	new_rotation = max(new_rotation, -1 * max_up_down)
#	rotation.x = new_rotation
	
