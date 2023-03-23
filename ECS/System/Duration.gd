extends System
class_name Duration_System

static func run(delta:float, ECS:Entity_Component_System):
	for e_id in ECS.list_entity_with("duration"):
		var entity = ECS.get_entity(e_id)
		entity.duration -= delta
		if entity.duration < 0:
			ECS.add_component(e_id,"needs_removal",true)
		
