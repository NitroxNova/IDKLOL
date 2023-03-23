extends System
class_name Move_System

static func run(delta:float, ECS:Entity_Component_System):
	for e_id in ECS.list_entity_with("move"):
		var entity = ECS.get_entity(e_id)
		var node : CharacterBody3D = entity.rendered
		node.set_velocity(entity.move)
		node.set_up_direction(Vector3.UP)
		node.move_and_slide()
		node.velocity
		ECS.remove_component(e_id,"move")
		
		if not "dead" in entity:
			var targets = []
			for i in node.get_slide_collision_count():
				var c_id = node.get_slide_collision(i).get_collider().e_id
				var c_entity = ECS.get_entity(c_id)
				if not "dead" in c_entity and not c_id in targets:
					if "confused" in entity:
						if randf() < .5: #50% chance to attack anything it runs into if confused
							targets.append(c_id)
					else:
						if "player" in entity and "monster" in c_entity:
							targets.append(c_id)
						elif "monster" in entity and "player" in c_entity:
							targets.append(c_id)
				if "player" in entity and "item" in c_entity:
					ECS.emit_signal("can_pickup_item",c_id)
			if not targets.is_empty():
				ECS.add_component(e_id,"melee_hit",targets)
			
