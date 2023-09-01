extends System
class_name Dialogue_System

static func run(delta:float, ECS:Entity_Component_System):
	for e_id in ECS.list_entity_with("conversation_engaged"):
		var entity = ECS.get_entity(e_id)
		var message = RNG.array_rand(entity.dialogue)
		#only 1 voice can play at a time, so stop previous audio
		DisplayServer.tts_stop()
		DisplayServer.tts_speak(message, entity.voice_id)
		var log_message = entity.name + ' says: "'
		log_message += message + '"'
		ECS.emit_signal("log_message",log_message)
		ECS.remove_component(e_id,"conversation_engaged")
