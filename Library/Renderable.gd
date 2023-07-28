extends Resource
class_name Renderable

enum {ORC, GOBLIN, HUMAN, WALL, FLOOR, CEILING, ROOF, GROUND, SHALLOW_WATER, DEEP_WATER, TREE, STONE_WALL_TOP, STONE_WALL_ENTRANCE}
const scene_list = {
	FLOOR:preload("res://Entity/Structure/Floor.tscn"),
	CEILING:preload("res://Entity/Structure/Ceiling.tscn"),
	ROOF:preload("res://Entity/Structure/roof.tscn"),
	GROUND:preload("res://Entity/Terrain/ground.tscn"),
	HUMAN: preload("res://Entity/Creature/Human/Entity.tscn"),
	WALL: preload("res://Entity/Structure/Wall.tscn"),
	SHALLOW_WATER: preload("res://Entity/Terrain/shallow_water.tscn"),
	DEEP_WATER: preload( "res://Entity/Terrain/deep_water.tscn"),
	TREE:preload("res://Entity/Flora/Tree.tscn"),
	STONE_WALL_TOP:preload("res://Entity/Structure/Stone_Wall/top.tscn"),
	STONE_WALL_ENTRANCE:preload("res://Entity/Structure/Stone_Wall/entrance.tscn")
}

static func new_scene(id:int):
	return scene_list[id].instantiate()
