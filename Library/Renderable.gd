extends Resource
class_name Renderable

enum {BARREL,CANDELABRUM, CEILING, CHAIR, FLOOR, GOBLIN, HANGING_SIGN, HUMAN, ORC, SINGLE_BED, TABLE, ROOF, WALL, GROUND, SHALLOW_WATER, DEEP_WATER, TREE, STONE_WALL_TOP, STONE_WALL_ENTRANCE}
const scene_list = {
	BARREL:preload("res://Entity/Furniture/Barrel/barrel.tscn"),
	CANDELABRUM:preload("res://Entity/Furniture/Candelabrum/entity.tscn"),
	CEILING:preload("res://Entity/Structure/Ceiling.tscn"),
	CHAIR:preload("res://Entity/Furniture/Chair/chair.tscn"),
	FLOOR:preload("res://Entity/Structure/Floor.tscn"),
	GROUND:preload("res://Entity/Terrain/ground.tscn"),
	HANGING_SIGN:preload("res://Entity/Structure/Hanging_Sign/hanging_sign.tscn"),
	HUMAN: preload("res://Entity/Creature/Human/Entity.tscn"),
	ROOF:preload("res://Entity/Structure/roof.tscn"),
	SINGLE_BED:preload("res://Entity/Furniture/Bed/single_bed.tscn"),
	TABLE:preload("res://Entity/Furniture/Table/table.tscn"),
	WALL: preload("res://Entity/Structure/Wall.tscn"),
	SHALLOW_WATER: preload("res://Entity/Terrain/shallow_water.tscn"),
	DEEP_WATER: preload( "res://Entity/Terrain/deep_water.tscn"),
	TREE:preload("res://Entity/Flora/Tree.tscn"),
	STONE_WALL_TOP:preload("res://Entity/Structure/Stone_Wall/top.tscn"),
	STONE_WALL_ENTRANCE:preload("res://Entity/Structure/Stone_Wall/entrance.tscn")
}

static func new_scene(id:int):
	return scene_list[id].instantiate()
