extends Node
class_name Material_3D

enum {GRASS, GRAVEL, RED_BRICK, ROAD, THATCH, OAK_PLANKS, DARK_PLANKS, GREY_BRICK}

const resource_list = {
	GRASS:preload("res://Asset/Material/grass001.tres"),
	GRAVEL:preload("res://Asset/Material/rocks006.tres"),
	RED_BRICK:preload("res://Asset/Material/Bricks012.tres"),
	ROAD:preload("res://Asset/Material/pavingstones050.tres"),
	THATCH:preload("res://Asset/Material/ThatchedRoof002A.tres"),
	DARK_PLANKS:preload("res://Asset/Material/Planks012.tres"),
	OAK_PLANKS:preload("res://Asset/Material/Planks031A.tres"),
	GREY_BRICK:preload("res://Asset/Material/PavingStones037.tres")
}

static func get_material(id):
	return resource_list[id]
