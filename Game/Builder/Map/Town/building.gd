extends Map_Builder
class_name Town_Building

#var direction
var door : Vector2
var type = Spawn.TOWN_BUILDING

func _init(dimensions:Rect2):
	position = dimensions.position
	size = dimensions.size

func build():
#	print("building pub")
	var player_pos = Vector3(get_center().x,0,get_center().y)
	spawns[player_pos] = "path"
	var blueprint = Spawn.get_data(type)
	for s in blueprint.spawn_list:
		var spawn = random_spawn(s)

func get_center():
	return position + (size / 2)

func random_spawn(spawn_id):
	var entity = Spawn.get_data(spawn_id)
	var pos = random_interior_position()
	while pos in spawns:
		pos = random_interior_position()
	entity.position = pos
	entity.rotation = Vector3.ZERO
	entity.rotation.y = randf_range(0,2*PI)
	spawns[pos] = entity
	return entity
	
func random_interior_position():
	var pos = Vector3.ZERO
	pos.x = randi_range(position.x+1,position.x+size.x-2)
	pos.z = randi_range(position.y+1,position.y+size.y-2)
	return pos
	
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
			create_entity.emit(data)
	
	for rel_x in size.x:
		render_wall(rel_x,0)
		render_wall(rel_x,size.y-1)
	for rel_y in size.y:
		render_wall(0,rel_y)
		render_wall(size.x-1,rel_y)
	render_roof()
	
	for e in spawns.values():
		if e is Dictionary:
			create_entity.emit(e)
		
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
	
