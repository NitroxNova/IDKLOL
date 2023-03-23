extends System
class_name Combat_System

static func run(delta:float, ECS:Entity_Component_System):
	run_melee_hit(delta,ECS)
	run_ranged_hit(delta,ECS)

static func run_melee_hit(delta:float, ECS:Entity_Component_System):
	for e_id in ECS.list_entity_with("melee_hit"):
		var entity = ECS.get_entity(e_id)
		for t_id in entity.melee_hit:
			var target = ECS.get_entity(t_id)
			if "combat_stats" in target:
				var damage = entity.combat_stats.power-target.combat_stats.defense
				if damage > 0:
					Damage_System.queue_damage(t_id,damage,ECS)
					var message = entity.name + " hit " + target.name + " for " + str(damage) + " damage"
					ECS.emit_signal("log_message",message)
		ECS.remove_component(e_id,"melee_hit")
	
static func run_ranged_hit(delta:float, ECS:Entity_Component_System):
	for e_id in ECS.list_entity_with("ranged_hit"):
		var entity = ECS.get_entity(e_id)
		for t_id in entity.ranged_hit:
			var target = ECS.get_entity(t_id)
			if "inflicts_damage" in entity:
				var damage = entity.inflicts_damage
				Damage_System.queue_damage(t_id,damage,ECS)
				var message = entity.name + " hit " + target.name + " for " + str(damage) + " damage"
				ECS.emit_signal("log_message",message)
			if "inflicts_confusion" in entity and "health" in target:
				ECS.add_component(t_id,"confused",entity.inflicts_confusion)
	
	
