extends Map_Builder
class_name Town_Builder


var min_build_size = 6
var max_build_size = 12
var available_tiles = []
var total_buildings = 12
var buildings = []
var wall_gap_y
var doors = []

func _init(width,height):
	set_size(width,height,TILE_TYPE.gravel)
	town_walls()
	main_road()
	make_buildings()
	add_doors()
	add_paths()
	for b in buildings:
		b.build()
#	render()    #call render from mapbuilder, so can connect to "create entity" signal first

func emit_create_entity(data):
	emit_signal("create_entity",data)

func main_road():
	for y in range(1,size.y-2):
		if (y > wall_gap_y-4 and y < wall_gap_y+4):
			for x in range(0,size.x):
					tiles[x][y] = TILE_TYPE.road
	
func town_walls():
	wall_gap_y = randi_range(9,size.y-10)
	for y in range(1,size.y-1):
		if not (y > wall_gap_y-4 and y < wall_gap_y+4):
			for x in range(1,size.x-1):
				available_tiles.append(Vector2(x,y))
				
func make_buildings():
	buildings = []
	while buildings.size() < total_buildings:
		var b = Town_Building.new(add_building_dimensions())
		b.connect("create_entity",emit_create_entity)
		buildings.append(b)
	#sort by size, largest to smallest	
	buildings.sort_custom(compare_buildings)
	
	buildings[0].type = Spawn.TOWN_PUB
	buildings[1].type = Spawn.TOWN_TEMPLE
	buildings[2].type = Spawn.TOWN_BLACKSMITH
	buildings[3].type = Spawn.TOWN_ALCHEMIST
	buildings[4].type = Spawn.TOWN_CLOTHIER
	
	buildings[6].type = Spawn.TOWN_HOVEL
	buildings[7].type = Spawn.TOWN_HOVEL
	buildings[8].type = Spawn.TOWN_HOVEL
		
	
func compare_buildings(a:Town_Building,b:Town_Building):
	if a.get_area_size() > b.get_area_size():
		return true
	return false
		
func add_building_dimensions():
	while true: #will exit when a building is returned
		var b_size = Vector2(randi_range(min_build_size,max_build_size),randi_range(min_build_size,max_build_size))
		var b_pos = Vector2(randi_range(0, size.x-b_size.x),randi_range(0, size.y-b_size.y))

	#	var building = Town_Structure.new(bx,by)
		var possible = true
		for y in range(b_pos.y,b_pos.y+b_size.y):
			for x in range(b_pos.x,b_pos.x+b_size.x):
				if not Vector2(x,y) in available_tiles:
					possible = false
		if possible:
			var building = Rect2(b_pos,b_size)
			for y in range(b_pos.y-1,b_pos.y+b_size.y+1):
				for x in range(b_pos.x-1,b_pos.x+b_size.x+1):
					available_tiles.erase(Vector2(x,y))
			for y in range(b_pos.y,b_pos.y+b_size.y):
				for x in range(b_pos.x,b_pos.x+b_size.x):
					tiles[x][y] = TILE_TYPE.building
			return building

func add_doors():
	doors = []
	for building in buildings:
		if building.get_center().y > wall_gap_y:
			#door on the north wall
			building.add_door("north")
		else:
			building.add_door("south")
		doors.append(building.door + building.position)

func add_paths():
	var astar = AStar2D.new()
	astar.reserve_space(size.x*size.y)
	var roads = []
	for x in size.x:
		for y in size.y:
			var idx = get_idx(x,y)
			astar.add_point(idx,Vector2(x,y))
			if x > 0:
				astar.connect_points(idx,get_idx(x-1,y))
			if y > 0:
				astar.connect_points(idx,get_idx(x,y-1))
			astar.set_point_disabled(idx)
			if tiles[x][y] == TILE_TYPE.road:
				roads.append(Vector2(x,y))
				astar.set_point_disabled(idx,false)
			elif tiles[x][y] == TILE_TYPE.gravel:
				astar.set_point_disabled(idx,false)
#			elif tiles[x][y] == TILE_TYPE.door:
#				astar.set_point_disabled(idx,false)

	for door in doors:
		var nearest_road = roads[0]
		var nearest_distance = 999999
		for road in roads:
			var distance_to_road = door.distance_to(road)
#			var distance_to_road = astar.get_point_path(get_idx(road.x,road.y),get_idx(door.x,door.y)).size()
			if distance_to_road < nearest_distance:
				nearest_road = road
				nearest_distance = distance_to_road
#		var from_id = get_idx(door.x,door.y)
		var from_id = astar.get_closest_point(door)
		var to_id = get_idx(nearest_road.x,nearest_road.y)
		var path = astar.get_point_path(from_id,to_id)
#		print(astar.has_point(to_id))
#		print(path)
		for point in path:
			tiles[point.x][point.y] = TILE_TYPE.road
			roads.append(point)
			
		
func get_starting_position():
#	var x = 70
#	x = 10
#	var z = wall_gap_y
#	return Vector3(x,0,z) + Vector3(position.x,0,position.y)
	#start the player at the pub
	var pub_center = buildings[0].get_center()
	starting_position = Vector3(pub_center.x,0,pub_center.y)
	return starting_position
	
func render():
	for building in buildings:
		building.render()
	render_walls()
	super()
	
func render_walls():
#	print(wall_gap_y)
	var wall_gap_percent = (wall_gap_y+.5)/(size.y)
	render_wall_with_entrance(Vector3(0,0,0),Vector3(0,0,size.y-1),wall_gap_percent)
	render_wall_with_entrance(Vector3(size.x-1,0,0),Vector3(size.x-1,0,size.y-1),wall_gap_percent)
	render_wall(Vector3(0,0,0),Vector3(size.x-1,0,0))
	render_wall(Vector3(0,0,size.y-1),Vector3(size.x-1,0,size.y-1))
	
func render_wall(start_pos:Vector3,end_pos:Vector3):
	var segment_length = 2
	var total_length = start_pos.distance_to(end_pos)
	var segment_count = total_length/segment_length
	var wall_rotation = (start_pos-end_pos).angle_to(Vector3.FORWARD)
#	print(wall_rotation)
	for i in segment_count:
		var data = {}
		data.renderable = Renderable.STONE_WALL_TOP
		data.position = lerp(start_pos,end_pos,i/segment_count)
		data.needs_render = true
		data.rotation = Vector3(0,wall_rotation,0)
		data.scale = Vector3(1,2,1)
		emit_signal("create_entity",data)		

func render_wall_with_entrance(start_pos:Vector3,end_pos:Vector3,gap_percent:float):
#	print(gap_percent)
	var gap_position = lerp(start_pos,end_pos,gap_percent)
	var wall_rotation = (start_pos-end_pos).angle_to(Vector3.FORWARD)
	var data = {}
	data.renderable = Renderable.STONE_WALL_ENTRANCE
	data.position = gap_position
	data.needs_render = true
	data.rotation = Vector3(0,wall_rotation,0)
	data.scale = Vector3(1,1,3)
	emit_signal("create_entity",data)	
	
	var gap_start = lerp(start_pos,end_pos,gap_percent-.08)
	var gap_end = lerp(start_pos,end_pos,gap_percent+.08)
	render_wall(gap_start,start_pos)
	render_wall(gap_end,end_pos)
		
