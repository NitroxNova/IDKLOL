extends Resource
class_name Dungeon_Builder

var state : State
var size = Vector2.ZERO
var rooms = []
var max_rooms = 100
var min_size = 6
var max_size = 10
var max_monsters = 4
#var max_items = 2
var max_items = 4
var tiles = []
enum TILE {FLOOR,WALL}

func _init(length,width,state:State):
	self.state = state
	size = Vector2(length,width)
	fill_walls()
	generate_rooms()
	render()
	
func generate_rooms():
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
	
func apply_room_to_map(room:Room):
	# transfer to two-dimensional array first because hallways overlap the rooms and 
	# i dont want to spawn multiple floor tiles
	for x in room.rect.size.x:
		for y in room.rect.size.y:
			tiles[x+room.rect.position.x][y+room.rect.position.y] = TILE.FLOOR

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
			var data = {}
			if tile == TILE.FLOOR:
				data.renderable = "res://Game/Entity/Floor.tscn"
				data.name = "Stone Floor"
			elif tile == TILE.WALL:
				data.renderable = "res://Game/Entity/Wall.tscn"
				data.name = "Brick Wall"
			data.needs_render = {position=Vector3(x*2,0,y*2),rotation=Vector3.ZERO}
			state.ECS.create_entity(data)
			if tile == TILE.FLOOR:
				var c_data = {} #ceiling data
				c_data.renderable = "res://Game/Entity/Ceiling.tscn"
				c_data.name = "Wood Ceiling"
				c_data.needs_render = {position=Vector3(x*2,3.5,y*2),rotation=Vector3.ZERO}
				state.ECS.create_entity(c_data)
				
	for room in rooms:
		#dont spawn monsters in first room
		if room != rooms[0]:
			room.spawn_points(max_monsters,max_items)
			for m_pos in room.monster_spawn_points:
				spawn_monster(Vector3(m_pos.x*2,.5,m_pos.y*2))
			for i_pos in room.item_spawn_points:
				spawn_item(Vector3(i_pos.x*2,0,i_pos.y*2))
				
func spawn_monster(pos:Vector3):
#	var monster = state.ECS.create_entity()
	var data = {}
	data.needs_render = {position=pos,rotation=Vector3.ZERO}
	data.monster = true
	data.viewshed = 16
	data.health = {current=16.0,maximum=16.0}
	data.combat_stats = {power=3.0,defense=1.0}
	data.movement_speed = 3.0
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

func spawn_item(pos:Vector3):
	var data = {}
	data.needs_render = {position=pos,rotation=Vector3.ZERO}
	data.item = true
	var roll = randi_range(1,4)
	match roll:
		1:
			spawn_health_potion(data)
		2:
			spawn_magic_missile_scroll(data)
		3:
			spawn_fireball_scroll(data)
		4:
			spawn_confusion_scroll(data)
	var item_id = state.ECS.create_entity(data)

func spawn_health_potion(data:Dictionary):
	data.renderable = "res://Game/Entity/Health_Potion.tscn"
	data.name = "Health Potion"
	data.consumable = true
	data.provides_healing = 10.0

func spawn_magic_missile_scroll(data:Dictionary):
	data.renderable = "res://Game/Entity/Magic_Missile_Scroll.tscn"
	data.name = "Magic Missile Scroll"
	data.inflicts_damage = 20.0
	data.consumable = true
	data.ranged = 12.0
	data.summons_projectile = {scene="res://Game/Entity/Spell/Magic_Missile.tscn", name="Magic Missile", speed=10.0}
	
func spawn_fireball_scroll(data:Dictionary):
	data.renderable = "res://Game/Entity/Fireball_Scroll.tscn"
	data.name = "Fireball Scroll"
	data.inflicts_damage = 20.0
	data.consumable = true
	data.ranged = 12.0
	data.summons_projectile = {scene="res://Game/Entity/Spell/Fireball.tscn", name="Fireball", speed=10.0}
	data.area_of_effect = {radius=3.0,particles="res://Game/Entity/Spell/Fireball_Explosion.tscn"}

func spawn_confusion_scroll(data:Dictionary):
	data.renderable = "res://Game/Entity/Confusion_Scroll.tscn"
	data.name = "Confusion Scroll"
	data.consumable = true
	data.ranged = 12.0
	data.summons_projectile = {scene="res://Game/Entity/Spell/Confusion.tscn", name="Confusion Bolt", speed=10.0}
	data.inflicts_confusion = 4.0
	
	
	
	
