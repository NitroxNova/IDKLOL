extends System
class_name Collision_System

# ---------------------------- called from outside the system --------------------------- #

static func body_entered(collider:CollisionObject3D,source:CollisionObject3D,ECS:Entity_Component_System):
	var s_entity = ECS.get_entity(source.e_id)
	if "projectile" in s_entity:
		ECS.add_component(source.e_id,"projectile_hit",collider.e_id)
		
