class_name Component_Reference

var component = {}

func _init():
	component.area_of_effect = {damage=3.0,particles="particle_scene.tscn"}
	component.combat_stats = {power=2.0,defense=3.0}
	component.confused = 1.2 #seconds remaining of confusion
	component.consumable = true #tag
	component.contained_in = 123 #container or player id
	component.dead = true #tag component
	component.drop_item = 123 #item id to drop
	component.duration = 12.3 #timer in seconds, delete when 0
	component.health = {current=5.0,maximum=6.0}
	component.inflicts_confusion = 1.2 #seconds of confusion
	component.inflicts_damage = 12.3
	component.inventory = []
	component.item = true #tag
	component.linear_velocity = Vector3(1,2,3) # for Rigid bodies,remove after rendering and use node linear_velocity instead
	component.material = "path_to_material"
	component.melee_hit = [123,456]
	component.monster = true #tag component
	component.move = Vector3(0,0,0) #velocity (direction and speed)
	component.movement_speed = 12.3 #movement speed in meters per second, how fast it can move not how fast it is currently moving
	component.name = "name" #display
	component.needs_removal = true # queued for deletion
	component.needs_render = {linear_velocity=Vector3(1,2,3)} #linear_velocity optional for rigid bodies
	component.needs_unrender = Vector3(0,0,0) #position
	component.pickup_item = 123 #item id
	component.player = true #tag
	component.position = Vector3(0,0,0) # remove after rendering and use node position instead
	component.projectile = true
	component.projectile_hit = 123 #id of entity hit
	component.provides_healing = 12.3 #amount healed
	component.ranged = 12.3 #distance on spell (remaining for projectile, total on scroll)
	component.ranged_hit = [123,456] # array of entity ids hit by projectile or aoe
	component.renderable = Renderable.ORC #id for render type
	component.rendered = Node.new() #node
	component.receive_healing = [1.1] # array of healing amounts
	component.rotation = Vector3(0,0,0) # remove after rendering and use node rotation instead
	component.scale = Vector3(1,1,1) #remove after rendering and use node scale instead
	component.suffer_damage = [1.1] #array of damage amounts
	component.summoning_area_of_effect = true #generates AOE
	component.summoning_projectile = 123 #scroll id
	component.summons_projectile = {scene="scene_path.tscn",name="projectile name",speed=12.3} #speed (meters per second) is multiplied by direction facing to get velocity
	component.use_item = 123 #id of item to use
	component.viewshed = 0.0 #range
	

