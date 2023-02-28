extends System
class_name Visibility_System

static func is_visible(from:Node,to:Node):
	var space_state = from.get_world().direct_space_state
	var result = space_state.intersect_ray(from.global_translation,to.global_translation,[from],1)
	if result: 
		if result.collider == to:
			return true
		else:
			return false
	else:
		return true
