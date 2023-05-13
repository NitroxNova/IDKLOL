extends Map_Builder
class_name Cellular_Automata_Map_Builder

var floor = TILE_TYPE.wood_floor
var wall = TILE_TYPE.wall
var floor_percent = .55
var center_position : Vector2

func build():
	random_walls()
	for i in 15:
		cellular_automata()
	calculate_center_position()
	calculate_starting_position()
	generate_astar()
	cull_unreachable()
	find_exit()
	
func cull_unreachable():
	var start_idx = get_idx(center_position.x,center_position.y)
	for x in size.x:
		for y in size.y:
			if not tiles[x][y] == wall:
				var idx = get_idx(x,y)
				var distance = astar.get_point_path(start_idx,idx).size()
				if distance == 0:
					#unreachable
					tiles[x][y] = wall
					astar.set_point_disabled(idx)
	
func find_exit():
	var exit_distance = 0
	var start_idx = get_idx(starting_position.x,starting_position.z)
	for x in size.x:
		for y in size.y:
			if not tiles[x][y] == wall:
				var idx = get_idx(x,y)
				var distance = astar.get_point_path(start_idx,idx).size()
				if distance > exit_distance:
					exit_position = Vector2(x,y)
					exit_distance = distance

func calculate_center_position():
	var s_pos = Vector2(size.x/2,size.y/2)
	while not tiles[s_pos.x][s_pos.y] == floor:
		s_pos.x -= 1
	center_position = s_pos

func calculate_starting_position():
	starting_position = Vector3(center_position.x,0,center_position.y)

func cellular_automata():
	var new_tiles = tiles.duplicate(true)
	for x in range(1,size.x-1):
		for y in range(1,size.y-1):
			var n_count = count_neighbors(x,y)
			if n_count > 4 or n_count == 0:
				new_tiles[x][y] = wall
			else:
				new_tiles[x][y] = floor
#			print(n_count)
	tiles = new_tiles
	
func count_neighbors(x,y):
	var n_count = 0
	var nb_index = [[-1,-1],[-1,0],[-1,1],[0,-1],[0,1],[1,-1],[1,0],[1,1]]
	for t in nb_index:
		var n_x = x+t[0]
		var n_y = y+t[1]
		if tiles[n_x][n_y] == wall:
			n_count += 1
	return n_count

func random_walls():
	fill(wall)
	for x in range(1,size.x-1):
		for y in range(1,size.y-1):
			if randf() < floor_percent:
				tiles[x][y] = floor
					

func set_theme(f,w):
	floor = f
	wall = w
	theme = {floor:f,wall:w}
	
