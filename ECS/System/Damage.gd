extends System
class_name Damage_System

static func run(delta:float,state:State):
	var ECS = state.ECS
	for e_id in ECS.list_entity_with("suffer_damage"):
		var entity = ECS.get_entity(e_id)
		for amount in entity.suffer_damage:
			entity.health.current -= amount
			if "player" in entity:
				state.emit_signal("player_health",entity.health.current)
		ECS.remove_component(e_id,"suffer_damage")

# -------------------- called from outside the class --------------------#

static func queue_damage(t_id:int,amount:float,state:State):
	var target = state.ECS.get_entity(t_id)
	if "suffer_damage" in target:
		target.suffer_damage.append(amount)
	else:
		state.ECS.add_component(t_id,"suffer_damage",[amount])
