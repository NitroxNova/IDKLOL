extends System
class_name Inventory_System

static func run(delta:float, ECS:Entity_Component_System):
	pickup_items(delta,ECS)
	use_items(delta,ECS)
	drop_items(delta,ECS)

static func pickup_items(delta:float, ECS:Entity_Component_System):
	for e_id in ECS.list_entity_with("pickup_item"):
		var entity = ECS.get_entity(e_id)
		var i_id = entity.pickup_item
		entity.inventory.append(i_id)
		ECS.add_component(i_id,"contained_in",e_id)
		ECS.add_component(i_id,"needs_unrender",true)
		ECS.remove_component(e_id,"pickup_item")
		var item = ECS.get_entity(i_id)
		var message = entity.name + " picked up " + item.name
		ECS.emit_signal("log_message",message)
	

static func use_items(delta:float, ECS:Entity_Component_System):
	for e_id in ECS.list_entity_with("use_item"):
		var entity = ECS.get_entity(e_id)
		var i_id = entity.use_item
		var item = ECS.get_entity(i_id)
		var message = entity.name + " uses the " + item.name
		if "provides_healing" in item:
#			print("provides healing")
			message += ", healing " + str(item.provides_healing) + " hp"
			Healing_System.queue_healing(e_id,item.provides_healing,ECS)
		if "summons_projectile" in item:
#			print("summoning projectile")
			message += ", summoning a " + item.summons_projectile.name
			ECS.add_component(e_id,"summoning_projectile",i_id)
		if "consumable" in item:
			ECS.add_component(i_id,"needs_removal",true)
		ECS.emit_signal("log_message",message)
		ECS.remove_component(e_id,"use_item")
		

static func drop_items(delta:float, ECS:Entity_Component_System):
	for e_id in ECS.list_entity_with("drop_item"):
		var entity = ECS.get_entity(e_id)
		var i_id = entity.drop_item
		var item = ECS.get_entity(i_id)
		var position = entity.rendered.get_node("Hands").global_position
#		ECS.add_component(i_id,"needs_render",{position=position,rotation=Vector3.ZERO})	
		ECS.add_component(i_id,"needs_render",true)
		ECS.add_component(i_id,"position",position)
		ECS.add_component(i_id,"rotation",Vector3.ZERO)
		remove_from_inventory(i_id,ECS)	
		ECS.remove_component(e_id,"drop_item")
#		print("dropping item")

# ------------------- called from other functions -------------#

static func remove_from_inventory(item_id:int,ECS:Entity_Component_System):
	var item = ECS.get_entity(item_id)
	var container = ECS.get_entity(item.contained_in)
	container.inventory.erase(item_id)
	ECS.remove_component(item_id,"contained_in")
	
