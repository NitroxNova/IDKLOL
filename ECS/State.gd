extends Resource
class_name State

enum {NEEDS_INPUT,RUN,PLAYER_DEAD,SAVE}

var state = RUN
var current_player : int
var ECS = Entity_Component_System.new()
var save_file : String

signal log_message
signal render_entity
signal player_health

