extends System
class_name Healing_System

static func run(delta:float,ECS:Entity_Component_System):
	for e_id in ECS.list_entity_with("receive_healing"):
		var entity = ECS.get_entity(e_id)
		for amount in entity.receive_healing:
			entity.health.current += amount
		if entity.health.current > entity.health.maximum:
			entity.health.current = entity.health.maximum
		ECS.remove_component(e_id,"receive_healing")

# -------------------- called from outside the class --------------------#

static func queue_healing(t_id:int,amount:float,ECS:Entity_Component_System):
	var target = ECS.get_entity(t_id)
	if "receive_healing" in target:
		target.receive_healing.append(amount)
	else:
		ECS.add_component(t_id,"receive_healing",[amount])
