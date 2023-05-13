extends System
class_name Projectile_System

static func run(delta:float,ECS:Entity_Component_System):
	run_range_decrement(delta,ECS)
	run_projectile_hit(delta,ECS)
	run_summon_projectiles(delta,ECS)

static func run_range_decrement(delta:float, ECS:Entity_Component_System):
	for e_id in ECS.list_entity_with("projectile"):
		var entity = ECS.get_entity(e_id)
		if "ranged" in entity and "rendered" in entity:
			entity.ranged -= entity.rendered.linear_velocity.length() * delta
			if entity.ranged < 0:
				if "area_of_effect" in entity: #trigger aoe even if fireball doesnt hit anything
					ECS.add_component(e_id,"summoning_area_of_effect",true)
				ECS.add_component(e_id,"needs_removal",true)
	
static func run_projectile_hit(delta:float, ECS:Entity_Component_System):
	for e_id in ECS.list_entity_with("projectile_hit"):
		var entity = ECS.get_entity(e_id)
		var hit_id = entity.projectile_hit
		if "area_of_effect" in entity:
#			print("area of effect")
			ECS.add_component(e_id,"summoning_area_of_effect",true)
		else:	
			ECS.add_component(e_id,"ranged_hit",[hit_id])
		ECS.add_component(e_id,"needs_removal",true)

static func run_summon_projectiles(delta:float, ECS:Entity_Component_System):
	for e_id in ECS.list_entity_with("summoning_projectile"):
		var entity = ECS.get_entity(e_id)
		var item_id = entity.summoning_projectile
		var item = ECS.get_entity(item_id)
		var p_data = {}
		p_data.renderable = item.summons_projectile.scene
		p_data.name = item.summons_projectile.name
		
		p_data.needs_render = {}
		p_data.needs_render.position=entity.rendered.get_node("Hands").global_position
		var dir_facing_node = entity.rendered.get_node("Direction_Facing")
		p_data.rotation=dir_facing_node.global_rotation
		var direction = dir_facing_node.global_transform.basis.z
		p_data.needs_render.linear_velocity = direction.normalized() * item.summons_projectile.speed
		
		p_data.projectile = true
		p_data.ranged = item.ranged
		if "inflicts_damage" in item:
			p_data.inflicts_damage = item.inflicts_damage
		if "area_of_effect" in item:
			p_data.area_of_effect = item.area_of_effect
		if "inflicts_confusion" in item:
			p_data.inflicts_confusion = item.inflicts_confusion
		var p_entity_id = ECS.create_entity(p_data)
		
		ECS.remove_component(e_id,"summoning_projectile")
