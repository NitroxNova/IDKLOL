extends PanelContainer

var file_list = []

func _ready():
	var files = DirAccess.get_files_at("user://save")
	for file_name in files:
		file_list.append("user://save/" + file_name)
		$VBox/Saves/ItemList.add_item(file_name.trim_suffix(".save"))

func _on_Back_pressed():
	get_tree().change_scene_to_file("res://Menu/Start/Start_Menu.tscn")

func _on_Load_pressed():
	if $VBox/Saves/ItemList.is_anything_selected():
		var selected = $VBox/Saves/ItemList.get_selected_items()[0]
		var file_name = file_list[selected]
		var game = load("res://Game/Main.tscn").instantiate()
		game.connect("ready",Callable(game,"load_game").bind(file_name))
		var tree = get_tree()
		tree.get_root().remove_child(self) 
		tree.get_root().add_child(game)
		tree.current_scene = game

func _on_Delete_pressed():
	if $VBox/Saves/ItemList.is_anything_selected():
		var selected = $VBox/Saves/ItemList.get_selected_items()[0]
		var file_name = file_list[selected]
		file_list.remove_at(selected)
		$VBox/Saves/ItemList.remove_item(selected)
		DirAccess.remove_absolute(file_name)
		
