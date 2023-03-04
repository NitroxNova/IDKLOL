extends System
class_name Check_For_Dead_System

static func run(delta:float,state:State):
	var ECS = state.ECS
	for e_id in ECS.list_entity_with("health"):
		var entity = ECS.get_entity(e_id)
		if not "dead" in entity:
			if entity.health.current <= 0:
				state.emit_signal("log_message",entity.name + " has died")
				ECS.add_component(e_id,"dead",true)
				var node = entity.rendered
				node.position.y = -0.2
