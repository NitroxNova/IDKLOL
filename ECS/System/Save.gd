extends System
class_name Save_System

static func save(state:State):
	var ECS = state.ECS
	var save_data = ECS.entity.duplicate(true)
	for entity in save_data.values():
		if "rendered" in entity:
			entity.needs_render = entity.rendered.position
			entity.erase("rendered")
		if "needs_render" in entity:
			var pos = entity.needs_render
			entity.needs_render = [pos.x, pos.y, pos.z]
	DirAccess.make_dir_absolute("user://save")
	var file = FileAccess.open(state.save_file, FileAccess.WRITE)
	file.store_line(JSON.stringify(save_data))
	file.store_32(state.current_player)
	file.close()

static func load_file(state:State):
	var file_name = state.save_file
	var ECS = state.ECS
	var file = FileAccess.open(state.save_file, FileAccess.READ)
	var json = JSON.new()
	var parse_result = json.parse(file.get_line())
	if parse_result == OK:
		var data = json.get_data()
	#	print(data)
		for e_id in data:
			var entity = data[e_id]
			if "needs_render" in entity:
				var pos = entity.needs_render
				entity.needs_render = Vector3(pos[0],pos[1],pos[2])
			ECS.load_entity(int(e_id),entity)
		var current_id = file.get_32()
		state.current_player = current_id
