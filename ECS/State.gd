extends Resource
class_name State

enum {NEEDS_INPUT,RUN,PLAYER_DEAD}

var state = RUN
var current_player : int
var ECS = Entity_Component_System.new()
var save_file : String

func run_systems(delta):
	Render_System.run(delta,ECS)
	Inventory_System.run(delta,ECS)
	Monster_AI_System.run(delta,ECS)
	Confusion_System.run(delta,ECS)
	Move_System.run(delta,ECS)
	Projectile_System.run(delta,ECS)
	Area_Of_Effect_System.run(delta,ECS)
	Combat_System.run(delta,ECS)
	Damage_System.run(delta,ECS)
	Healing_System.run(delta,ECS)
	Check_For_Dead_System.run(delta,ECS)
	Duration_System.run(delta,ECS)
	Render_System.run(delta,ECS)
	Entity_Cleanup_System.run(delta,ECS)

func save():
	Save_System.save(ECS,save_file,current_player)