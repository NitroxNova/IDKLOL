extends Resource
class_name Map_Builder

enum TILE_TYPE {none, grass, shallow_water, deep_water, pier, wall, gravel,road, wood_floor, door,building,tree}
var solid_tile_types = [TILE_TYPE.wall,TILE_TYPE.tree]
var size : Vector2
var tiles = []
var state : State
var position : Vector2
var starting_position : Vector3
var exit_position : Vector2
var theme = {}
var astar

signal create_entity

func set_size(width,h,tile=TILE_TYPE.none):
	size = Vector2(width,h)
	tiles = []
	for x in width:
		var row = []
		row.resize(h)
		row.fill(tile)
		tiles.append(row)

func fill(tile):
	for x in size.x:
		tiles[x].fill(tile)

func get_idx(x,y):
	var idx = y * size.x + x
	return idx
	
func set_position(x,y):
	position = Vector2(x,y)

func get_starting_position():
	return starting_position
	
			
func generate_astar():
	astar = AStar2D.new()
	astar.reserve_space(size.x*size.y)
	for x in size.x:
		for y in size.y:
			var idx = get_idx(x,y)
			astar.add_point(idx,Vector2(x,y))
			if x > 0:
				astar.connect_points(idx,get_idx(x-1,y))
			if y > 0:
				astar.connect_points(idx,get_idx(x,y-1))
			if tiles[x][y] in solid_tile_types:	
				astar.set_point_disabled(idx)

func render():
	for rel_x in size.x:
		var x = rel_x + position.x
		for rel_y in size.y:
			var y = rel_y + position.y
			var tile = tiles[rel_x][rel_y]
#			print(tile)
			if not tile == TILE_TYPE.building:
				var data = {}
				data.needs_render = true
				data.position = Vector3(x,0,y)
				if tile == TILE_TYPE.grass:
					data.renderable = Renderable.GROUND
					data.material = Material_3D.GRASS
					data.name = "Grass"
				elif tile == TILE_TYPE.gravel:
					data.renderable = Renderable.GROUND
					data.material = Material_3D.GRAVEL
					data.name = "Gravel"
				elif tile == TILE_TYPE.road:
					data.renderable = Renderable.GROUND
					data.material = Material_3D.ROAD
					data.name = "Road"
				elif tile == TILE_TYPE.shallow_water:
					data.renderable = Renderable.SHALLOW_WATER
					data.name = "Shallow Water"
					data.position.y = -.33
				elif tile == TILE_TYPE.deep_water:
					data.renderable = Renderable.DEEP_WATER
					data.name = "Deep Water"
					data.position.y = -.33
				elif tile == TILE_TYPE.wood_floor:
					data.renderable = Renderable.FLOOR
					data.material = Material_3D.WOOD
				elif tile == TILE_TYPE.door:
					data.renderable = Renderable.FLOOR
					data.material = Material_3D.WOOD
				elif tile == TILE_TYPE.wall:
					data.renderable = Renderable.WALL
				elif tile == TILE_TYPE.tree:
					data.renderable = Renderable.TREE
					data.rotation = Vector3(0,randf_range(0,2*PI),0)
					data.scale = Vector3(1,1,1) * randf_range(.5,2)
					var g_data = {}
					g_data.renderable = Renderable.GROUND
					g_data.material = Material_3D.GRASS
					g_data.name = "Grass"
					g_data.needs_render = true
					g_data.position = Vector3(x,0,y)
					emit_signal("create_entity",g_data)
				emit_signal("create_entity",data)
