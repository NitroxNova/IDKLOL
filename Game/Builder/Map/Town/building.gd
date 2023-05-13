extends Map_Builder
class_name Town_Building

var min_size = 5
var max_size = 12
#var direction
var door : Vector2

func _init(x,y):
	position = Vector2(x,y)
	var length = randi_range(min_size, max_size)
	var width = randi_range(min_size, max_size)
	size = Vector2(length,width)

func get_center():
	return position + (size / 2)

func occupied_tiles():
	var oc_tiles = []
	for rel_x in size.x+2:
		for rel_y in size.y+2:
			var x = rel_x + position.x - 1
			var y = rel_y + position.y - 1
			oc_tiles.append(Vector2(x,y))
	return oc_tiles

func built_tiles():
	var bt_tiles = []
	for rel_x in size.x:
		for rel_y in size.y:
			var x = rel_x + position.x
			var y = rel_y + position.y
			bt_tiles.append(Vector2(x,y))
	return bt_tiles

func render():
	for rel_x in size.x:
		for rel_y in size.y:
			var x = rel_x + position.x
			var y = rel_y + position.y
			var data = {}
			data.needs_render = true
			data.position = Vector3(x,0,y)
			data.renderable = Renderable.FLOOR
			data.material = Material_3D.WOOD
			emit_signal("create_entity",data)
	
	for rel_x in size.x:
		render_wall(rel_x,0)
		render_wall(rel_x,size.y-1)
	for rel_y in size.y:
		render_wall(0,rel_y)
		render_wall(size.x-1,rel_y)
	render_roof()
		
func render_wall(rel_x,rel_y):
	if not Vector2(rel_x,rel_y) == door:
		var x = rel_x + position.x
		var y = rel_y + position.y
		var data = {}
		data.needs_render = true
		data.position = Vector3(x,0,y)
		data.renderable = Renderable.WALL
		emit_signal("create_entity",data)

func render_roof():
	var data = {}
	data.needs_render = true
	data.renderable = Renderable.ROOF
	data.position = Vector3.ZERO
	data.position.x = position.x + (size.x/2.0) -0.5
	data.position.y = 3.0
	data.position.z = position.y + (size.y/2.0) -0.5
	data.scale = Vector3(size.x,3,size.y)
	data.name = "Roof"
	emit_signal("create_entity",data)
	
	
func add_door(side:String):
	var x = randi_range(1,size.x-2)
	var y
	if side == "north":
		y = 0
	elif side == "south":
		y = size.y - 1
#	var y = randi_range(1,size.x-1)
#	var x = 0
	door = Vector2(x,y)
#	print(door)
	return door
	
