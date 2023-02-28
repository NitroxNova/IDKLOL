extends Spatial
#
var state : State
#
func _ready():
	state = State.new()
	state.connect("log_message",$side_panel,"log_message")
	state.connect("render_entity",self,"render_entity")
	state.connect("player_health",$side_panel/VBox/Health_Bar,"set_value")

func update_menu():
	var player = state.ECS.get_entity(state.current_player)
	$side_panel/VBox/Health_Bar.set_max(player.health.maximum)
	$side_panel/VBox/Health_Bar.set_value(player.health.current)
	$side_panel.set_player_name(player.name)

func new_game(player_name : String):
	var ECS = state.ECS
	var dm = Dungeon_Builder.new(80,50,state)
	var first_room = dm.rooms[0].get_center()*2
	var player_pos = Vector3(first_room.x,-1,first_room.y)
	
	var p_data = {}
	p_data.player = true
	p_data.name = player_name
	p_data.renderable = "res://Game/Entity/Player.tscn"
	p_data.needs_render = player_pos
	p_data.combat_stats = {power=5.0,defense=2.0}
	p_data.health = {current=30.0,maximum=30.0}
	p_data.viewshed = 16
	state.current_player = ECS.create_entity(p_data)

	state.save_file = "user://save/" + player_name + "_" + str(OS.get_unix_time()) + ".save"
	update_menu()
#
func load_game(file_path:String):
	state.save_file = file_path
	Save_System.load_file(state)
	update_menu()
#
func run_systems(delta):
	Render_System.run(delta,state)
	Monster_AI_System.run(delta,state)
	Move_System.run(delta,state)
	Combat_System.run(delta,state)
	Damage_System.run(delta,state)
	Check_For_Dead_System.run(delta,state)
#
func _physics_process(delta):
	if state.state == state.SAVE:
		Save_System.save(state)
		state.state = state.NEEDS_INPUT
	elif state.state == state.RUN:
		run_systems(delta)
		if "dead" in state.ECS.get_entity(state.current_player):
			state.state = state.PLAYER_DEAD
		else:
			state.state = state.NEEDS_INPUT
#
func _process(delta):
	if state.state == state.NEEDS_INPUT:
		var move_direction = Vector3.ZERO
		if Input.is_action_pressed("move_left"):
			move_direction += Vector3.LEFT
		if Input.is_action_pressed("move_right"):
			move_direction += Vector3.RIGHT
		if Input.is_action_pressed("move_forward"):
			move_direction += Vector3.FORWARD
		if Input.is_action_pressed("move_back"):
			move_direction += Vector3.BACK
		move_direction = move_direction.normalized()
		move_direction *= 10
		if not move_direction == Vector3.ZERO:
			move_direction += Vector3.DOWN
			state.ECS.add_component(state.current_player,"move",move_direction)
			state.state = state.RUN

func render_entity(entity:Node):
	add_child(entity)

func _on_Save_pressed():
	state.state = state.SAVE
