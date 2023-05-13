extends Resource
class_name Renderable

enum {ORC, GOBLIN, PLAYER, WALL, FLOOR, CEILING, ROOF, GROUND, SHALLOW_WATER, DEEP_WATER, TREE, STONE_WALL_TOP, STONE_WALL_ENTRANCE}
const scene_list = {
	FLOOR:preload("res://Game/Entity/Structure/Floor.tscn"),
	CEILING:preload("res://Game/Entity/Structure/Ceiling.tscn"),
	ROOF:preload("res://Game/Entity/Structure/roof.tscn"),
	GROUND:preload("res://Game/Entity/ground.tscn"),
	PLAYER: preload("res://Game/Entity/Player.tscn"),
	WALL: preload("res://Game/Entity/Structure/Wall.tscn"),
	SHALLOW_WATER: preload("res://Game/Entity/shallow_water.tscn"),
	DEEP_WATER: preload( "res://Game/Entity/deep_water.tscn"),
	TREE:preload("res://Game/Entity/Tree.tscn"),
	STONE_WALL_TOP:preload("res://Game/Entity/Structure/Stone_Wall/top.tscn"),
	STONE_WALL_ENTRANCE:preload("res://Game/Entity/Structure/Stone_Wall/entrance.tscn")
}

static func new_scene(id:int):
	return scene_list[id].instantiate()
