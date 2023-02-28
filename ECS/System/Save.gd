extends System
class_name Save_System

static func save(state:State):
	var ECS = state.ECS
	var save_data = ECS.entity.duplicate(true)
	for entity in save_data.values():
		if "rendered" in entity:
			entity.needs_render = entity.rendered.translation
			entity.erase("rendered")
		if "needs_render" in entity:
			var pos = entity.needs_render
			entity.needs_render = [pos.x, pos.y, pos.z]
	#check for save directory
	var dir = Directory.new()
	dir.open("user://")
	if not dir.dir_exists("save"):
#		print("no save directory")
		dir.make_dir("save")
	var file = File.new()
	file.open(state.save_file, File.WRITE)
	file.store_line(JSON.print(save_data))
	file.store_32(state.current_player)
	file.close()

static func load_file(state:State):
	var file_name = state.save_file
	var ECS = state.ECS
	var file = File.new()
	file.open(file_name, File.READ)
	var data = JSON.parse(file.get_line()).result
#	print(data)
	for e_id in data:
		var entity = data[e_id]
		if "needs_render" in entity:
			var pos = entity.needs_render
			entity.needs_render = Vector3(pos[0],pos[1],pos[2])
		ECS.load_entity(int(e_id),entity)
	var current_id = file.get_32()
	state.current_player = current_id
