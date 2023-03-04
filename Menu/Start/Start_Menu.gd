extends PanelContainer

func _on_Quit_pressed():
	get_tree().quit()

func _on_New_pressed():
	get_tree().change_scene_to_file("res://Menu/Start/New_Game.tscn")

func _on_Load_pressed():
	get_tree().change_scene_to_file("res://Menu/Start/Load_Game.tscn")
