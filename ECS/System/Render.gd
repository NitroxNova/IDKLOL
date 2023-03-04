extends System
class_name Render_System

static func run(delta:float,state:State):
#	print("run needs render system")
	var ECS = state.ECS
	for e_id in ECS.list_entity_with("needs_render"):
#		print(str(e_id)+" needs render")
		var entity = ECS.get_entity(e_id)
		var node = load(entity.renderable).instantiate()
		node.e_id = e_id
		node.position = entity.needs_render
		if "player" in entity:
			node.add_child(load("res://Game/Player_Camera.tscn").instantiate())
		if "viewshed" in entity:
			var v_node = load("res://Game/Viewshed.tscn").instantiate()
			v_node.set_radius(entity.viewshed)
			node.add_child(v_node)
		state.emit_signal("render_entity",node)
		ECS.add_component(e_id,"rendered",node)
		ECS.remove_component(e_id,"needs_render")
