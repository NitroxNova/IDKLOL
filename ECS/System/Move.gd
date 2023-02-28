extends System
class_name Move_System

static func run(delta:float, state:State):
	var ECS = state.ECS
	for e_id in ECS.list_entity_with("move"):
		var entity = ECS.get_entity(e_id)
		var node : KinematicBody = entity.rendered
		node.move_and_slide(entity.move,Vector3.UP)
		ECS.remove_component(e_id,"move")
		
		if not "dead" in entity:
			var targets = []
			for i in node.get_slide_count():
				var c_id = node.get_slide_collision(i).collider.e_id
				var c_entity = ECS.get_entity(c_id)
				if not "dead" in c_entity and not c_id in targets:
					if "player" in entity and "monster" in c_entity:
						targets.append(c_id)
					elif "monster" in entity and "player" in c_entity:
						targets.append(c_id)
			if not targets.empty():
				ECS.add_component(e_id,"melee_hit",targets)
			
