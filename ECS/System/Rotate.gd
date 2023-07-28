extends System
class_name Rotate_System

static func run(delta:float, ECS:Entity_Component_System):
	for e_id in ECS.list_entity_with("rotate"):
		var entity = ECS.get_entity(e_id)
		var node : CharacterBody3D = entity.rendered
#		print("rotating " + entity.name)
		node.rotate_y(entity.rotate)
		ECS.remove_component(e_id,"rotate")
