extends System
class_name Monster_AI_System

static func run(delta:float, ECS:Entity_Component_System):
	for e_id in ECS.list_entity_with("monster"):
		var entity = ECS.get_entity(e_id)
		if not "dead" in entity and not "confused" in entity:
			var node = entity.rendered
			var viewshed = node.get_node("Viewshed")
			for body in viewshed.get_overlapping_bodies():
				var b_entity = ECS.get_entity(body.e_id)
				if "player" in b_entity and not "dead" in b_entity:
					if Visibility_System.is_visible(node,body):
						var move_dir = node.global_position.direction_to(body.global_position).normalized()
#						move_dir += Vector3.DOWN
						if not node.is_on_floor():
							move_dir += Vector3.DOWN * 5
						ECS.add_component(e_id,"move",move_dir*entity.movement_speed)
