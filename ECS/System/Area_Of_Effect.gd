extends System
class_name Area_Of_Effect_System

static func run(delta:float,ECS:Entity_Component_System):
	run_summon_aoe(delta,ECS)

static func run_summon_aoe(delta:float,ECS:Entity_Component_System):
	for e_id in ECS.list_entity_with("summoning_area_of_effect"):
		var entity = ECS.get_entity(e_id)
#		print("aoe summoned")
		var p_data = {} #particle effect data
		p_data.name = entity.name + " AOE"
		p_data.duration = 2.0
		p_data.needs_render = {position=entity.rendered.global_position,rotation=Vector3.ZERO}
		p_data.renderable = entity.area_of_effect.particles
		ECS.create_entity(p_data)
		
		var targets = []
		var query = PhysicsShapeQueryParameters3D.new()
		var shape = SphereShape3D.new()
		shape.radius = entity.area_of_effect.radius
		query.shape = shape
		query.transform = entity.rendered.global_transform
		query.exclude.append(entity.rendered)
		var space_state = entity.rendered.get_world_3d().direct_space_state
		var result = space_state.intersect_shape(query)
		for r in result:
#			print(r)
			targets.append(r.collider.e_id)
		ECS.add_component(e_id,"ranged_hit",targets)
