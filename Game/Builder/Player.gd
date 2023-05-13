extends Resource
class_name Player_Builder

var player_name : String
var position : Vector3
var state : State

func _init(p_name, pos, _state):
	player_name = p_name
	position = pos
	state = _state

func build():
	var p_data = {}
	p_data.player = true
	p_data.name = player_name
	p_data.renderable = Renderable.PLAYER
	p_data.needs_render = {rotation=Vector3.ZERO}
	p_data.position = position
	p_data.combat_stats = {power=5.0,defense=2.0}
#	p_data.health = {current=30.0,maximum=30.0}
	p_data.health = {current=300.0,maximum=300.0}
	p_data.viewshed = 16
	p_data.inventory = []
	p_data.movement_speed = 3.6 #average human run speed is 8mph for men which is about 3.5 meters per second
	return state.ECS.create_entity(p_data)
