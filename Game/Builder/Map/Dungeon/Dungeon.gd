extends Resource
class_name Dungeon_Builder

var state : State
var size = Vector3.ZERO
enum TILE {FLOOR,WALL,UP_STAIRS_UPPER,UP_STAIRS_LOWER,STAIR_OPENING}
var levels = []
var max_monsters = 4
#var max_items = 2
var max_items = 4

func _init(length,width,depth,state:State):
	self.state = state
	size = Vector3(length,width,depth)
	for i in depth:
		generate_level(i)
	render()
	
func generate_level(depth:int):
	var level = Dungeon_Level.new(size.x, size.y)
	if depth != 0:
		level.first_room_center = levels[depth-1].rooms[-1].get_center()
	if depth == size.z - 1:
			level.is_bottom_floor = true
	level.build()
	levels.append(level)
	
func render():
	for l in levels.size():
		var level = levels[l]
		var depth = l * 3.7
		for x in size.x:
			for y in size.y:
				var tile = level.tiles[x][y]
				var data = {}
				if tile == TILE.FLOOR or tile == TILE.UP_STAIRS_LOWER:
					data.renderable = "res://Game/Entity/Floor.tscn"
					data.name = "Stone Floor"
				elif tile == TILE.WALL:
					data.renderable = "res://Game/Entity/Wall.tscn"
					data.name = "Brick Wall"
				elif tile == TILE.UP_STAIRS_UPPER:
					data.renderable = "res://Game/Entity/stairs.tscn"
					data.name = "Stairs"
				if not tile == TILE.STAIR_OPENING :
					data.needs_render = {position=Vector3(x*2,0-depth,y*2),rotation=Vector3.ZERO}
					state.ECS.create_entity(data)
				if tile == TILE.FLOOR or tile == TILE.STAIR_OPENING:
					var c_data = {} #ceiling data
					c_data.renderable = "res://Game/Entity/Ceiling.tscn"
					c_data.name = "Wood Ceiling"
					c_data.needs_render = {position=Vector3(x*2,3.5-depth,y*2),rotation=Vector3.ZERO}
					state.ECS.create_entity(c_data)
		for r in level.rooms.size():
			var room = level.rooms[r]
			#dont spawn monsters in first room
			if r != 0:
				room.spawn_points(max_monsters,max_items)
				for m_pos in room.monster_spawn_points:
					spawn_monster(Vector3(m_pos.x*2,0-depth,m_pos.y*2))
				for i_pos in room.item_spawn_points:
					spawn_item(Vector3(i_pos.x*2,0-depth,i_pos.y*2))
				
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

