extends Resource
class_name World_Builder

var starting_position = Vector3(0,0,0)

signal create_entity

func build():
	var pier_builder = Pier_Builder.new(30,50)
	pier_builder.connect("create_entity",emit_create_entity)
	pier_builder.position = Vector2(-30,0)
	pier_builder.render()

	var town_builder = Town_Builder.new(50,50)
	town_builder.connect("create_entity",emit_create_entity)
	town_builder.render()
	starting_position = town_builder.get_starting_position()

	var forest_builder = Forest_Builder.new()
	forest_builder.connect("create_entity",emit_create_entity)
	forest_builder.set_size(40,50)
	forest_builder.set_position(50,0)
	forest_builder.starting_position = Vector3(0,0,town_builder.wall_gap_y)
	forest_builder.build()
	forest_builder.render()
	
func emit_create_entity(data):
	emit_signal("create_entity",data)
	
func get_starting_position():
	return starting_position
