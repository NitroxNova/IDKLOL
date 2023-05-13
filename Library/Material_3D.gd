extends Node
class_name Material_3D

enum {GRASS, GRAVEL, ROAD, WOOD}

const resource_list = {
	GRASS:preload("res://Asset/Material/grass001.tres"),
	GRAVEL:preload("res://Asset/Material/rocks006.tres"),
	ROAD:preload("res://Asset/Material/pavingstones050.tres"),
	WOOD:preload("res://Asset/Material/Planks012.tres")
}

static func get_material(id):
	return resource_list[id]
