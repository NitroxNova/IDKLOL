extends Node

var rng = RandomNumberGenerator.new()

func _init():
	randomize()
	rng.randomize()

func randi_range(x1:int,x2:int):
	return rng.randi_range(x1,x2)

func randf_range(x1:float,x2:float):
	return rng.randf_range(x1,x2)

func array_rand(array:Array):
	var index = randi_range(0,array.size()-1)
	return array[index]
