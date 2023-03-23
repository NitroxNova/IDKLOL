extends System
class_name Damage_System

static func run(delta:float,ECS:Entity_Component_System):
	for e_id in ECS.list_entity_with("suffer_damage"):
		var entity = ECS.get_entity(e_id)
		if "health" in entity:
			for amount in entity.suffer_damage:
				entity.health.current -= amount
		ECS.remove_component(e_id,"suffer_damage")

# -------------------- called from outside the class --------------------#

static func queue_damage(t_id:int,amount:float,ECS:Entity_Component_System):
	var target = ECS.get_entity(t_id)
	if "suffer_damage" in target:
		target.suffer_damage.append(amount)
	else:
		ECS.add_component(t_id,"suffer_damage",[amount])
