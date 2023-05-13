extends Resource
class_name Entity_Component_System

var entity = {}
var component = {}

signal log_message
signal render_entity
signal can_pickup_item
signal update_camera

func _init():
	init_components()

func init_components():
	var c_ref = Component_Reference.new()
	for c in c_ref.component:
		component[c] = []

func create_entity(data={}):
	var id = rand_id()
	entity[id] = {}
	add_component_multi(id,data)
	return id

#dont call directly, add "needs_removal" component instead
func remove_entity(e_id):
	var l_entity = get_entity(e_id)
	for c_name in l_entity:
		component[c_name].erase(e_id)
	entity.erase(e_id)

func rand_id():
	var id = randi()
	if id in entity:
		return rand_id()
	return id

func add_component_multi(e_id:int, data:Dictionary):
	for c_name in data:
		add_component(e_id,c_name,data[c_name])

func add_component(e_id:int, c_name:String, value):
	if e_id in entity:
		var e = entity[e_id]
		if not c_name in e:
			component[c_name].append(e_id)
		e[c_name] = value
		
func load_entity(e_id:int,data:Dictionary):
	entity[e_id] = {}
	add_component_multi(e_id,data)
		
func get_entity(id:int):
	return entity[id]

func list_entity_with(c_name:String):
	#removing components will skip if not using duplicate array
	return component[c_name].duplicate()

func remove_component(e_id:int, c_name:String):
	entity[e_id].erase(c_name)
	component[c_name].erase(e_id)
	
