extends Resource
class_name Dungeon_Builder

var state : State
var size = Vector2.ZERO
var rooms = []
var max_rooms = 100
var min_size = 6
var max_size = 10
var max_monsters = 4
var tiles = []
enum TILE {FLOOR,WALL}

func _init(length,width,state:State):
	self.state = state
	size = Vector2(length,width)
	fill_walls()
	generate_rooms()
	render()
	
func spawn_monster(pos:Vector3):
#	var monster = state.ECS.create_entity()
	var data = {}
	data.needs_render = pos
	data.monster = true
	data.viewshed = 16
	data.health = {current=16.0,maximum=16.0}
	data.combat_stats = {power=3.0,defense=1.0}
	if randf() < .5:
		spawn_orc(data)
	else:
		spawn_goblin(data)
	var monster_id = state.ECS.create_entity(data)
	var monster = state.ECS.get_entity(monster_id)
	monster.name += " " + str(monster_id)

func spawn_orc(data:Dictionary):
	data.renderable = "res://Game/Entity/Orc.tscn"
	data.name = "Orc"

func spawn_goblin(data:Dictionary):
	data.renderable = "res://Game/Entity/Goblin.tscn"
	data.name = "Goblin"
	
func generate_rooms():
	for r in max_rooms:
		var w = RNG.randi_range(min_size,max_size)
		var h = RNG.randi_range(min_size,max_size)
		var x = RNG.randi_range(1,size.x-w-1)
		var y = RNG.randi_range(1,size.y-h-1)
		var new_room = Rect2(x,y,w,h)
		var valid = true
		for other_room in rooms:
			if new_room.intersects(other_room,true):
				valid = false
		if valid:
			if not rooms.is_empty():
				var new_center = new_room.get_center()
				var prev_center = rooms[rooms.size()-1].get_center()
				if randf() < .5:
					apply_horizontal_tunnel(prev_center.x,new_center.x,prev_center.y)
					apply_vertical_tunnel(prev_center.y,new_center.y,new_center.x)
				else:
					apply_vertical_tunnel(prev_center.y,new_center.y,prev_center.x)
					apply_horizontal_tunnel(prev_center.x,new_center.x,new_center.y)
			apply_room_to_map(new_room)
			rooms.append(new_room)
	
func apply_room_to_map(room:Rect2):
	for x in room.size.x:
		for y in room.size.y:
			tiles[x+room.position.x][y+room.position.y] = TILE.FLOOR

func apply_horizontal_tunnel(x1:int,x2:int,y:int) :
	for x in range(min(x1,x2),max(x1,x2)+1) :
		tiles[x][y] = TILE.FLOOR


func apply_vertical_tunnel(y1:int,y2:int,x:int):
	for y in range(min(y1,y2),max(y1,y2)+1):
		tiles[x][y] = TILE.FLOOR

func fill_walls():
	for x in size.x:
		var row = []
		for y in size.y:
			row.append(TILE.WALL)
		tiles.append(row)
	
func render():
	for x in size.x:
		for y in size.y:
			var tile = tiles[x][y]
			var model_path = ""
			if tile == TILE.FLOOR:
				model_path = "res://Game/Entity/Floor.tscn"
			elif tile == TILE.WALL:
				model_path = "res://Game/Entity/Wall.tscn"
			var data = {}
			data.renderable = model_path
			data.needs_render = Vector3(x*2,0,y*2)
			var entity = state.ECS.create_entity(data)
	for room in rooms:
		#dont spawn monsters in first room
		if room != rooms[0]:
			var m_count = RNG.randi_range(0,max_monsters)
			for m in m_count:
				var spawn_x = RNG.randf_range(room.position.x+1,room.position.x+room.size.x-1)
				var spawn_z = RNG.randf_range(room.position.y+1,room.position.y+room.size.y-1)
				spawn_monster(Vector3(spawn_x*2,.5,spawn_z*2))
