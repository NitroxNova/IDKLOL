extends HSplitContainer

var state : State
var looking_at : int = -1
var current_interaction = INTERACT_TYPE.none
enum INTERACT_TYPE {none,pickup_item,talk}

func _ready():
	state = State.new()
	state.ECS.connect("log_message",log_message)
	state.ECS.connect("render_entity",render_entity)
	state.ECS.connect("update_camera",update_camera)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	clear_looking_at_text()

func pause_game():
	$Game_Window/SubViewport.process_mode = Node.PROCESS_MODE_DISABLED

func unpause_game():
	$Game_Window/SubViewport.process_mode = Node.PROCESS_MODE_INHERIT
	
func update_camera():
	var player = state.current_player
	var minimap_xform = player.rendered.get_node("Minimap_Remote_XForm")
#	print(minimap_xform)	
	var remote_path = minimap_xform.get_path_to($Game_Window/SubViewport/PanelContainer/Mini_Map/SubViewport/Camera3D)
#	print(remote_path)
	minimap_xform.remote_path = remote_path

func update_menu():
	var player = state.current_player
	update_inventory(player.inventory)
	$Game_Window/SubViewport/VBox/Health_Bar.value = player.health.current
	$Game_Window/SubViewport/VBox/Health_Bar.max_value = player.health.maximum
	set_player_name(player.name)

func new_game(player_name : String,genotype:Dictionary,clothes:Array):
	var ECS = state.ECS
	var world_builder = World_Builder.new()
	world_builder.connect("create_entity",state.ECS.create_entity)
	world_builder.build()
#	var dm = Dungeon_Builder.new(80,50,3,state)
#	var first_room = dm.levels[0].rooms[0].get_center()
#	var player_pos = Vector3(first_room.x*2,0,first_room.y*2)
	var player_pos = world_builder.get_starting_position()
	var player_id = Player_Builder.new(player_name,player_pos,genotype,clothes,state).build()
	state.set_current_player(player_id)
	state.save_file = "user://save/" + player_name + "_" + str(Time.get_unix_time_from_system()) + ".save"
	update_menu()
#
func load_game(file_path:String):
	state.save_file = file_path
	state.current_player = Save_System.load_file(state.ECS, file_path)
	update_menu()
	
func check_looking_at() -> bool: #true if changed, false if the same
	var player = state.current_player
	var looking_toward = player.rendered.get_node("Direction_Facing")
	looking_toward.force_raycast_update()
	var temp_look = -1 #default to nothing
	if looking_toward.is_colliding():
		var collider = looking_toward.get_collider()
		temp_look = collider.e_id
	if looking_at == temp_look:
		return false
	else:
		looking_at = temp_look
		return true
	
func set_looking_at_text(text:String):
	$Game_Window/SubViewport/Looking_At.text = text

func clear_looking_at_text():
	set_looking_at_text("")
	
func set_interact_text(text:String):
	$Game_Window/SubViewport/VBox/Interact.text = text

func clear_interact_text():
	set_interact_text("")

func interact_with_target():
	if current_interaction == INTERACT_TYPE.none:
		state.state = state.NEEDS_INPUT
	elif current_interaction == INTERACT_TYPE.pickup_item:
		state.ECS.add_component(state.current_player_id,"pickup_item",looking_at)
		state.state = state.RUN
	elif current_interaction == INTERACT_TYPE.talk:
		state.ECS.add_component(looking_at,"conversation_engaged",true)
		state.state = state.RUN
	

func _input(event):
	var player = state.current_player
	var looking_toward = player.rendered.get_node("Direction_Facing")
	var camera = looking_toward.get_node("Player_Camera")
	if event.is_action_pressed("interact"):
		interact_with_target()
#		pickup_item()
	elif Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if event.is_action_pressed("escape"):
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		if event is InputEventMouseMotion:
			look_around(event.relative)
		elif event.is_action_pressed("zoom_in"):
			camera.zoom_in()
		elif event.is_action_pressed("zoom_out"):
			camera.zoom_out()
			
	var look_changed = check_looking_at()
