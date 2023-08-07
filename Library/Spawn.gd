extends Resource
class_name Spawn

enum { #furniture
	CANDELABRUM, CHAIR, KEG, TABLE, HANGING_SIGN,
	#npcs
	BARKEEP, BLACKSMITH, PARISHONER, PATRON, PRIEST, SHADY_SALESMAN,
	#buildings
	TOWN_BUILDING, TOWN_BLACKSMITH, TOWN_PUB, TOWN_TEMPLE}

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
	TABLE : {
		renderable = Renderable.TABLE,
		name = "Table"
	},
	HANGING_SIGN : {
		renderable = Renderable.HANGING_SIGN,
		name = "Hanging Sign"	
	},
	BARKEEP : {
		renderable = Renderable.HUMAN,
		name = "Barkeep",
		genotype = {"woman1":1},
		clothes = ["dress_mini_03"]
	},
	BLACKSMITH : {
		renderable = Renderable.HUMAN,
		name = "Blacksmith",
		genotype = {"man":1},
		clothes = ["male_shirt_01","male_jeans_01"]
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
		genotype = {"man":1},
		clothes = ["male_shirt_01","male_jeans_01"]
	},
	PRIEST : {
		renderable = Renderable.HUMAN,
		name = "Priest",
		genotype = {"man":1},
		clothes = ["male_shirt_01","male_jeans_01"]
	},
	SHADY_SALESMAN : {
		renderable = Renderable.HUMAN,
		name = "Shady Salesman",
		genotype = {"man":1},
		clothes = ["male_jeans_01"]
	},
	TOWN_BUILDING : {
		spawn_list = []
	},
	TOWN_BLACKSMITH : {
		spawn_list = [BLACKSMITH],
		icon = "anvil"
	},
	TOWN_PUB : {
		spawn_list = [BARKEEP,SHADY_SALESMAN,PATRON,PATRON,KEG,TABLE,CHAIR,TABLE,CHAIR],
		icon = "beer"
	},
	TOWN_TEMPLE : {
		spawn_list = [PRIEST, PARISHONER, PARISHONER, CHAIR, CHAIR, CANDELABRUM, CANDELABRUM],
		icon = "sun"
	}
}

static func get_data(spawn_id:int, needs_render = true):
	#have to duplicate because we cant, and dont want to, edit the constant list
	var data = list[spawn_id].duplicate(true)
	if needs_render:
		data.needs_render = true
	return data
