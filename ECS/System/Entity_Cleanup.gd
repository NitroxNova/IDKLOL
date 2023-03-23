extends System
class_name Entity_Cleanup_System

static  func run(delta:float,ECS:Entity_Component_System):
	for e_id in ECS.list_entity_with("needs_removal"):
		var entity = ECS.get_entity(e_id)
		if "contained_in" in entity:
			Inventory_System.remove_from_inventory(e_id,ECS)
		if "rendered" in entity:
			entity.rendered.queue_free()
		ECS.remove_entity(e_id)
			
		
		