#	print(looking_at)
	if look_changed:
		if looking_at == -1: #not looking at anything
			clear_looking_at_text()
			clear_interact_text()
		else:
			var l_entity = state.ECS.get_entity(looking_at)
			if "name" in l_entity:
				set_looking_at_text(l_entity.name)
			else:
				set_looking_at_text("unnamed entity")
			#set interact text
			if "dialogue" in l_entity:
				set_interact_text("[E] Talk to " + l_entity.name)
				current_interaction = INTERACT_TYPE.talk
			elif "item" in l_entity:
				set_interact_text("[E] Pick-Up " + l_entity.name)
				current_interaction = INTERACT_TYPE.pickup_item
			else:
				clear_interact_text()
				current_interaction = INTERACT_TYPE.none

func look_around(amount:Vector2):
	var player = state.current_player
	var looking_toward = player.rendered.get_node("Direction_Facing")
	var x_rotation = amount.x * -0.005
	looking_toward.rotate_y(x_rotation)
	
	var max_up_down : float = PI/2
	var y_rotation = amount.y * 0.005
	var new_rotation = looking_toward.rotation.x + y_rotation
	new_rotation = min(new_rotation,max_up_down)
	new_rotation = max(new_rotation, -1 * max_up_down)
	looking_toward.rotation.x = new_rotation
	
			
func _physics_process(delta):
	if state.state == state.RUN:
		unpause_game()
		state.run_systems(delta)
		update_menu()
		if "dead" in state.current_player:
			state.state = state.PLAYER_DEAD
		else:
			state.state = state.NEEDS_INPUT
	else:
		pause_game()

func _process(delta):
	if state.state == state.NEEDS_INPUT:
		var player = state.current_player
		var move_direction = Vector3.ZERO
		var turn_rotation : float = 0
		if Input.is_action_pressed("move_left"):
#			move_direction += player.rendered.global_transform.basis.x
			turn_rotation += delta * 3
		if Input.is_action_pressed("move_right"):
#			move_direction -= player.rendered.global_transform.basis.x
			turn_rotation -= delta * 3
		if Input.is_action_pressed("move_forward"):
			move_direction += player.rendered.global_transform.basis.z
		if Input.is_action_pressed("move_back"):
			move_direction -= player.rendered.global_transform.basis.z
		if not move_direction == Vector3.ZERO:
			move_direction = move_direction.normalized()
			move_direction *= player.movement_speed
			if not player.rendered.is_on_floor():
				move_direction += Vector3.DOWN * 5
			state.ECS.add_component(state.current_player_id,"move",move_direction)
			state.state = state.RUN
		if not turn_rotation == 0:
			state.ECS.add_component(state.current_player_id,"rotate",turn_rotation)
			state.state = state.RUN
			

func render_entity(entity:Node):
#	print("rendering entity")
	$Game_Window/SubViewport.add_child(entity)

func save():
	state.save()

func quit():
	get_tree().quit()
	
func update_inventory(inventory:Array):
	var item_list = $Side_Panel/VBox/TabContainer/Inventory/ItemList
	item_list.clear()
	for item_id in inventory:
		var item = state.ECS.get_entity(item_id)
		item_list.add_item(item.name)
	

func set_player_name(value:String):
	$Side_Panel/VBox/Player_Name.text = value

func log_message(message:String):
	var label = Label.new()
	label.text = message
	var log = $Side_Panel/VBox/TabContainer/Log
	log.add_child(label)
	log.move_child(label,0)
	if log.get_child_count() > 100:
		var last_child = log.get_child(100)
		log.remove_child(last_child)

func _on_menu_pressed():
	get_tree().change_scene_to_file("res://Menu/Start/Start_Menu.tscn")

func use_item():
	var item_list = $Side_Panel/VBox/TabContainer/Inventory/ItemList
	var selected_items = item_list.get_selected_items()
	if not selected_items.is_empty():
		var selected = selected_items[0]
		var player = state.current_player
		var item_id = player.inventory[selected]
		state.ECS.add_component(state.current_player_id,"use_item",item_id)
		state.state = state.RUN
	
func drop_item():	
	var item_list = $Side_Panel/VBox/TabContainer/Inventory/ItemList
	var selected_items = item_list.get_selected_items()
	if not selected_items.is_empty():
		var selected = selected_items[0]
		var player = state.current_player
		var item_id = player.inventory[selected]
		state.ECS.add_component(state.current_player_id,"drop_item",item_id)
		state.state = state.RUN
		
func _on_game_window_gui_input(event):
	if event.is_action_pressed("left_click"):
		if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("middle_mouse"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
