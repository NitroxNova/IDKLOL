extends Cellular_Automata_Map_Builder
class_name  Forest_Builder

func _init():
	set_theme(TILE_TYPE.grass,TILE_TYPE.tree)

func build():
	super()
	make_road()

func make_road():
#	for x in size.x:
#		tiles[x][starting_position.z] = TILE_TYPE.road
	var start_idx = get_idx(starting_position.x,starting_position.z)
	var end_idx = get_idx(exit_position.x,exit_position.y)
	var path = astar.get_point_path(start_idx,end_idx)
	for point in path:
		for x_i in range(-1,2):
			for y_i in range(-1,2):
				tiles[point.x+x_i][point.y+y_i] = TILE_TYPE.road
				

func calculate_starting_position():
	#starting position should already be set from world builder
	#clear trees from road start to first open clearing
#	print(starting_position)
	var s_pos = Vector3(starting_position)
	while tiles[s_pos.x][s_pos.z] == wall:
#		print("clearing wall")
		tiles[s_pos.x][s_pos.z] = floor
		s_pos.x += 1
		
		
