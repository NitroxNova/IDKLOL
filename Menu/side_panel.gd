extends PanelContainer

func log_message(message:String):
	var label = Label.new()
	label.text = message
	$VBox/Log/VBox.add_child(label)
	$VBox/Log/VBox.move_child(label,0)
	if $VBox/Log/VBox.get_child_count() > 100:
		var last_child = $VBox/Log/VBox.get_child(100)
		$VBox/Log/VBox.remove_child(last_child)

func set_player_name(p_name:String):
	$VBox/Player_Name.text = p_name


func _on_Quit_pressed():
	get_tree().quit()


func _on_Menu_pressed():
	get_tree().change_scene("res://Menu/Start/Start_Menu.tscn")
