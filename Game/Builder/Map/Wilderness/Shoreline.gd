extends Map_Builder
class_name Shoreline_Builder

var water_width = []

func _init(width,height):
	set_size(width,height,TILE_TYPE.grass)
	water()

func water():
	var n = randi()
	for y in size.y:
#		var n_water = sin(n) * 10.0 + 14 + randi_range(1,6)
		var n_water = sin(n) * (size.x * .25) + (size.x * .6) + randf_range(0,size.x*.15) -3
#		var n_water = sin(n) * (size.x * .80) + randf_range(0,size.x * .20 -3)
		water_width.append(n_water)
		n += 0.1
		for x in n_water:
			tiles[x][y] = TILE_TYPE.deep_water
		for x in 3:
			tiles[x+n_water][y] = TILE_TYPE.shallow_water
