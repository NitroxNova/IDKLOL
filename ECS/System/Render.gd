extends System
class_name Render_System

static func run(delta:float, ECS:Entity_Component_System):
#	print("run needs render system")
	render(delta,ECS)
	unrender(delta,ECS)

static  func unrender(delta:float, ECS:Entity_Component_System):
	for e_id in ECS.list_entity_with("needs_unrender"):
		var entity = ECS.get_entity(e_id)
		entity.rendered.queue_free()
		ECS.remove_component(e_id,"rendered")
		ECS.remove_component(e_id,"needs_unrender")

static func render(delta:float, ECS:Entity_Component_System):
	for e_id in ECS.list_entity_with("needs_render"):
#		print(str(e_id)+" needs render")
		var entity = ECS.get_entity(e_id)
		var node = Renderable.new_scene(entity.renderable)
		node.e_id = e_id
		node.position = entity.position
		if "rotation" in entity:
			node.rotation = entity.rotation
			ECS.remove_component(e_id,"rotation")
		if "linear_velocity" in entity:
			node.linear_velocity = entity.linear_velocity
			ECS.remove_component(e_id,"linear_velocity")
		if "scale" in entity:
			node.scale = entity.scale
			ECS.remove_component(e_id,"scale")
		if "viewshed" in entity:
			var v_node = load("res://Game/Viewshed.tscn").instantiate()
			v_node.set_radius(entity.viewshed)
			node.add_child(v_node)
		if "material" in entity:
			node.set_material(entity.material)
		node.connect("body_entered",Callable(Collision_System,"body_entered").bind(node,ECS))
		ECS.remove_component(e_id,"position")
		if "clothes" in entity:
			for c in entity.clothes:
				node.take_on_clothes(c)
		if "genotype" in entity:
#			print(entity.genotype)
			node.appearance = entity.genotype
			node.generate_all_meshs()
		ECS.emit_signal("render_entity",node)
		ECS.add_component(e_id,"rendered",node)
		if "player" in entity:
			node.get_node("Direction_Facing").add_child(load("res://Game/Player_Camera.tscn").instantiate())
			ECS.emit_signal("update_camera")
		ECS.remove_component(e_id,"needs_render")
			
			
	
