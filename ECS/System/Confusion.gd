extends System
class_name Confusion_System

static func run(delta:float, ECS:Entity_Component_System):
	for e_id in ECS.list_entity_with("confused"):
		var entity = ECS.get_entity(e_id)
		#move in a random direction
		var direction = Vector3(randf()-0.5,0,randf()-0.5).normalized()
		var velocity = direction * entity.movement_speed
		ECS.add_component(e_id,"move",velocity)
		entity.confused -= delta
		if entity.confused < 0:
			ECS.remove_component(e_id,"confused")
