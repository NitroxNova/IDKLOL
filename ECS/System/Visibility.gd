extends System
class_name Visibility_System

static func is_visible(from:Node,to:Node):
	var space_state = from.get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(from.global_position,to.global_position,1,[from])
	var result = space_state.intersect_ray(query)
	if result: 
		if result.collider == to:
			return true
		else:
			return false
	else:
		return true
