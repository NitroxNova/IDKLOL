extends System
class_name Combat_System

static func run(delta:float, state:State):
	var ECS = state.ECS
	for e_id in ECS.list_entity_with("melee_hit"):
		var entity = ECS.get_entity(e_id)
		for t_id in entity.melee_hit:
			var target = ECS.get_entity(t_id)
			var damage = entity.combat_stats.power-target.combat_stats.defense
			if damage > 0:
				Damage_System.queue_damage(t_id,damage,state)
				var message = entity.name + " hit " + target.name + " for " + str(damage) + " damage"
				state.emit_signal("log_message",message)
		ECS.remove_component(e_id,"melee_hit")
