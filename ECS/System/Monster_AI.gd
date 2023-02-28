extends System
class_name Monster_AI_System

static func run(delta:float, state:State):
	var ECS = state.ECS
	for e_id in ECS.list_entity_with("monster"):
		var entity = ECS.get_entity(e_id)
		if not "dead" in entity:
			var node = entity.rendered
			var viewshed = node.get_node("Viewshed")
			for body in viewshed.get_overlapping_bodies():
				var b_entity = ECS.get_entity(body.e_id)
				if "player" in b_entity and not "dead" in b_entity:
					if Visibility_System.is_visible(node,body):
						var move_dir = node.global_translation.direction_to(body.global_translation)
						ECS.add_component(e_id,"move",move_dir*8)
