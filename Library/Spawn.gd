extends Resource
class_name Spawn

enum { #furniture
	CANDELABRUM, CHAIR, KEG, TABLE, HANGING_SIGN, SINGLE_BED,
	#npcs
	NPC_ALCHEMIST, BARKEEP, NPC_BLACKSMITH, NPC_CLOTHIER, PARISHONER, PATRON, NPC_PEASANT, PRIEST, SHADY_SALESMAN,
	#buildings
	TOWN_BUILDING, TOWN_ALCHEMIST, TOWN_BLACKSMITH, TOWN_CLOTHIER, TOWN_HOVEL, TOWN_PUB, TOWN_TEMPLE}

const list = {
	CANDELABRUM : {
		renderable = Renderable.CANDELABRUM,
		name = "Candelabrum"
	},
	CHAIR : {
		renderable = Renderable.CHAIR,
		name = "Chair"
	},
	KEG : {
		renderable = Renderable.BARREL,
		name = "Keg"
	},
	SINGLE_BED : {
		renderable = Renderable.SINGLE_BED,
		name = "Single Bed"
	},
	TABLE : {
		renderable = Renderable.TABLE,
		name = "Table"
	},
	HANGING_SIGN : {
		renderable = Renderable.HANGING_SIGN,
		name = "Hanging Sign"	
	},
	NPC_ALCHEMIST : {
		renderable = Renderable.HUMAN,
		name = "Alchemist",
		genotype = {"woman1":1},
		clothes = ["hermitess_robe"]
	},
	BARKEEP : {
		renderable = Renderable.HUMAN,
		name = "Barkeep",
		genotype = {"man":1},
		clothes = ["male_shirt_01","male_trousers","leather_vest"]
	},
	NPC_BLACKSMITH : {
		renderable = Renderable.HUMAN,
		name = "Blacksmith",
		genotype = {"man":1},
		clothes = ["male_shirt_01","male_jeans_01","blacksmith_apron","full_beard"]
	},
	NPC_CLOTHIER : {
		renderable = Renderable.HUMAN,
		name = "Clothier",
		genotype = {"woman1":1},
		clothes = ["medieval_dress","hair_bow_tie"]
	},
	PARISHONER : {
		renderable = Renderable.HUMAN,
		name = "Parishoner",
		genotype = {"woman1":1},
		clothes = ["dress_mini_03"]
	},
	PATRON : {
		renderable = Renderable.HUMAN,
		name = "Patron",
		genotype = {"woman1":1},
		clothes = ["summer_dress","hair_long_braids"]
	},
	PRIEST : {
		renderable = Renderable.HUMAN,
		name = "Priest",
		genotype = {"man":1},
		clothes = ["male_shirt_01","male_jeans_01"]
	},
	NPC_PEASANT : {
		renderable = Renderable.HUMAN,
		name = "Peasant",
		genotype = {"man":1},
		clothes = ["crude_male_shirt","crude_loose_pants"]
	},
	SHADY_SALESMAN : {
		renderable = Renderable.HUMAN,
		name = "Shady Salesman",
		genotype = {"man":1},
		clothes = ["crude_male_shirt","male_jeans_01","crude_hat","trench_coat"]
	},
	TOWN_BUILDING : {
		spawn_list = [],
		material = [Material_3D.GREY_BRICK,Material_3D.RED_BRICK]
	},
	TOWN_ALCHEMIST : {
		spawn_list = [NPC_ALCHEMIST],
		icon = "res://Entity/Structure/Hanging_Sign/textures/alchemist.png",
		material = [Material_3D.RED_BRICK,Material_3D.DARK_PLANKS]
	},
	TOWN_BLACKSMITH : {
		spawn_list = [NPC_BLACKSMITH],
		icon = "res://Entity/Structure/Hanging_Sign/textures/anvil.png",
		material = [Material_3D.RED_BRICK,Material_3D.DARK_PLANKS]
	},
	TOWN_CLOTHIER : {
		spawn_list = [NPC_CLOTHIER,TABLE],
		icon = "res://Entity/Structure/Hanging_Sign/textures/thread.png",
		material = [Material_3D.RED_BRICK,Material_3D.DARK_PLANKS]
	},
	TOWN_HOVEL : {
		spawn_list = [NPC_PEASANT,SINGLE_BED,CHAIR,TABLE],
		material = [Material_3D.OAK_PLANKS,Material_3D.THATCH]
	},
	TOWN_PUB : {
		spawn_list = [BARKEEP,SHADY_SALESMAN,PATRON,PATRON,KEG,TABLE,CHAIR,TABLE,CHAIR],
		icon = "res://Entity/Structure/Hanging_Sign/textures/beer.png",
		material = [Material_3D.RED_BRICK,Material_3D.DARK_PLANKS]
	},
	TOWN_TEMPLE : {
		spawn_list = [PRIEST, PARISHONER, PARISHONER, CHAIR, CHAIR, CANDELABRUM, CANDELABRUM],
		icon = "res://Entity/Structure/Hanging_Sign/textures/sun.png",
		material = [Material_3D.RED_BRICK,Material_3D.DARK_PLANKS]
	}
}

static func get_data(spawn_id:int, needs_render = true):
	#have to duplicate because we cant, and dont want to, edit the constant list
	var data = list[spawn_id].duplicate(true)
	if needs_render:
		data.needs_render = true
	return data
