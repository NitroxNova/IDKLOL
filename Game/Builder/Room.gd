extends Resource
class_name Room

var rect : Rect2
var monster_spawn_points : Array
var item_spawn_points : Array

func _init(x,y,w,h):
	rect = Rect2(x,y,w,h)

func intersects(other_room:Room):
	return rect.intersects(other_room.rect,true)

func get_center():
	return rect.get_center()

func spawn_points(max_monsters:int,max_items:int):
	spawn_monsters(max_monsters)
	spawn_items(max_items)

func spawn_monsters(max_monsters):
	var m_count = randi_range(0,max_monsters)
	while monster_spawn_points.size() < m_count:
		var pos = rand_spawn_pos()
		if not pos in monster_spawn_points:
			monster_spawn_points.append(pos)

func spawn_items(max_items):
	var i_count = randi_range(0,max_items)
	while item_spawn_points.size() < i_count:
		var pos = rand_spawn_pos()
		if not pos in item_spawn_points and not pos in monster_spawn_points:
			item_spawn_points.append(pos)

func rand_spawn_pos():
	var pos = Vector2i.ZERO
	pos.x = randi_range(rect.position.x,rect.end.x-1)
	pos.y = randi_range(rect.position.y,rect.end.y-1)
	return pos
	
