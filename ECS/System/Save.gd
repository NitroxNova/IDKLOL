extends System
class_name Save_System

static func save(ECS:Entity_Component_System, file_name:String, current_player:int):
	var save_data = ECS.entity.duplicate(true)
	for entity in save_data.values():
		if "rendered" in entity:
			entity.needs_render = {}
			entity.needs_render.position = entity.rendered.position
			entity.needs_render.rotation = entity.rendered.rotation
			if entity.rendered is RigidBody3D:
				entity.needs_render.linear_velocity = entity.rendered.linear_velocity
			entity.erase("rendered")
	DirAccess.make_dir_absolute("user://save")
	var file = FileAccess.open(file_name, FileAccess.WRITE)
	file.store_line(JSON.stringify(save_data))
	file.store_32(current_player)
	file.close()

static func load_file(ECS:Entity_Component_System, file_name:String):
	var file = FileAccess.open(file_name, FileAccess.READ)
	var json = JSON.new()
	var parse_result = json.parse(file.get_line())
	if parse_result == OK:
		var data = json.get_data()
	#	print(data)
		for e_id in data:
			var entity = data[e_id]
			if "needs_render" in entity:
				entity.needs_render.position = string_to_vector3(entity.needs_render.position)
				print(entity.needs_render.position)
				entity.needs_render.rotation = string_to_vector3(entity.needs_render.rotation)
				if "linear_velocity" in entity.needs_render:
					entity.needs_render.linear_velocity = string_to_vector3(entity.needs_render.linear_velocity)
			if "inventory" in entity:
				for i in entity.inventory.size():
					entity.inventory[i] = int(entity.inventory[i])					
			ECS.load_entity(int(e_id),entity)
		var current_id = file.get_32()
		return current_id #return the current player id
#		print(ECS.entity)

static func string_to_vector3(string:String):
	string = string.lstrip("(")
	string = string.rstrip(")")
	var floats = string.split_floats(",")
	var vec3 = Vector3(floats[0],floats[1],floats[2])
	return vec3







