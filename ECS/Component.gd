class_name Component_Reference

var component = {}

func _init():
	component.combat_stats = {power=0.0,defense=0.0}
	component.dead = true #tag component
	component.health = {current=0.0,maximum=0.0}
	component.melee_hit = {targets=[]}
	component.monster = true #tag component
	component.move = Vector3(0,0,0) #direction
	component.name = "name" #display
	component.needs_render = Vector3(0,0,0) #position
	component.player = true #tag
	component.renderable = "model_path.tscn"
	component.rendered = Node.new() #node
	component.suffer_damage = [1.1] #array of damage amounts
	component.viewshed = 0.0 #range
	

