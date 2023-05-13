extends Resource

class_name Dungeon_Level

var tiles = []
var rooms = []
var max_rooms : int = 100
var min_size = 6
var max_size = 10
var size = Vector2.ZERO
var first_room_center #dont set type so can check for null
var is_bottom_floor = false

func _init(length,width):
	size = Vector2(length,width)
	for t in size.x:
		var walls = []
		walls.resize(width)
		walls.fill(Dungeon_Builder.TILE.WALL)
		tiles.append(walls)

func build():
	if not first_room_center == null:
		build_first_room()
	for r in max_rooms:
		var w = RNG.randi_range(min_size,max_size)
		var h = RNG.randi_range(min_size,max_size)
		var x = RNG.randi_range(1,size.x-w-1)
		var y = RNG.randi_range(1,size.y-h-1)
		var new_room = Room.new(x,y,w,h)
		var valid = true
		for other_room in rooms:
			if new_room.intersects(other_room):
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
	if not is_bottom_floor:
		var last_room = rooms[-1]
		var lr_center = last_room.get_center()
		tiles[lr_center.x][lr_center.y] = Dungeon_Builder.TILE.STAIR_OPENING
		tiles[lr_center.x][lr_center.y+1] = Dungeon_Builder.TILE.STAIR_OPENING
	if not first_room_center == null:
		tiles[first_room_center.x][first_room_center.y]  = Dungeon_Builder.TILE.UP_STAIRS_LOWER
		tiles[first_room_center.x][(first_room_center.y)+1]  = Dungeon_Builder.TILE.UP_STAIRS_UPPER

func build_first_room():
	var w = min_size
	var h = min_size
	var x = first_room_center.x - w/2
	var y = first_room_center.y - h/2
	var first_room = Room.new(x,y,w,h)
	apply_room_to_map(first_room)
	rooms.append(first_room)
	
func apply_room_to_map(room:Room):
# transfer to two-dimensional array first because hallways overlap the rooms and 
# i dont want to spawn multiple floor tiles
	for x in room.rect.size.x:
		for y in room.rect.size.y:
			tiles[x+room.rect.position.x][y+room.rect.position.y] = Dungeon_Builder.TILE.FLOOR

func apply_horizontal_tunnel(x1:int,x2:int,y:int) :
	for x in range(min(x1,x2),max(x1,x2)+1) :
		tiles[x][y] = Dungeon_Builder.TILE.FLOOR

func apply_vertical_tunnel(y1:int,y2:int,x:int):
	for y in range(min(y1,y2),max(y1,y2)+1):
		tiles[x][y] = Dungeon_Builder.TILE.FLOOR
